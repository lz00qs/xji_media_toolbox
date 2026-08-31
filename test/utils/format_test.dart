import 'package:flutter_test/flutter_test.dart';
import 'package:xji_footage_toolbox/utils/format.dart';

void main() {
  group('formatDuration', () {
    test('formats hours, minutes, and seconds with zero padding', () {
      expect(
        formatDuration(const Duration(hours: 27, minutes: 2, seconds: 3)),
        '27:02:03',
      );
    });

    test('optionally includes three-digit milliseconds', () {
      expect(
        formatDuration(
          const Duration(minutes: 1, seconds: 4, milliseconds: 7),
          showMilliseconds: true,
        ),
        '0:01:04.007',
      );
    });
  });

  group('formatSize', () {
    test('uses the expected unit at every binary size boundary', () {
      expect(formatSize(0), '0 B');
      expect(formatSize(1023), '1023 B');
      expect(formatSize(1024), '1.00 KB');
      expect(formatSize(1024 * 1024 - 1), '1024.00 KB');
      expect(formatSize(1024 * 1024), '1.00 MB');
      expect(formatSize(1024 * 1024 * 1024), '1.00 GB');
    });
  });

  test('parseAebEvBias maps the seven AEB positions and defaults safely', () {
    expect(List.generate(7, parseAebEvBias), [
      '0.0',
      '-0.7',
      '+0.7',
      '-1.3',
      '+1.3',
      '-2.0',
      '+2.0',
    ]);
    expect(parseAebEvBias(-1), '0.0');
    expect(parseAebEvBias(7), '0.0');
  });
}
