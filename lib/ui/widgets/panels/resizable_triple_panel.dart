import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResizableTriplePanel extends StatelessWidget {
  final Widget topLeftPanel;
  final Widget bottomLeftPanel;
  final Widget rightPanel;

  static const _leftPanelMinWidth = 300.0;
  static const _rightWidgetMinWidth = 400.0;
  static const _leftPanelMinHeight = 300.0;
  static const _draggableAreaSize = 8.0;
  static const _dragIconSize = 20.0;
  static const _dragAreaColor = Colors.black12;

  final _leftPanelWidth = 300.0.obs;
  final _topLeftPanelHeight = 400.0.obs;

  ResizableTriplePanel(
      {super.key,
      required this.topLeftPanel,
      required this.bottomLeftPanel,
      required this.rightPanel});

  @override
  Widget build(BuildContext context) {
    final parentWidth = MediaQuery.of(context).size.width;
    final parentHeight = MediaQuery.of(context).size.height;
    if (_topLeftPanelHeight.value + _leftPanelMinHeight >= parentHeight) {
      _topLeftPanelHeight.value = parentHeight - _leftPanelMinHeight;
    }
    if (_leftPanelWidth.value + _rightWidgetMinWidth >= parentWidth) {
      _leftPanelWidth.value = parentWidth - _rightWidgetMinWidth;
    }

    return Obx(() => Row(
          children: [
            Container(
              width: _leftPanelWidth.value,
              constraints: const BoxConstraints(minWidth: _leftPanelMinWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: _topLeftPanelHeight.value,
                    constraints:
                        const BoxConstraints(minHeight: _leftPanelMinHeight),
                    child: topLeftPanel,
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.resizeRow,
                    child: GestureDetector(
                      onVerticalDragUpdate: (details) {
                        if (_topLeftPanelHeight.value + details.delta.dy >=
                                _leftPanelMinHeight &&
                            parentHeight -
                                    _topLeftPanelHeight.value -
                                    details.delta.dy >=
                                _leftPanelMinHeight) {
                          _topLeftPanelHeight.value += details.delta.dy;
                        }
                      },
                      child: Container(
                        width: _leftPanelWidth.value,
                        height: _draggableAreaSize,
                        color: _dragAreaColor,
                        child: Stack(
                          children: [
                            Positioned(
                              top: _draggableAreaSize / 2 - _dragIconSize / 2,
                              left:
                                  _leftPanelWidth.value / 2 - _dragIconSize / 2,
                              child: const Icon(
                                Icons.drag_handle,
                                size: _dragIconSize,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    constraints:
                        const BoxConstraints(minHeight: _leftPanelMinHeight),
                    child: bottomLeftPanel,
                  )),
                ],
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.resizeColumn,
              child: GestureDetector(
                onHorizontalDragUpdate: (details) {
                  if (_leftPanelWidth.value + details.delta.dx >=
                          _leftPanelMinWidth &&
                      parentWidth - _leftPanelWidth.value - details.delta.dx >=
                          _rightWidgetMinWidth) {
                    _leftPanelWidth.value += details.delta.dx;
                  }
                },
                child: Container(
                  width: _draggableAreaSize,
                  height: parentHeight,
                  color: _dragAreaColor,
                  child: Stack(
                    children: [
                      Positioned(
                        left: _draggableAreaSize / 2 - _dragIconSize / 2,
                        top: parentHeight / 2 - _dragIconSize / 2,
                        child: Transform.rotate(
                          angle: 90 * (3.141592653589793 / 180),
                          child: const Icon(
                            Icons.drag_handle,
                            size: _dragIconSize,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(child: rightPanel),
          ],
        ));
  }
}
