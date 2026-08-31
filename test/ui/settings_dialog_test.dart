import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/models/ffmpeg_configuration.dart';
import 'package:xji_footage_toolbox/models/lut.model.dart';
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/models/transcode_preset.model.dart';
import 'package:xji_footage_toolbox/providers/settings.notifier.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/dialogs/settings_dialog.dart';

void main() {
  testWidgets('advanced FFmpeg settings use the application dialog style', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsDialog())),
    );

    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();

    expect(find.text('Runtime:'), findsOneWidget);
    expect(find.text('Version:'), findsWidgets);
    expect(find.text('Custom FFmpeg Directory'), findsOneWidget);
    expect(find.text('Use Bundled'), findsOneWidget);
    expect(find.text('Apply Custom'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    final runtimeLabel = tester.widget<Text>(find.text('Runtime:'));
    expect(
      runtimeLabel.style?.fontSize,
      SemiTextStyles.header5ENRegular.fontSize,
    );
    expect(runtimeLabel.style?.color, ColorDark.text1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders stored presets, LUTs, flags, version, and runtime', (
    tester,
  ) async {
    setLargeTestView(tester);
    const settings = Settings(
      transcodingPresets: [
        TranscodePreset(id: 4, name: 'Web Delivery'),
        TranscodePreset(id: 8, name: 'Archive'),
      ],
      luts: [Lut(id: 2, name: 'Warm Look', path: '/luts/warm.cube')],
      defaultTranscodePresetId: 8,
      appVersion: '2.4.6',
      isDebugMode: true,
      exportCmdOnly: true,
      customFFmpegDirectory: '/runtime',
      activeFFmpegDirectory: '/runtime',
      ffmpegVersion: '7.1',
      ffmpegSource: FFmpegSource.custom,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [settingsProvider.overrideWithValue(settings)],
        child: const MaterialApp(home: SettingsDialog()),
      ),
    );

    expect(find.text('Web Delivery'), findsOneWidget);
    expect(find.text('Archive'), findsOneWidget);
    expect(find.text('Warm Look'), findsOneWidget);
    expect(find.text('2.4.6'), findsOneWidget);
    expect(tester.widgetList<Switch>(find.byType(Switch)).map((e) => e.value), [
      true,
      true,
    ]);

    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();
    expect(find.text('Custom'), findsOneWidget);
    expect(find.text('7.1'), findsOneWidget);
    expect(find.text('/runtime'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('add preset form validates name, dimensions, and CRF', (
    tester,
  ) async {
    setLargeTestView(tester);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsDialog())),
    );

    await tester.tap(find.byIcon(Icons.add_circle_outline).first);
    await tester.pumpAndSettle();
    expect(find.text('Add Preset'), findsOneWidget);

    var fields = find.byType(TextField);
    await tester.enterText(fields.at(0), '');
    await tester.enterText(fields.at(1), '52');
    await tester.pump();
    expect(find.text('Name is required'), findsOneWidget);
    expect(
      find.text('CRF must be between 0 and 51, higher is lower quality.'),
      findsOneWidget,
    );
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Add'))
          .onPressed,
      isNull,
    );

    await tester.tap(find.byIcon(Icons.check_box).first);
    await tester.pump();
    expect(find.text('Width'), findsOneWidget);
    expect(find.text('Height'), findsOneWidget);
    fields = find.byType(TextField);
    await tester.enterText(fields.at(1), '0');
    await tester.enterText(fields.at(2), '0');
    await tester.pump();
    expect(find.text('Width cannot be 0'), findsOneWidget);
    expect(find.text('Height cannot be 0'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Add Preset'), findsNothing);
  });

  testWidgets('add LUT form requires both a name and selected file', (
    tester,
  ) async {
    setLargeTestView(tester);
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: SettingsDialog())),
    );

    await tester.tap(find.byIcon(Icons.add_circle_outline).last);
    await tester.pumpAndSettle();
    expect(find.text('Add Lut'), findsOneWidget);
    final addButton = find.widgetWithText(TextButton, 'Add');
    expect(tester.widget<TextButton>(addButton).onPressed, isNull);
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(find.text('Name is required'), findsOneWidget);
    expect(tester.widget<TextButton>(addButton).onPressed, isNull);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(find.text('Add Lut'), findsNothing);
  });
}

void setLargeTestView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1000, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
