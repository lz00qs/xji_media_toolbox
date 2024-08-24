import 'package:flutter/material.dart';

class LoadingMediaResourcesPage extends StatelessWidget {
  const LoadingMediaResourcesPage({super.key});

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
          Text('Loading and analyzing media resources...'),
        ],
      ),
    ));
  }
}
