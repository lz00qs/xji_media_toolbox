import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

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
        body: Container(
      color: ColorDark.bg1,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 1000,
              child: Obx(() => LinearProgressIndicator(
                    value: loadingMediaResourcesController.progress.value,
                    color: ColorDark.primary,
                    minHeight: DesignValues.mediumBorderRadius * 2,
                    borderRadius:
                        BorderRadius.circular(DesignValues.mediumBorderRadius),
                    backgroundColor: ColorDark.bg2,
                  )),
            ),
            const SizedBox(height: 20),
            Obx(() => Text(
                  'Loading Media Resources: '
                  '${(loadingMediaResourcesController.progress.value * 100).toStringAsFixed(2)}%',
                  style: SemiTextStyles.header4ENRegular.copyWith(
                    color: ColorDark.text1,
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
