import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/resizable_panel_state.dart';

part 'resizable_panel_state_provider.g.dart';

@riverpod
class ResizablePanelStateNotifier extends _$ResizablePanelStateNotifier {
  @override
  ResizablePanelState build() {
    return ResizablePanelState(leftPanelWidth: 324, topLeftHeight: 400);
  }

  void setLeftPanelWidth(double width) {
    state = state.copyWith(leftPanelWidth: width);
  }

  void setTopLeftHeight(double height) {
    state = state.copyWith(topLeftHeight: height);
  }
}
