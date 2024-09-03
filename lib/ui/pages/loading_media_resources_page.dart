import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingMediaResourcesController extends GetxController {
  final isLoadingMediaResources = false.obs;
  final progress = 0.0.obs;
}

class LoadingMediaResourcesPage extends StatelessWidget {
  const LoadingMediaResourcesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final LoadingMediaResourcesController loadingMediaResourcesController =
        Get.find<LoadingMediaResourcesController>();
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 1000,
            child: Obx(() => LinearProgressIndicator(
                  value: loadingMediaResourcesController.progress.value,
                )),
          ),
          const SizedBox(height: 20),
          Obx(() => Text(
                'Loading Media Resources: '
                '${loadingMediaResourcesController.progress.value.toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 20),
              )),
        ],
      ),
    ));
  }
}
