import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:xji_footage_toolbox/models/media_resource.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

class LoadingMediaResourcesPage extends ConsumerWidget {
  const LoadingMediaResourcesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loadProgress =
        ref.watch(mediaResourcesProvider.select((state) => state.loadProgress));
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
              child: LinearProgressIndicator(
                value: loadProgress,
                color: ColorDark.primary,
                minHeight: DesignValues.mediumBorderRadius * 2,
                borderRadius:
                    BorderRadius.circular(DesignValues.mediumBorderRadius),
                backgroundColor: ColorDark.bg2,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Loading Media Resources: '
              '${(loadProgress * 100).toStringAsFixed(2)}%',
              style: SemiTextStyles.header4ENRegular.copyWith(
                color: ColorDark.text1,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
