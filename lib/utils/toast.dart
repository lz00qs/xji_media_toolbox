import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';

class Toast {
  static void info(String message) {
    toastification.show(
      type: ToastificationType.info,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Info', style: TextStyle(color: ColorDark.info)),
      description:
          Text(message),
    );
  }

  static void success(String message) {
    toastification.show(
      type: ToastificationType.success,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Success', style: TextStyle(color: ColorDark.success)),
      description:
          Text(message),
    );
  }

  static void warning(String message) {
    toastification.show(
      type: ToastificationType.warning,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Warning', style: TextStyle(color: ColorDark.warning)),
      description:
          Text(message),
    );
  }

  static void error(String message) {
    toastification.show(
      type: ToastificationType.error,
      autoCloseDuration: const Duration(seconds: 3),
      title: const Text('Error', style: TextStyle(color: ColorDark.danger)),
      description:
          Text(message),
    );
  }
}
