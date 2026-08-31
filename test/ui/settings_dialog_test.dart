import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/ui/design_tokens.dart';
import 'package:xji_footage_toolbox/ui/dialogs/settings_dialog.dart';

void main() {
  testWidgets('advanced FFmpeg settings use the application dialog style', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1000, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: SettingsDialog()),
      ),
    );

    await tester.tap(find.text('Advanced'));
    await tester.pumpAndSettle();

    expect(find.text('Runtime:'), findsOneWidget);
    expect(find.text('Version:'), findsWidgets);
    expect(find.text('Custom FFmpeg Directory'), findsOneWidget);
    expect(find.text('Use Bundled'), findsOneWidget);
    expect(find.text('Apply Custom'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);

    final runtimeLabel = tester.widget<Text>(find.text('Runtime:'));
    expect(runtimeLabel.style?.fontSize, SemiTextStyles.header5ENRegular.fontSize);
    expect(runtimeLabel.style?.color, ColorDark.text1);
    expect(tester.takeException(), isNull);
  });
}
