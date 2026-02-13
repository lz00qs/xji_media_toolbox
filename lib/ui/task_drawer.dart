import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

import '../models/video_task.dart';
import '../providers/task_scheduler.dart';

String _getTimeString(int seconds) {
  int minutes = seconds ~/ 60;
  int hours = minutes ~/ 60;
  minutes = minutes % 60;
  seconds = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
}

String _getFirstCapital(String str) {
  if (str.isEmpty) {
    return str;
  }
  return str[0].toUpperCase() + str.substring(1);
}

class TaskItem extends ConsumerWidget {
  final VideoTask videoTask;

  const TaskItem({super.key, required this.videoTask});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                        "${_getFirstCapital(VideoTaskType.values[videoTask.type.index].name)}${videoTask.status == VideoTaskStatus.processing ? '     ETA: ${_getTimeString(videoTask.eta.inSeconds)}' : ''}",
                        style: SemiTextStyles.header4ENRegular.copyWith(
                            color: ColorDark.text0,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const Spacer(),
                      Text(
                        videoTask.name,
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
                        Builder(builder: (BuildContext context) {
                          switch (videoTask.status) {
                            case VideoTaskStatus.processing:
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: IconButton(
                                    onPressed: () {
                                      ref
                                          .read(taskSchedulerProvider.notifier)
                                          .cancelTask(videoTask.id);
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: const Icon(Icons.cancel_outlined,
                                        color: ColorDark.primary)),
                              );
                            case VideoTaskStatus.finished:
                              return const Icon(Icons.check,
                                  color: ColorDark.success);
                            case VideoTaskStatus.canceled:
                            case VideoTaskStatus.failed:
                              return SizedBox(
                                width: 24,
                                height: 24,
                                child: IconButton(
                                    onPressed: () {
                                      ref
                                          .read(taskSchedulerProvider.notifier)
                                          .rerunTask(videoTask.id);
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: Icon(Icons.refresh,
                                        color: videoTask.status == VideoTaskStatus.canceled ? ColorDark.text1 : ColorDark.danger)),
                              );
                            // case VideoTaskStatus.failed:
                            //   return const Icon(Icons.error,
                            //       color: ColorDark.danger);
                            case VideoTaskStatus.waiting:
                              return const Icon(Icons.timer,
                                  color: ColorDark.text1);
                          }
                        }),
                        Builder(builder: (BuildContext context) {
                          switch (videoTask.status) {
                            case VideoTaskStatus.processing:
                              return Text(
                                  '${(videoTask.progress * 100).toInt()}%',
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
                                          color: ColorDark.text1,
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
    final taskSchedulerState = ref.watch(taskSchedulerProvider);
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
                      itemCount: taskSchedulerState.length,
                      itemBuilder: (BuildContext context, int index) {
                        return TaskItem(videoTask: taskSchedulerState[index]);
                      }))
            ],
          ),
        ));
  }
}
