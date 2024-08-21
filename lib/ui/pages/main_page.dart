import 'package:flutter/material.dart';

import '../widgets/resizable_triple_panel_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ResizableTriplePanelWidget(
        topLeftPanel: Text('Top Left Panel'),
        bottomLeftPanel: Text('Bottom Left Panel'),
        rightPanel: Text('Right Panel'),
      ),
    );
  }
}
