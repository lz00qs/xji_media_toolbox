import 'package:get/get.dart';

import '../models/video_process.dart';

class GlobalTasksController extends GetxController {
  final _videoProcessingTasks = <VideoProcess>[].obs;
  final _waitingTasks = <VideoProcess>[];
  var _isProcessing = false;

  get videoProcessingTasks => _videoProcessingTasks;

  Future<void> addTask(VideoProcess videoProcess) async {
    _waitingTasks.add(videoProcess);
    _videoProcessingTasks.add(videoProcess);
    await _process();
  }

  Future<void> _process() async {
    if (_isProcessing) {
      return;
    }

    _isProcessing = true;
    while (_waitingTasks.isNotEmpty) {
      final task = _waitingTasks.removeAt(0);
      await task.process();
    }
    _isProcessing = false;
  }
}
