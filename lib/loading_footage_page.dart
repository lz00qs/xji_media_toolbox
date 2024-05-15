import 'package:flutter/material.dart';

class LoadingFootagePage extends StatelessWidget {
  const LoadingFootagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('Loading Footage...'),
        ],
      ),
    ));
  }
}
