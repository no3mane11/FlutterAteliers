// lib/data/base.dart

import 'package:drift/drift.dart';

// Import conditionnel :
// - sur mobile/desktop → open_db_io.dart
// - sur web           → open_db_web.dart
import 'open_db_io.dart'
    if (dart.library.html) 'open_db_web.dart';

part 'base.g.dart';

@DataClassName('Produit')
class Produits extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get libelle => text().withLength(min: 1, max: 128)();
  TextColumn get description => text().withLength(min: 1, max: 512).nullable()();
  RealColumn get prix => real().withDefault(const Constant(0.0))();
  TextColumn get photo => text().nullable()();
}

@DriftDatabase(tables: [Produits])
class ProduitsDatabase extends _$ProduitsDatabase {
  // ⚠️ IMPORTANT : on appelle la fonction top-level openConnection()
  // qui est définie dans open_db_io.dart OU open_db_web.dart
  ProduitsDatabase() : super(openConnection());

  @override
  int get schemaVersion => 1;
}
