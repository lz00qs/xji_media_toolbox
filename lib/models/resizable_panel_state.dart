
import 'package:freezed_annotation/freezed_annotation.dart';

part 'resizable_panel_state.freezed.dart';

@freezed
abstract class ResizablePanelState with _$ResizablePanelState {
  const factory ResizablePanelState({
    required double leftPanelWidth,
    required double topLeftHeight,
  }) = _ResizablePanelState;
}
