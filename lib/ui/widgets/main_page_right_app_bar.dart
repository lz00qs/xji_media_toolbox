import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xji_footage_toolbox/constants.dart';

class _MainPageMacRightAppBar extends StatelessWidget {
  const _MainPageMacRightAppBar();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: macAppBarHeight,
      child: Text('Right App Bar'),
    );
  }
}

class MainPageRightAppBar extends StatelessWidget {
  const MainPageRightAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GetPlatform.isMacOS
        ? const _MainPageMacRightAppBar()
        : const SizedBox();
  }
}
