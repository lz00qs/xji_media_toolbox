import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/main.dart';

void main() {
  testWidgets('renders the application shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: MyApp(isFFmpegAvailable: true),
        ),
      ),
    );

    expect(find.byType(MyApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
