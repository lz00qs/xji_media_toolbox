import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/video_task.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

class TaskItem extends StatelessWidget {
  final VideoTask videoProcess;

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
                        VideoTaskType.values[videoProcess.type.index].name,
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
                        // Obx(() {
                        //   switch (videoProcess.status.value) {
                        //     case VideoTaskStatus.processing:
                        //       return SizedBox(
                        //         width: 24,
                        //         height: 24,
                        //         child: IconButton(
                        //             onPressed: () {
                        //               videoProcess.cancel();
                        //             },
                        //             padding: EdgeInsets.zero,
                        //             icon: const Icon(Icons.cancel_outlined,
                        //                 color: ColorDark.warning)),
                        //       );
                        //     case VideoTaskStatus.finished:
                        //       return const Icon(Icons.check,
                        //           color: ColorDark.success);
                        //     case VideoTaskStatus.canceled:
                        //       return const Icon(Icons.cancel_outlined,
                        //           color: ColorDark.warning);
                        //     case VideoTaskStatus.failed:
                        //       return const Icon(Icons.error,
                        //           color: ColorDark.danger);
                        //     case VideoTaskStatus.waiting:
                        //       return const Icon(Icons.timer,
                        //           color: ColorDark.text1);
                        //   }
                        // }),
                        Builder(builder: (BuildContext context){
                          switch (videoProcess.status.value) {
                            case VideoTaskStatus.processing:
                              return IconButton(
                                  onPressed: () {
                                    videoProcess.cancel();
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.cancel_outlined,
                                      color: ColorDark.warning));
                            case VideoTaskStatus.finished:
                              return const Icon(Icons.check,
                                  color: ColorDark.success);
                            case VideoTaskStatus.canceled:
                              return const Icon(Icons.cancel_outlined,
                                  color: ColorDark.warning);
                            case VideoTaskStatus.failed:
                              return const Icon(Icons.error,
                                  color: ColorDark.danger);
                            case VideoTaskStatus.waiting:
                              return const Icon(Icons.timer,
                                  color: ColorDark.text1);
                          }
                        }),
                        // Obx(() {
                        //   switch (videoProcess.status.value) {
                        //     case VideoTaskStatus.processing:
                        //       return Text(
                        //           '${(videoProcess.progress.value * 100).toInt()}%',
                        //           style: SemiTextStyles.regularENSemiBold
                        //               .copyWith(
                        //                   color: ColorDark.text1,
                        //                   overflow: TextOverflow.ellipsis));
                        //     case VideoTaskStatus.finished:
                        //       return Text('finished',
                        //           style: SemiTextStyles.regularENSemiBold
                        //               .copyWith(
                        //                   color: ColorDark.success,
                        //                   overflow: TextOverflow.ellipsis));
                        //     case VideoTaskStatus.canceled:
                        //       return Text('canceled',
                        //           style: SemiTextStyles.regularENSemiBold
                        //               .copyWith(
                        //                   color: ColorDark.warning,
                        //                   overflow: TextOverflow.ellipsis));
                        //     case VideoTaskStatus.failed:
                        //       return Text('failed',
                        //           style: SemiTextStyles.regularENSemiBold
                        //               .copyWith(
                        //                   color: ColorDark.danger,
                        //                   overflow: TextOverflow.ellipsis));
                        //     case VideoTaskStatus.waiting:
                        //       return Text('waiting',
                        //           style: SemiTextStyles.regularENSemiBold
                        //               .copyWith(
                        //                   color: ColorDark.text1,
                        //                   overflow: TextOverflow.ellipsis));
                        //   }
                        // }),
                        Builder(builder: (BuildContext context){
                          switch (videoProcess.status.value) {
                            case VideoTaskStatus.processing:
                              return Text(
                                  '${(videoProcess.progress.value * 100).toInt()}%',
                                  style: SemiTextStyles.regularENSemiBold
                                      .copyWith(
                                           color: ColorDark.text1,
                                           overflow: TextOverflow.ellipsis));
                            case VideoTaskStatus.finished:
                              return Text('finished',
                                  style: SemiTextStyles.regularENSemiBold
                                     .copyWith(
                                           color: ColorDark.success,
                                           overflow: TextOverflow.ellipsis));
                            case VideoTaskStatus.canceled:
                              return Text('canceled',
                                  style: SemiTextStyles.regularENSemiBold
                                    .copyWith(
                                           color: ColorDark.warning,
                                           overflow: TextOverflow.ellipsis));
                            case VideoTaskStatus.failed:
                              return Text('failed',
                                  style: SemiTextStyles.regularENSemiBold
                                   .copyWith(
                                           color: ColorDark.danger,
                                           overflow: TextOverflow.ellipsis));
                            case VideoTaskStatus.waiting:
                              return Text('waiting',
                                  style: SemiTextStyles.regularENSemiBold
                                  .copyWith(
                                           color: ColorDark.text1,
                                           overflow: TextOverflow.ellipsis));
                          }
                        }),
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

class TaskDrawer extends ConsumerWidget {
  const TaskDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(tasksProvider);
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
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: ColorDark.text0,
                  )),
              Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                      tasks.totalTasks.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItem(
                            videoProcess: tasks.totalTasks[index]);
                      }))
            ],
          ),
        ));
  }
}
