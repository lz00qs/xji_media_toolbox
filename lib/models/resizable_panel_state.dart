import 'package:hooks_riverpod/hooks_riverpod.dart';

final resizablePanelStateProvider = StateNotifierProvider<ResizablePanelStateNotifier, ResizablePanelState>((ref) {
  return ResizablePanelStateNotifier();
});

class ResizablePanelState {
  final double leftPanelWidth;
  final double topLeftHeight;

  ResizablePanelState({
    required this.leftPanelWidth,
    required this.topLeftHeight,
  });

  ResizablePanelState copyWith({
    double? leftPanelWidth,
    double? topLeftHeight,
  }) {
    return ResizablePanelState(
      leftPanelWidth: leftPanelWidth ?? this.leftPanelWidth,
      topLeftHeight: topLeftHeight ?? this.topLeftHeight,
    );
  }
}

class ResizablePanelStateNotifier extends StateNotifier<ResizablePanelState> {
  ResizablePanelStateNotifier()
      : super(ResizablePanelState(leftPanelWidth: 324, topLeftHeight: 400));

  void setLeftPanelWidth(double width) {
    state = state.copyWith(leftPanelWidth: width);
  }

  void setTopLeftHeight(double height) {
    state = state.copyWith(topLeftHeight: height);
  }
}