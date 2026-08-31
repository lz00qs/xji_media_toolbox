import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xji_footage_toolbox/constants.dart';
import 'package:xji_footage_toolbox/models/ffmpeg_configuration.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';
import 'package:xji_footage_toolbox/providers/settings.notifier.dart';
import 'package:xji_footage_toolbox/storage/settings_store.dart';

import '../helpers/test_environment.dart';

void main() {
  late Directory temporaryDirectory;
  late _SettingsHarness harness;
  late ProviderContainer container;

  setUp(() async {
    temporaryDirectory = await createTestDirectory('settings-notifier-test');
    harness = await _SettingsHarness.create(temporaryDirectory);
    container = ProviderContainer(
      overrides: [
        settingsProvider.overrideWith(
          () => SettingsNotifier(dependencies: harness.dependencies),
        ),
      ],
    );
  });

  tearDown(() async {
    container.dispose();
    await deleteTestDirectory(temporaryDirectory);
  });

  test('build exposes safe defaults before asynchronous initialization', () {
    expect(container.read(settingsProvider), const Settings());
  });

  test(
    'initializes defaults and loads preferences and environment values',
    () async {
      harness.preferences = await _mockPreferences({
        defaultTranscodePresetIndexPrefKey: 99,
        sortTypePrefKey: SortType.sequence.index,
        sortOderPrefKey: false,
        exportCmdOnlyPrefKey: true,
        customFFmpegDirectoryPrefKey: '/configured/ffmpeg',
      });
      harness.initializationResult = const FFmpegConfiguration(
        source: FFmpegSource.custom,
        directory: '/active/ffmpeg',
        ffmpegPath: '/active/ffmpeg/ffmpeg',
        ffprobePath: '/active/ffmpeg/ffprobe',
        version: '9.1',
      );

      await container.read(settingsProvider.notifier).initSettings();
      final settings = container.read(settingsProvider);

      expect(settings.transcodingPresets, [
        const TranscodePreset(id: 1, name: 'Default'),
      ]);
      expect(settings.defaultTranscodePresetId, 1);
      expect(
        settings.sort,
        const Sort(sortType: SortType.sequence, sortAsc: false),
      );
      expect(settings.cpuThreads, 12);
      expect(settings.appVersion, '2.3.4-test');
      expect(settings.exportCmdOnly, isTrue);
      expect(settings.customFFmpegDirectory, '/configured/ffmpeg');
      expect(settings.activeFFmpegDirectory, '/active/ffmpeg');
      expect(settings.ffmpegVersion, '9.1');
      expect(settings.ffmpegSource, FFmpegSource.custom);
      expect(harness.initializedDirectories, ['/configured/ffmpeg']);
    },
  );

  test(
    'falls back to name sorting for an invalid persisted sort index',
    () async {
      harness.preferences = await _mockPreferences({sortTypePrefKey: 999});

      await container.read(settingsProvider.notifier).initSettings();

      expect(container.read(settingsProvider).sort.sortType, SortType.name);
    },
  );

  test(
    'loads existing records and falls back from a missing default preset',
    () async {
      final lut = await harness.store.putLut(
        const Lut(name: 'Film', path: '/stored/film.cube'),
      );
      final first = await harness.store.putTranscodePreset(
        TranscodePreset(name: 'First', lutId: lut.id),
      );
      await harness.store.putTranscodePreset(
        const TranscodePreset(name: 'Second'),
      );
      harness.preferences = await _mockPreferences({
        defaultTranscodePresetIndexPrefKey: 400,
      });

      await container.read(settingsProvider.notifier).initSettings();
      final settings = container.read(settingsProvider);

      expect(settings.luts, [lut]);
      expect(settings.transcodingPresets, hasLength(2));
      expect(settings.defaultTranscodePresetId, first.id);
    },
  );

  test(
    'adds, updates, selects, and removes presets while preserving a default',
    () async {
      final notifier = container.read(settingsProvider.notifier);
      await notifier.initSettings();
      await notifier.addTranscodePreset(
        const TranscodePreset(name: 'Delivery', crf: 18),
      );
      final delivery = container.read(settingsProvider).transcodingPresets.last;

      await notifier.updateTranscodePreset(delivery.copyWith(name: 'Archive'));
      notifier.setDefaultTranscodePreset(delivery.id);
      await notifier.removeTranscodePreset(delivery.id);

      final settings = container.read(settingsProvider);
      expect(settings.transcodingPresets, [
        const TranscodePreset(id: 1, name: 'Default'),
      ]);
      expect(settings.defaultTranscodePresetId, 1);
      expect(harness.preferences.getInt(defaultTranscodePresetIndexPrefKey), 1);
    },
  );

  test('rejects unknown defaults and deletion of the last preset', () async {
    final notifier = container.read(settingsProvider.notifier);
    await notifier.initSettings();

    notifier.setDefaultTranscodePreset(999);
    await notifier.removeTranscodePreset(1);

    expect(container.read(settingsProvider).transcodingPresets, hasLength(1));
    expect(container.read(settingsProvider).defaultTranscodePresetId, 1);
    expect(harness.errors, [
      'Transcode Preset not found',
      'Cannot delete the last Transcode Preset',
    ]);
  });

  test(
    'copies, updates, and removes LUTs while clearing preset references',
    () async {
      final source = File(p.join(temporaryDirectory.path, 'source.cube'));
      await source.writeAsString('LUT_3D_SIZE 2');
      final notifier = container.read(settingsProvider.notifier);
      await notifier.initSettings();

      await notifier.addLut(Lut(name: 'Film', path: source.path));
      final storedLut = container.read(settingsProvider).luts.single;
      final expectedPath = p.join(
        harness.applicationSupportDirectory.path,
        'luts',
        'user',
        '1.cube',
      );
      expect(storedLut.path, expectedPath);
      expect(await File(expectedPath).readAsString(), 'LUT_3D_SIZE 2');

      await notifier.updateLut(storedLut.copyWith(name: 'Updated Film'));
      await notifier.addTranscodePreset(
        TranscodePreset(name: 'Delivery', lutId: storedLut.id),
      );
      await notifier.removeLut(storedLut.id);

      final settings = container.read(settingsProvider);
      expect(settings.luts, isEmpty);
      expect(settings.transcodingPresets.last.lutId, 0);
      expect(await File(expectedPath).exists(), isFalse);
    },
  );

  test(
    'rejects a missing LUT source without changing storage or state',
    () async {
      final notifier = container.read(settingsProvider.notifier);
      await notifier.initSettings();

      await notifier.addLut(
        Lut(
          name: 'Missing',
          path: p.join(temporaryDirectory.path, 'missing.cube'),
        ),
      );

      expect(container.read(settingsProvider).luts, isEmpty);
      expect(harness.store.snapshot.luts, isEmpty);
      expect(harness.errors, ['LUT file not found']);
    },
  );

  test(
    'persists sorting and export preferences and updates debug state',
    () async {
      final notifier = container.read(settingsProvider.notifier);
      await notifier.initSettings();

      notifier.setSort(const Sort(sortType: SortType.size, sortAsc: false));
      notifier.setExportCmdOnly(true);
      notifier.setIsDebugMode(false);

      final settings = container.read(settingsProvider);
      expect(
        settings.sort,
        const Sort(sortType: SortType.size, sortAsc: false),
      );
      expect(settings.exportCmdOnly, isTrue);
      expect(settings.isDebugMode, isFalse);
      expect(harness.preferences.getInt(sortTypePrefKey), SortType.size.index);
      expect(harness.preferences.getBool(sortOderPrefKey), isFalse);
      expect(harness.preferences.getBool(exportCmdOnlyPrefKey), isTrue);
    },
  );

  test(
    'applies a compatible custom FFmpeg and leaves state unchanged on failure',
    () async {
      final notifier = container.read(settingsProvider.notifier);
      await notifier.initSettings();
      harness.customResult = const FFmpegConfiguration(
        source: FFmpegSource.custom,
        directory: '/normalized/custom',
        ffmpegPath: '/normalized/custom/ffmpeg',
        ffprobePath: '/normalized/custom/ffprobe',
        version: '10.0',
      );

      expect(await notifier.setCustomFFmpegDirectory('/custom'), isNull);
      final activeSettings = container.read(settingsProvider);
      expect(activeSettings.customFFmpegDirectory, '/normalized/custom');
      expect(activeSettings.ffmpegSource, FFmpegSource.custom);
      expect(activeSettings.ffmpegVersion, '10.0');
      expect(
        harness.preferences.getString(customFFmpegDirectoryPrefKey),
        '/normalized/custom',
      );

      harness.customResult = const FFmpegConfiguration.unavailable('bad build');
      expect(await notifier.setCustomFFmpegDirectory('/broken'), 'bad build');
      expect(container.read(settingsProvider), activeSettings);
      expect(harness.customDirectories, ['/custom', '/broken']);
    },
  );

  test('switches to bundled FFmpeg only after successful validation', () async {
    final notifier = container.read(settingsProvider.notifier);
    await notifier.initSettings();
    harness.customResult = const FFmpegConfiguration(
      source: FFmpegSource.custom,
      directory: '/custom',
      ffmpegPath: '/custom/ffmpeg',
      ffprobePath: '/custom/ffprobe',
      version: '9.0',
    );
    await notifier.setCustomFFmpegDirectory('/custom');

    harness.bundledResult = const FFmpegConfiguration.unavailable(
      'bundled missing',
    );
    expect(await notifier.useBundledFFmpeg(), 'bundled missing');
    expect(container.read(settingsProvider).ffmpegSource, FFmpegSource.custom);
    expect(
      harness.preferences.getString(customFFmpegDirectoryPrefKey),
      '/custom',
    );

    harness.bundledResult = const FFmpegConfiguration(
      source: FFmpegSource.bundled,
      directory: '/bundled',
      ffmpegPath: '/bundled/ffmpeg',
      ffprobePath: '/bundled/ffprobe',
      version: '9.2',
    );
    expect(await notifier.useBundledFFmpeg(), isNull);
    expect(container.read(settingsProvider).customFFmpegDirectory, isEmpty);
    expect(container.read(settingsProvider).ffmpegSource, FFmpegSource.bundled);
    expect(
      harness.preferences.containsKey(customFFmpegDirectoryPrefKey),
      isFalse,
    );
  });
}

Future<SharedPreferences> _mockPreferences(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

final class _SettingsHarness {
  _SettingsHarness._({
    required this.store,
    required this.preferences,
    required this.applicationSupportDirectory,
  });

  static Future<_SettingsHarness> create(Directory root) async {
    final storageDirectory = Directory(p.join(root.path, 'settings'));
    final applicationSupportDirectory = Directory(p.join(root.path, 'support'));
    await applicationSupportDirectory.create(recursive: true);
    return _SettingsHarness._(
      store: await SettingsStore.open(directory: storageDirectory),
      preferences: await _mockPreferences({}),
      applicationSupportDirectory: applicationSupportDirectory,
    );
  }

  final SettingsStore store;
  SharedPreferences preferences;
  final Directory applicationSupportDirectory;
  final List<String> errors = [];
  final List<String> warnings = [];
  final List<String> initializedDirectories = [];
  final List<String> customDirectories = [];

  FFmpegConfiguration initializationResult =
      const FFmpegConfiguration.unavailable('not configured');
  FFmpegConfiguration customResult = const FFmpegConfiguration.unavailable(
    'invalid custom directory',
  );
  FFmpegConfiguration bundledResult = const FFmpegConfiguration.unavailable(
    'bundled unavailable',
  );

  SettingsDependencies get dependencies => SettingsDependencies(
    openStore: () async => store,
    loadPreferences: () async => preferences,
    getApplicationSupportDirectory: () async => applicationSupportDirectory,
    loadAppVersion: () async => '2.3.4-test',
    initializeFFmpeg: (directory) async {
      initializedDirectories.add(directory);
      return initializationResult;
    },
    useCustomFFmpeg: (directory) async {
      customDirectories.add(directory);
      return customResult;
    },
    useBundledFFmpeg: () async => bundledResult,
    getCpuThreads: () => 12,
    showError: errors.add,
    showWarning: warnings.add,
  );
}
