import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/media_resources_state.model.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/providers/media_resources_state.notifier.dart';
import 'package:xji_footage_toolbox/providers/task_scheduler.dart';
import 'package:xji_footage_toolbox/ui/pages/ffmpeg_not_available_page.dart';
import 'package:xji_footage_toolbox/ui/pages/loading_media_resources_page.dart';
import 'package:xji_footage_toolbox/ui/pages/main_page.dart';
import 'package:xji_footage_toolbox/ui/panels/aeb_photo_viewer_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/main_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/media_resource_info_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/multi_select_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/photo_viewer_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/video_merger_panel.dart';
import 'package:xji_footage_toolbox/ui/resizable_panel.dart';
import 'package:xji_footage_toolbox/ui/task_drawer.dart';

import '../helpers/media_fixtures.dart';

void main() {
  late Directory directory;
  late File imageFile;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('xji-main-ui-test-');
    imageFile = File(p.join(directory.path, 'thumb.png'));
    imageFile.writeAsBytesSync(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwC'
        'AAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
  });

  tearDown(() {
    if (directory.existsSync()) directory.deleteSync(recursive: true);
  });

  testWidgets('loading and unavailable pages explain their current state', (
    tester,
  ) async {
    await pumpWithMediaState(
      tester,
      const MediaResourcesState(isLoading: true, loadProgress: 0.425),
      const LoadingMediaResourcesPage(),
    );
    expect(find.byType(LinearProgressIndicator), findsOneWidget);
    expect(find.text('Loading Media Resources: 42.50%'), findsOneWidget);
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      0.425,
    );

    await tester.pumpWidget(const MaterialApp(home: FFmpegNotAvailablePage()));
    expect(find.text('FFmpeg or FFprobe is not available!'), findsOneWidget);
    expect(
      find.text(
        'Open Settings > Advanced to select a custom FFmpeg directory.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('main page switches between empty and loading states', (
    tester,
  ) async {
    await pumpWithMediaState(
      tester,
      const MediaResourcesState(),
      const MainPage(),
    );
    expect(find.byIcon(Icons.folder_open), findsOneWidget);
    expect(find.byType(LoadingMediaResourcesPage), findsNothing);

    await pumpWithMediaState(
      tester,
      const MediaResourcesState(isLoading: true, loadProgress: 0.1),
      const MainPage(),
    );
    expect(find.byType(LoadingMediaResourcesPage), findsOneWidget);
  });

  testWidgets('resource list renders metadata and updates multi-selection', (
    tester,
  ) async {
    setLargeTestView(tester);
    final photo = photoFixture(
      name: 'photo.JPG',
      file: imageFile,
      sizeInBytes: 2048,
    );
    final videoFile = File(p.join(directory.path, 'clip.MP4'))
      ..writeAsStringSync('video');
    final video = videoFixture(
      name: 'clip.MP4',
      file: videoFile,
      thumbFile: imageFile,
      duration: const Duration(minutes: 1, seconds: 2),
    );
    final state = MediaResourcesState(
      resources: [photo, video],
      resourcesPath: directory.path,
      isMultipleSelection: true,
    );
    late ProviderContainer container;
    await pumpWithMediaState(
      tester,
      state,
      const MainPage(),
      onContainer: (value) => container = value,
    );

    expect(find.text('Files'), findsOneWidget);
    expect(find.text('photo'), findsOneWidget);
    expect(find.text('clip'), findsOneWidget);
    expect(find.text('JPG'), findsOneWidget);
    expect(find.text('MP4'), findsOneWidget);
    expect(find.text('HEVC'), findsOneWidget);
    expect(find.text('Select some resources first!'), findsOneWidget);
    expect(find.text('Name:'), findsOneWidget);
    expect(find.text('photo.JPG'), findsOneWidget);

    await tester.tap(find.text('photo'));
    await tester.pump();
    expect(container.read(mediaResourcesStateProvider).selectedResources, [
      photo,
    ]);
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.byIcon(Icons.merge_type), findsNothing);

    await tester.tap(find.text('photo'));
    await tester.pump();
    expect(
      container.read(mediaResourcesStateProvider).selectedResources,
      isEmpty,
    );
  });

  testWidgets('video-only multi-selection enters and exits merger mode', (
    tester,
  ) async {
    setLargeTestView(tester);
    final first = videoFixture(
      name: 'first.MP4',
      file: File(p.join(directory.path, 'first.MP4')),
      thumbFile: imageFile,
    );
    final second = videoFixture(
      name: 'second.MP4',
      file: File(p.join(directory.path, 'second.MP4')),
      thumbFile: imageFile,
    );
    await pumpWithMediaState(
      tester,
      MediaResourcesState(
        resources: [first, second],
        selectedResources: [first, second],
        isMultipleSelection: true,
      ),
      const MultiSelectPanel(),
    );

    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(find.byIcon(Icons.merge_type), findsOneWidget);
    await tester.tap(find.byIcon(Icons.merge_type));
    await tester.pump();
    expect(find.byType(VideoMergerPanel), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    expect(find.byIcon(Icons.save), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pump();
    expect(find.byType(VideoMergerPanel), findsNothing);
    expect(find.byIcon(Icons.merge_type), findsOneWidget);
  });

  testWidgets('resource info panel displays photo, AEB, and video fields', (
    tester,
  ) async {
    final aeb = aebPhotoFixture(
      name: 'bracket.JPG',
      file: imageFile,
      evBias: '-0.7',
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: MediaResourceInfoPanel(mediaResource: aeb)),
      ),
    );
    expect(find.text('EV Bias:'), findsOneWidget);
    expect(find.text('-0.7'), findsOneWidget);

    final video = videoFixture(
      name: 'movie.MP4',
      file: File(p.join(directory.path, 'movie.MP4')),
      thumbFile: imageFile,
      duration: const Duration(seconds: 65),
      frameRate: 59.94,
    );
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: MediaResourceInfoPanel(mediaResource: video)),
      ),
    );
    expect(find.text('Duration:'), findsOneWidget);
    expect(find.text('0:01:05'), findsOneWidget);
    expect(find.text('Frame Rate:'), findsOneWidget);
    expect(find.text('59.94fps'), findsOneWidget);
  });

  testWidgets('main panel selects standard and grouped AEB photo viewers', (
    tester,
  ) async {
    setLargeTestView(tester);
    final photo = photoFixture(file: imageFile);
    await pumpWithMediaState(
      tester,
      MediaResourcesState(resources: [photo]),
      MainPanel(resource: photo),
    );
    expect(find.byType(PhotoViewerPanel), findsOneWidget);

    final orphan = aebPhotoFixture(file: imageFile);
    await pumpWithMediaState(
      tester,
      MediaResourcesState(resources: [orphan]),
      MainPanel(resource: orphan),
    );
    expect(find.byType(PhotoViewerPanel), findsOneWidget);

    final members = [
      aebPhotoFixture(name: 'zero.JPG', file: imageFile, evBias: '0'),
      aebPhotoFixture(name: 'plus.JPG', file: imageFile, evBias: '+0.7'),
    ];
    final group = members.first.copyWith(aebResources: members);
    await pumpWithMediaState(
      tester,
      MediaResourcesState(resources: [group]),
      MainPanel(resource: group),
    );
    expect(find.byType(AebPhotoViewerPanel), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.text('+0.7'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.chevron_right));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets('resizable panel responds to horizontal and vertical drags', (
    tester,
  ) async {
    setLargeTestView(tester);
    const listKey = Key('resource-list');
    const infoKey = Key('resource-info');
    const mainKey = Key('main-content');
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: ResizablePanel(
              mediaResourcesListPanel: ColoredBox(
                key: listKey,
                color: Colors.red,
              ),
              mediaResourceInfoPanel: ColoredBox(
                key: infoKey,
                color: Colors.green,
              ),
              mainPanel: ColoredBox(key: mainKey, color: Colors.blue),
            ),
          ),
        ),
      ),
    );
    final initialListSize = tester.getSize(find.byKey(listKey));
    final initialMainLeft = tester.getTopLeft(find.byKey(mainKey)).dx;

    final horizontalHandle = find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector && widget.onHorizontalDragUpdate != null,
    );
    await tester.drag(horizontalHandle, const Offset(80, 0));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(listKey)).width,
      greaterThan(initialListSize.width),
    );
    expect(
      tester.getTopLeft(find.byKey(mainKey)).dx,
      greaterThan(initialMainLeft),
    );

    final verticalHandle = find.byWidgetPredicate(
      (widget) =>
          widget is GestureDetector && widget.onVerticalDragUpdate != null,
    );
    await tester.drag(verticalHandle, const Offset(0, 50));
    await tester.pump();
    expect(
      tester.getSize(find.byKey(listKey)).height,
      greaterThan(initialListSize.height),
    );
  });

  testWidgets('task drawer renders every status, ETA, progress, and closes', (
    tester,
  ) async {
    setLargeTestView(tester);
    final tasks = [
      const VideoTask(
        id: 'processing',
        name: 'processing.MP4',
        type: VideoTaskType.transcode,
        status: VideoTaskStatus.processing,
        progress: 0.42,
        eta: Duration(hours: 1, minutes: 2, seconds: 3),
      ),
      const VideoTask(
        id: 'waiting',
        name: 'waiting.MP4',
        type: VideoTaskType.trim,
      ),
      const VideoTask(
        id: 'finished',
        name: 'finished.MP4',
        type: VideoTaskType.merge,
        status: VideoTaskStatus.finished,
      ),
      const VideoTask(
        id: 'canceled',
        name: 'canceled.MP4',
        status: VideoTaskStatus.canceled,
      ),
      const VideoTask(
        id: 'failed',
        name: 'failed.MP4',
        status: VideoTaskStatus.failed,
      ),
    ];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [taskSchedulerProvider.overrideWithValue(tasks)],
        child: MaterialApp(
          home: Scaffold(
            endDrawer: const TaskDrawer(),
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => Scaffold.of(context).openEndDrawer(),
                child: const Text('Tasks'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Tasks'));
    await tester.pumpAndSettle();

    expect(find.text('Transcode     ETA: 01:02:03'), findsOneWidget);
    expect(find.text('42%'), findsOneWidget);
    expect(find.text('waiting'), findsOneWidget);
    expect(find.text('finished'), findsOneWidget);
    expect(find.text('canceled'), findsOneWidget);
    expect(find.text('failed'), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.refresh), findsNWidgets(2));
    expect(find.byIcon(Icons.timer), findsOneWidget);

    await tester.tap(find.byIcon(Icons.arrow_forward));
    await tester.pumpAndSettle();
    expect(find.byType(TaskDrawer), findsNothing);
  });
}

Future<void> pumpWithMediaState(
  WidgetTester tester,
  MediaResourcesState state,
  Widget child, {
  ValueChanged<ProviderContainer>? onContainer,
}) async {
  final container = ProviderContainer(
    overrides: [
      mediaResourcesStateProvider.overrideWith(
        () =>
            MediaResourcesStateNotifier(initialState: state, showError: (_) {}),
      ),
    ],
  );
  onContainer?.call(container);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(home: Scaffold(body: child)),
    ),
  );
  await tester.pump();
}

void setLargeTestView(WidgetTester tester) {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
