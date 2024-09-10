import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

class ResizableTriplePanelController extends GetxController {
  static const leftPanelMinWidth = 324.0;
  static const rightWidgetMinWidth = 600.0;
  static const leftPanelMinHeight = 200.0;
  static const draggableAreaSize = 8.0;
  static const dragIdentifierWidth = 2.0;
  static const dragAreaColor = ColorDark.primaryLightActive;

  var _parentWidth = 0.0;
  var _parentHeight = 0.0;

  final leftPanelWidth = leftPanelMinWidth.obs;
  final bottomLeftPanelHeight = leftPanelMinHeight.obs;

  void setParentSize(double width, double height) {
    _parentWidth = width;
    _parentHeight = height;
    _initialize();
  }

  void _initialize() {
    if (bottomLeftPanelHeight.value + leftPanelMinHeight >= _parentHeight) {
      bottomLeftPanelHeight.value = _parentHeight - leftPanelMinHeight;
    }
    if (leftPanelWidth.value + rightWidgetMinWidth >= _parentWidth) {
      leftPanelWidth.value = _parentWidth - rightWidgetMinWidth;
    }
  }
}

// 圆角卡片
class _RoundedPanel extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color color;

  const _RoundedPanel(
      {required this.radius, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: color,
        child: child,
      ),
    );
  }
}

class _DragIdentifier extends StatelessWidget {
  final bool isVertical;
  final bool highlight;

  const _DragIdentifier({required this.isVertical, required this.highlight});

  @override
  Widget build(BuildContext context) {
    return isVertical
        ? SizedBox(
            width: ResizableTriplePanelController.draggableAreaSize,
            child: Row(
              children: [
                Container(
                  width: (ResizableTriplePanelController.draggableAreaSize -
                          ResizableTriplePanelController.dragIdentifierWidth) /
                      2,
                  color: Colors.transparent,
                ),
                SizedBox(
                    width: ResizableTriplePanelController.dragIdentifierWidth,
                    child: Column(
                      children: [
                        Container(
                          height: DesignValues.mediumBorderRadius,
                        ),
                        Expanded(
                          child: Container(
                            color: highlight
                                ? ResizableTriplePanelController.dragAreaColor
                                : Colors.transparent,
                          ),
                        ),
                        Container(
                          height: DesignValues.mediumBorderRadius,
                        ),
                      ],
                    )),
                Container(
                  width: (ResizableTriplePanelController.draggableAreaSize -
                          ResizableTriplePanelController.dragIdentifierWidth) /
                      2,
                  color: Colors.transparent,
                ),
              ],
            ),
          )
        : SizedBox(
            height: ResizableTriplePanelController.draggableAreaSize,
            child: Column(
              children: [
                Container(
                  height: (ResizableTriplePanelController.draggableAreaSize -
                          ResizableTriplePanelController.dragIdentifierWidth) /
                      2,
                  color: Colors.transparent,
                ),
                SizedBox(
                    height: ResizableTriplePanelController.dragIdentifierWidth,
                    child: Row(
                      children: [
                        Container(
                          width: DesignValues.mediumBorderRadius,
                        ),
                        Expanded(
                          child: Container(
                            color: highlight
                                ? ResizableTriplePanelController.dragAreaColor
                                : Colors.transparent,
                          ),
                        ),
                        Container(
                          width: DesignValues.mediumBorderRadius,
                        ),
                      ],
                    )),
                Container(
                  height: (ResizableTriplePanelController.draggableAreaSize -
                          ResizableTriplePanelController.dragIdentifierWidth) /
                      2,
                  color: Colors.transparent,
                ),
              ],
            ),
          );
  }
}

class ResizableTriplePanel extends GetView<ResizableTriplePanelController> {
  final Widget topLeftPanel;
  final Widget bottomLeftPanel;
  final Widget rightPanel;

  const ResizableTriplePanel(
      {super.key,
      required this.topLeftPanel,
      required this.bottomLeftPanel,
      required this.rightPanel});

  @override
  Widget build(BuildContext context) {
    final mouseEnterHorizontalDragArea = false.obs;
    var isHorizontalDrag = false;
    final mouseEnterVerticalDragArea = false.obs;
    var isVerticalDrag = false;

    controller.setParentSize(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);
    return Container(
      color: ColorDark.bg0,
      child: Padding(
        padding: EdgeInsets.all(DesignValues.smallPadding),
        child: Obx(() => Row(
              children: [
                Container(
                  width: controller.leftPanelWidth.value,
                  constraints: const BoxConstraints(
                      minWidth:
                          ResizableTriplePanelController.leftPanelMinWidth),
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        constraints: const BoxConstraints(
                            minHeight: ResizableTriplePanelController
                                .leftPanelMinHeight),
                        child: _RoundedPanel(
                          radius: DesignValues.mediumBorderRadius,
                          color: ColorDark.bg1,
                          child: topLeftPanel,
                        ),
                      )),
                      MouseRegion(
                        cursor: SystemMouseCursors.resizeRow,
                        onEnter: (_) {
                          mouseEnterHorizontalDragArea.value = true;
                        },
                        onExit: (_) {
                          if (!isHorizontalDrag) {
                            mouseEnterHorizontalDragArea.value = false;
                          }
                        },
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (controller.bottomLeftPanelHeight.value -
                                        details.delta.dy >=
                                    ResizableTriplePanelController
                                        .leftPanelMinHeight &&
                                controller._parentHeight -
                                        controller.bottomLeftPanelHeight.value +
                                        details.delta.dy >=
                                    ResizableTriplePanelController
                                        .leftPanelMinHeight) {
                              controller.bottomLeftPanelHeight.value -=
                                  details.delta.dy;
                            } else if (controller.bottomLeftPanelHeight.value -
                                    details.delta.dy <
                                ResizableTriplePanelController
                                    .leftPanelMinHeight) {
                              controller.bottomLeftPanelHeight.value =
                                  ResizableTriplePanelController
                                      .leftPanelMinHeight;
                            } else if (controller._parentHeight -
                                    controller.bottomLeftPanelHeight.value +
                                    details.delta.dy <
                                ResizableTriplePanelController
                                    .leftPanelMinHeight) {
                              controller.bottomLeftPanelHeight.value =
                                  controller._parentHeight -
                                      ResizableTriplePanelController
                                          .leftPanelMinHeight;
                            }
                          },
                          onVerticalDragStart: (_) {
                            isHorizontalDrag = true;
                          },
                          onVerticalDragEnd: (_) {
                            isHorizontalDrag = false;
                            mouseEnterHorizontalDragArea.value = false;
                          },
                          child: Obx(
                            () => _DragIdentifier(
                              isVertical: false,
                              highlight: mouseEnterHorizontalDragArea.value,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        height: controller.bottomLeftPanelHeight.value,
                        constraints: const BoxConstraints(
                            minHeight: ResizableTriplePanelController
                                .leftPanelMinHeight),
                        child: _RoundedPanel(
                          radius: DesignValues.mediumBorderRadius,
                          color: ColorDark.bg1,
                          child: bottomLeftPanel,
                        ),
                      ),
                    ],
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.resizeColumn,
                  onEnter: (_) {
                    mouseEnterVerticalDragArea.value = true;
                  },
                  onExit: (_) {
                    if (!isVerticalDrag) {
                      mouseEnterVerticalDragArea.value = false;
                    }
                  },
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (controller.leftPanelWidth.value + details.delta.dx >=
                              ResizableTriplePanelController
                                  .leftPanelMinWidth &&
                          controller._parentWidth -
                                  controller.leftPanelWidth.value -
                                  details.delta.dx >=
                              ResizableTriplePanelController
                                  .rightWidgetMinWidth) {
                        controller.leftPanelWidth.value += details.delta.dx;
                      } else if (controller.leftPanelWidth.value +
                              details.delta.dx <
                          ResizableTriplePanelController.leftPanelMinWidth) {
                        controller.leftPanelWidth.value =
                            ResizableTriplePanelController.leftPanelMinWidth;
                      } else if (controller._parentWidth -
                              controller.leftPanelWidth.value -
                              details.delta.dx <
                          ResizableTriplePanelController.rightWidgetMinWidth) {
                        controller.leftPanelWidth.value = controller
                                ._parentWidth -
                            ResizableTriplePanelController.rightWidgetMinWidth;
                      }
                    },
                    onHorizontalDragStart: (_) {
                      isVerticalDrag = true;
                    },
                    onHorizontalDragEnd: (_) {
                      isVerticalDrag = false;
                      mouseEnterVerticalDragArea.value = false;
                    },
                    child: Obx(
                      () => _DragIdentifier(
                        isVertical: true,
                        highlight: mouseEnterVerticalDragArea.value,
                      ),
                    ),
                  ),
                ),
                Expanded(
                    child: _RoundedPanel(
                  radius: DesignValues.mediumBorderRadius,
                  color: ColorDark.bg1,
                  child: rightPanel,
                ))
              ],
            )),
      ),
    );
  }
}
