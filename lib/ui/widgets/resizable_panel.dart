import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/resizable_panel_state.dart';

import '../design_tokens.dart';

const _draggableAreaSize = 8.0;
const _leftPanelMinWidth = 324.0;
const _leftPanelMinHeight = 200.0;
const _rightPanelMinWidth = 600.0;
const _dragIdentifierWidth = 2.0;
const _dragAreaColor = ColorDark.primaryLightActive;

class _DragIdentifier extends StatelessWidget {
  final bool isVertical;
  final bool highlight;

  const _DragIdentifier({required this.isVertical, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? SizedBox(
            width: _draggableAreaSize,
            child: Row(
              children: [
                Container(
                  width: (_draggableAreaSize - _dragIdentifierWidth) / 2,
                  color: Colors.transparent,
                ),
                SizedBox(
                    width: _dragIdentifierWidth,
                    child: Column(
                      children: [
                        Container(
                          height: DesignValues.mediumBorderRadius,
                        ),
                        Expanded(
                          child: Container(
                            color:
                                highlight ? _dragAreaColor : Colors.transparent,
                          ),
                        ),
                        Container(
                          height: DesignValues.mediumBorderRadius,
                        ),
                      ],
                    )),
                Container(
                  width: (_draggableAreaSize - _dragIdentifierWidth) / 2,
                  color: Colors.transparent,
                ),
              ],
            ),
          )
        : SizedBox(
            height: _draggableAreaSize,
            child: Column(
              children: [
                Container(
                  height: (_draggableAreaSize - _dragIdentifierWidth) / 2,
                  color: Colors.transparent,
                ),
                SizedBox(
                    height: _dragIdentifierWidth,
                    child: Row(
                      children: [
                        Container(
                          width: DesignValues.mediumBorderRadius,
                        ),
                        Expanded(
                          child: Container(
                            color:
                                highlight ? _dragAreaColor : Colors.transparent,
                          ),
                        ),
                        Container(
                          width: DesignValues.mediumBorderRadius,
                        ),
                      ],
                    )),
                Container(
                  height: (_draggableAreaSize - _dragIdentifierWidth) / 2,
                  color: Colors.transparent,
                ),
              ],
            ),
          );
  }
}

// 圆角卡片
class _RoundedPanel extends StatelessWidget {
  final Widget child;

  const _RoundedPanel({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: ColorDark.bg1,
        child: child,
      ),
    );
  }
}

class ResizablePanel extends HookConsumerWidget {
  final Widget mediaResourceInfoPanel;
  final Widget mediaResourcesListPanel;
  final Widget mainPanel;

  const ResizablePanel(
      {super.key,
      required this.mediaResourcesListPanel,
      required this.mediaResourceInfoPanel,
      required this.mainPanel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panelState = ref.watch(resizablePanelStateProvider);
    final panelNotifier = ref.read(resizablePanelStateProvider.notifier);

    final draggingX = useState(false);
    final draggingY = useState(false);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Container(
            color: ColorDark.bg0,
            child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: Stack(
                children: [
                  // 左侧面板
                  Positioned(
                    left: 0,
                    top: 0,
                    width: panelState.leftPanelWidth,
                    height: height - DesignValues.smallPadding * 2,
                    child: Column(
                      children: [
                        SizedBox(
                          height: panelState.topLeftHeight,
                          child: _RoundedPanel(child: mediaResourcesListPanel),
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.resizeRow,
                          onEnter: (_) {
                            draggingY.value = true;
                          },
                          onExit: (_) {
                            draggingY.value = false;
                          },
                          child: GestureDetector(
                            onVerticalDragUpdate: (details) {
                              final newHeight =
                                  panelState.topLeftHeight + details.delta.dy;
                              if (newHeight > _leftPanelMinHeight &&
                                  newHeight < height - _leftPanelMinHeight) {
                                panelNotifier.setTopLeftHeight(newHeight);
                              }
                            },
                            child: _DragIdentifier(
                                isVertical: false, highlight: draggingY.value),
                          ),
                        ),
                        Expanded(
                          child: _RoundedPanel(child: mediaResourceInfoPanel),
                        ),
                      ],
                    ),
                  ),

                  // 拖动条（左右）
                  Positioned(
                    left: panelState.leftPanelWidth,
                    top: 0,
                    width: _draggableAreaSize,
                    height: height - DesignValues.smallPadding * 2,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      onEnter: (_) {
                        draggingX.value = true;
                      },
                      onExit: (_) {
                        draggingX.value = false;
                      },
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          final newWidth =
                              panelState.leftPanelWidth + details.delta.dx;
                          if (newWidth > _leftPanelMinWidth &&
                              newWidth < width - _rightPanelMinWidth) {
                            panelNotifier.setLeftPanelWidth(newWidth);
                          }
                        },
                        child: _DragIdentifier(
                            isVertical: true, highlight: draggingX.value),
                      ),
                    ),
                  ),

                  // 右侧主面板
                  Positioned(
                    left: panelState.leftPanelWidth + _draggableAreaSize,
                    top: 0,
                    right: 0,
                    height: height - DesignValues.smallPadding * 2,
                    child: _RoundedPanel(
                      child: mainPanel,
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }
}
