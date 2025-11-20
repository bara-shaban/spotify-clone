import 'dart:convert';
import 'dart:developer' show log;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// Utility function to save a JSON response to a file for debugging purposes.
Future<void> saveResponse(dynamic data) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/response_dump.json');
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  log('Response saved to ${file.path}');
}
