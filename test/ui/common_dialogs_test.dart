import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:xji_footage_toolbox/models/settings.model.dart';
import 'package:xji_footage_toolbox/ui/dialogs/aeb_add_suffix_dialog.dart';
import 'package:xji_footage_toolbox/ui/dialogs/dual_option_dialog.dart';
import 'package:xji_footage_toolbox/ui/dialogs/media_resource_delete_dialog.dart';
import 'package:xji_footage_toolbox/ui/dialogs/media_resource_rename_dialog.dart';
import 'package:xji_footage_toolbox/ui/dialogs/media_resources_sort_dialog.dart';

import '../helpers/media_fixtures.dart';

void main() {
  testWidgets('dialog checkbox renders its value and forwards taps', (
    tester,
  ) async {
    var checkedTaps = 0;
    var uncheckedTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            DialogCheckBoxWithText(
              text: 'Checked',
              value: true,
              onPressed: () => checkedTaps++,
            ),
            DialogCheckBoxWithText(
              text: 'Unchecked',
              value: false,
              onPressed: () => uncheckedTaps++,
            ),
          ],
        ),
      ),
    );

    expect(find.byIcon(Icons.check_box), findsOneWidget);
    expect(find.byIcon(Icons.check_box_outline_blank), findsOneWidget);
    await tester.tap(find.byIcon(Icons.check_box));
    await tester.tap(find.byIcon(Icons.check_box_outline_blank));
    expect(checkedTaps, 1);
    expect(uncheckedTaps, 1);
  });

  testWidgets('dual option dialog disables only the requested action', (
    tester,
  ) async {
    var cancelTaps = 0;
    var confirmTaps = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: DualOptionDialog(
          width: 400,
          height: 240,
          title: 'Confirm',
          option1: 'Cancel',
          option2: 'Continue',
          onOption1Pressed: () => cancelTaps++,
          onOption2Pressed: () => confirmTaps++,
          disableOption2: true,
          child: const Text('Question'),
        ),
      ),
    );

    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.tap(find.widgetWithText(TextButton, 'Continue'));
    expect(cancelTaps, 1);
    expect(confirmTaps, 0);
    expect(
      tester
          .widget<TextButton>(find.widgetWithText(TextButton, 'Continue'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('delete dialog uses singular/plural copy and returns choices', (
    tester,
  ) async {
    Object? result;
    await pumpDialogLauncher(
      tester,
      dialog: const MediaResourceDeleteDialog(mediaResourcesLength: 1),
      onResult: (value) => result = value,
    );
    expect(
      find.text('Move this media resource to the system Trash or Recycle Bin?'),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Move'));
    await tester.pumpAndSettle();
    expect(result, isTrue);

    result = null;
    await pumpDialogLauncher(
      tester,
      dialog: const MediaResourceDeleteDialog(mediaResourcesLength: 3),
      onResult: (value) => result = value,
    );
    expect(
      find.text(
        'Move these 3 media resources to the system Trash or Recycle Bin?',
      ),
      findsOneWidget,
    );
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pumpAndSettle();
    expect(result, isFalse);
  });

  testWidgets('AEB suffix confirmation returns the selected result', (
    tester,
  ) async {
    Object? result;
    await pumpDialogLauncher(
      tester,
      dialog: const AebAddSuffixDialog(),
      onResult: (value) => result = value,
    );
    expect(find.text('Add AEB Suffix'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextButton, 'Add'));
    await tester.pumpAndSettle();
    expect(result, isTrue);
  });

  testWidgets('sort dialog returns the edited type and direction', (
    tester,
  ) async {
    Object? result;
    await pumpDialogLauncher(
      tester,
      dialog: const MediaResourcesSortDialog(sort: Sort()),
      onResult: (value) => result = value,
    );

    await tester.tap(find.byType(DropdownButton<SortType>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('sequence').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButton<bool>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Descending').last);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'OK'));
    await tester.pumpAndSettle();

    expect(result, const Sort(sortType: SortType.sequence, sortAsc: false));
  });

  testWidgets(
    'rename dialog validates empty, illegal, existing, and fresh names',
    (tester) async {
      final directory = Directory.systemTemp.createTempSync(
        'xji-rename-dialog-test-',
      );
      addTearDown(() {
        if (directory.existsSync()) directory.deleteSync(recursive: true);
      });
      final source = File(p.join(directory.path, 'source.JPG'));
      final existing = File(p.join(directory.path, 'existing.JPG'));
      source.writeAsStringSync('source');
      existing.writeAsStringSync('existing');
      Object? result;
      await pumpDialogLauncher(
        tester,
        dialog: MediaResourceRenameDialog(
          mediaResource: photoFixture(name: 'source.JPG', file: source),
        ),
        onResult: (value) => result = value,
      );
      final field = find.byType(TextField);
      final renameButton = find.widgetWithText(TextButton, 'Rename');

      expect(find.text('File already exists'), findsOneWidget);
      expect(tester.widget<TextButton>(renameButton).onPressed, isNull);

      await tester.enterText(field, '');
      await tester.pump();
      expect(find.text('Invalid name'), findsOneWidget);

      await tester.enterText(field, 'bad/name');
      await tester.pump();
      expect(find.text('Invalid name'), findsOneWidget);

      await tester.enterText(field, 'existing');
      await tester.pump();
      expect(find.text('File already exists'), findsOneWidget);

      await tester.enterText(field, 'fresh');
      await tester.pump();
      expect(find.text('File already exists'), findsNothing);
      expect(find.text('Invalid name'), findsNothing);
      expect(tester.widget<TextButton>(renameButton).onPressed, isNotNull);
      await tester.tap(renameButton);
      await tester.pump(const Duration(milliseconds: 500));
      expect(result, 'fresh');
    },
  );

  testWidgets('rename dialog supports extensionless resource names', (
    tester,
  ) async {
    Object? result;
    await pumpDialogLauncher(
      tester,
      dialog: MediaResourceRenameDialog(
        mediaResource: photoFixture(
          name: 'source',
          file: File('/fixtures/source'),
        ),
      ),
      onResult: (value) => result = value,
    );
    expect(find.byType(TextField), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.tap(find.widgetWithText(TextButton, 'Cancel'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(result, isNull);
  });
}

Future<void> pumpDialogLauncher(
  WidgetTester tester, {
  required Widget dialog,
  required ValueChanged<Object?> onResult,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () async {
              final result = await showDialog<Object?>(
                context: context,
                builder: (_) => dialog,
              );
              onResult(result);
            },
            child: const Text('Open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
}
