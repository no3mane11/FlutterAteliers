// lib/data/open_db_io.dart
// Utilisé sur mobile / desktop (Android, Windows, etc.)

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// ⚠️ NOM EXACT : openConnection
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'produits.db'));
    return NativeDatabase(file);
  });
}
