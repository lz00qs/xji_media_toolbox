import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global_controller.dart';

class GalleryListWidget extends StatelessWidget {
  const GalleryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalController controller = Get.find();

    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Column(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: () {
                      controller.isFootageListView.value = false;
                    },
                    icon: const Icon(
                      Icons.grid_view,
                      size: 20,
                    )),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: List<Widget>.generate(
                    controller.footageList.length,
                    (index) {
                      return ListTile(
                        title: Row(
                          children: [
                            Flex(
                              direction: Axis.vertical,
                              // mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 100,
                                  height: 100 * 0.618,
                                  child: controller
                                              .footageList[index].thumbFile ==
                                          null
                                      ? Image.asset(
                                          'assets/images/resource_not_found.jpeg',
                                          fit: BoxFit.cover)
                                      : Image.file(
                                          controller
                                              .footageList[index].thumbFile!,
                                          fit: BoxFit.contain,
                                        ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: Text(
                              controller.footageList[index].name,
                              style: const TextStyle(fontSize: 12),
                            )),
                          ],
                        ),
                        onTap: () {},
                      );
                    },
                  ),
                )),
          ),
        ],
      );
    });
  }
}
