// Driver for integration_test/store_screenshots_test.dart: PNGs into SCREENSHOT_DIR.

import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  final dir = Platform.environment['SCREENSHOT_DIR'] ?? 'build/screenshots';
  await integrationDriver(
    onScreenshot: (name, bytes, [args]) async {
      final file = File('$dir/$name.png');
      await file.create(recursive: true);
      await file.writeAsBytes(bytes);
      return true;
    },
  );
}
