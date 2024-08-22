import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';

import '../../controllers/global_media_resources_controller.dart';
import '../../utils/media_resources_utils.dart';

PreferredSize createMainPageAppBar() {
  final GlobalMediaResourcesController globalMediaResourcesController =
      Get.find();
  var appBarHeight = macAppBarHeight;
  var appBarButtonPadding = macAppBarButtonPadding;
  var appBarButtonSize = macAppBarHeight - 2 * macAppBarButtonPadding;
  var appBarLeadingWidth = macAppBarLeadingWidth;
  var appBarTitleTextSize = macAppBarTitleTextSize;
  var onPressed = false;

  if (GetPlatform.isWindows) {
    /// todo: windows app bar height
  }
  return PreferredSize(
    // windows 和 macos size 做区分
    preferredSize: Size.fromHeight(appBarHeight),
    child: AppBar(
      title: Obx(() => globalMediaResourcesController.mediaResources.isEmpty
          ? const SizedBox()
          : Text(
              globalMediaResourcesController
                  .mediaResources[
                      globalMediaResourcesController.currentMediaIndex.value]
                  .name,
              style: TextStyle(fontSize: appBarTitleTextSize),
            )),
      leadingWidth: appBarLeadingWidth,
      leading: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            width: 75,
          ),
          IconButton(
            padding: EdgeInsets.all(appBarButtonPadding),
            onPressed: () async {
              if (onPressed) {
                return;
              }
              onPressed = true;
              await openMediaResourcesFolder();
              onPressed = false;
            },
            icon: Icon(
              Icons.folder_open,
              size: appBarButtonSize,
            ),
          ),
          IconButton(
            padding: EdgeInsets.all(appBarButtonPadding),
            onPressed: () {},
            icon: Icon(Icons.settings, size: appBarButtonSize),
          ),
          IconButton(
            padding: EdgeInsets.all(appBarButtonPadding),
            onPressed: () {},
            icon: Icon(Icons.help, size: appBarButtonSize),
          ),
        ],
      ),
      actions: [],
    ),
  );
}
