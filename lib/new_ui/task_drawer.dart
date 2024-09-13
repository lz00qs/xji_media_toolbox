import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/models/video_process.dart';
import 'package:xji_footage_toolbox/new_ui/design_tokens.dart';

import '../controllers/global_tasks_controller.dart';

class TaskItem extends StatelessWidget {
  final VideoProcess videoProcess;

  const TaskItem({super.key, required this.videoProcess});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(DesignValues.mediumBorderRadius),
      child: Container(
        color: ColorDark.bg1,
        height: 73,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Divider(
              height: 1,
              thickness: 1,
              color: ColorDark.border,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.all(DesignValues.smallPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        VideoProcessType.values[videoProcess.type.index].name,
                        style: SemiTextStyles.header4ENRegular.copyWith(
                            color: ColorDark.text0,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Spacer(),
                      Text(
                        videoProcess.name,
                        style: SemiTextStyles.regularENSemiBold.copyWith(
                            color: ColorDark.text1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 72,
                    height: 48,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(() {
                          switch (videoProcess.status.value) {
                            case VideoProcessStatus.processing:
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: IconButton(
                                    onPressed: () {
                                      videoProcess.cancel();
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.cancel_outlined,
                                        color: ColorDark.warning)),
                              );
                            case VideoProcessStatus.finished:
                              return const Icon(Icons.check,
                                  color: ColorDark.success);
                            case VideoProcessStatus.canceled:
                              return const Icon(Icons.cancel_outlined,
                                  color: ColorDark.warning);
                            case VideoProcessStatus.failed:
                              return const Icon(Icons.error,
                                  color: ColorDark.danger);
                          }
                        }),
                        Obx(() {
                          switch (videoProcess.status.value) {
                            case VideoProcessStatus.processing:
                              return Text(
                                  '${(videoProcess.progress.value * 100).toInt()}%',
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.text1,
                                          overflow: TextOverflow.ellipsis));
                            case VideoProcessStatus.finished:
                              return Text('finished',
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.success,
                                          overflow: TextOverflow.ellipsis));
                            case VideoProcessStatus.canceled:
                              return Text('canceled',
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.warning,
                                          overflow: TextOverflow.ellipsis));
                            case VideoProcessStatus.failed:
                              return Text('failed',
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                          color: ColorDark.danger,
                                          overflow: TextOverflow.ellipsis));
                          }
                        }
                            // => Text(
                            //     '${(videoProcess.progress.value * 100).toInt()}%',
                            //     style: SemiTextStyles.regularENSemiBold.copyWith(
                            //         color: ColorDark.text1,
                            //         overflow: TextOverflow.ellipsis))

                            ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}

class TaskDrawer extends StatelessWidget {
  const TaskDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalTasksController globalTasksController =
        Get.find<GlobalTasksController>();
    return Drawer(
        width: 480,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(DesignValues.mediumBorderRadius))),
        child: Container(
          color: ColorDark.bg2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: ColorDark.text0,
                  )),
              Obx(() => Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          globalTasksController.videoProcessingTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItem(
                            videoProcess: globalTasksController
                                .videoProcessingTasks[index]);
                      })))
            ],
          ),
        ));
  }
}
