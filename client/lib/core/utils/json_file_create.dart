import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> saveResponse(dynamic data) async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/response_dump.json');
  await file.writeAsString(const JsonEncoder.withIndent('  ').convert(data));
  print('✅ Saved response at: ${file.path}');
}
