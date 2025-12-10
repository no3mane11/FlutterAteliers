// lib/data/open_db_web.dart
// Utilisé uniquement quand l'app tourne sur le web (Flutter web)

import 'package:drift/drift.dart';
import 'package:drift/web.dart';

// ⚠️ NOM EXACT : openConnection
LazyDatabase openConnection() {
  return LazyDatabase(() async {
    return WebDatabase('produits_db');
  });
}
