import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/ui/panels/multi_select_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/video_panel.dart';
import 'package:xji_footage_toolbox/ui/panels/video_trimmer_panel.dart';

void main() {
  test('tracks and replaces the selected trim range', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final subscription = container.listen(videoCutProvider, (_, _) {});
    addTearDown(subscription.close);
    final notifier = container.read(videoCutProvider.notifier);

    expect(container.read(videoCutProvider), const VideoCutState());
    notifier.setCutStart(const Duration(seconds: 2));
    notifier.setCutEnd(const Duration(seconds: 8));
    expect(
      container.read(videoCutProvider),
      const VideoCutState(
        cutStart: Duration(seconds: 2),
        cutEnd: Duration(seconds: 8),
      ),
    );
    notifier.setCutStart(Duration.zero);
    notifier.setCutEnd(Duration.zero);
    expect(container.read(videoCutProvider), const VideoCutState());
  });

  test('toggles player/trimmer and multi-select merge modes independently', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    final videoSubscription = container.listen(videoPanelProvider, (_, _) {});
    final mergeSubscription = container.listen(isMergingProvider, (_, _) {});
    addTearDown(videoSubscription.close);
    addTearDown(mergeSubscription.close);

    expect(container.read(videoPanelProvider), isFalse);
    expect(container.read(isMergingProvider), isFalse);
    container.read(videoPanelProvider.notifier).toggle();
    expect(container.read(videoPanelProvider), isTrue);
    expect(container.read(isMergingProvider), isFalse);
    container.read(isMergingProvider.notifier).toggle();
    expect(container.read(videoPanelProvider), isTrue);
    expect(container.read(isMergingProvider), isTrue);
    container.read(videoPanelProvider.notifier).toggle();
    container.read(isMergingProvider.notifier).toggle();
    expect(container.read(videoPanelProvider), isFalse);
    expect(container.read(isMergingProvider), isFalse);
  });
}
