import 'dart:convert';
import 'dart:io';

Map<String, dynamic> fixture(String name) {
  final data = File('test/fixtures/$name').readAsStringSync();
  return Map<String, dynamic>.from(jsonDecode(data));
}
