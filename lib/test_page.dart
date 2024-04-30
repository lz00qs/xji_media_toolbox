import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('GetX Dialog Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Get.dialog(const MyDialog());
          },
          child: const Text('Show Dialog'),
        ),
      ),
    );
  }
}

class MyDialog extends StatelessWidget {
  const MyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Group AEB'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: const Text('Option A'),
            value: false, // 你的状态管理逻辑
            onChanged: (value) {
              // 处理复选框状态改变逻辑
            },
          ),
          CheckboxListTile(
            title: const Text('Option E'),
            value: false, // 你的状态管理逻辑
            onChanged: (value) {
              // 处理复选框状态改变逻辑
            },
          ),
          CheckboxListTile(
            title: const Text('Option B'),
            value: false, // 你的状态管理逻辑
            onChanged: (value) {
              // 处理复选框状态改变逻辑
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // 关闭弹窗
          },
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () async {
            // 显示加载圈
            Get.dialog(
              const Center(
                child: CircularProgressIndicator(),
              ),
              barrierDismissible: false, // 禁止点击背景关闭
            );
            // 执行处理逻辑
            await Future.delayed(
                const Duration(seconds: 2)); // 模拟处理逻辑，这里使用延迟2秒代替processing()方法
            // 关闭加载圈和弹窗
            Get.back();
            Get.back();
          },
          child: const Text('确认'),
        ),
      ],
    );
  }
}
