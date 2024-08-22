import 'package:flutter/material.dart';

import '../../utils/media_resources_utils.dart';

class LoadMediaResourcesIconButtonWidget extends StatelessWidget {
  const LoadMediaResourcesIconButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var openPressed = false;
    return IconButton(
      icon: const Icon(Icons.folder_open),
      onPressed: () async {
        if (openPressed) {
          return;
        }
        openPressed = true;
        // 打开视频文件夹
        await openMediaResourcesFolder();
        openPressed = false;
      },
    );
  }
}
