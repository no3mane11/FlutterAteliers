// lib/data/base.dart

import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

// Nécessaire pour que le générateur de code (build_runner) puisse fonctionner
part 'base.g.dart'; 

// 1. Définition de la Table (Similaire à votre classe Produit)
@DataClassName('Produit') // Utilise la classe Produit pour le modèle généré
class Produits extends Table {
  // L'ID est la clé primaire
  IntColumn get id => integer().autoIncrement()(); 
  
  // Champs dérivés de votre modèle Produit
  TextColumn get libelle => text().withLength(min: 1, max: 128)();
  TextColumn get description => text().withLength(min: 1, max: 512).nullable()();
  RealColumn get prix => real().withDefault(const Constant(0.0))();
  TextColumn get photo => text().nullable()(); // Chemin du fichier image
}

// 2. Définition de la Base de Données
@DriftDatabase(tables: [Produits])
class ProduitsDatabase extends _$ProduitsDatabase {
  ProduitsDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

// Fonction utilitaire pour ouvrir la connexion à la base de données (SQLite native)
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'produits.db')); 
    
    // Retourne la connexion native pour les applications mobile/desktop
    return NativeDatabase.createBackgroundConnection(file);
  });
}