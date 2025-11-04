// lib/dao/produit_dao.dart

import 'package:drift/drift.dart';
import 'package:productapp/data/base.dart'; // Importe ProduitsDatabase et les tables générées

// Le 'part' est dans base.dart, ce fichier est un simple DAO.

// Définition de la classe DAO
class ProduitDAO {
  final ProduitsDatabase attachedDatabase;

  ProduitDAO(this.attachedDatabase);

  // 1. Insertion d'un nouveau produit (Create)
  Future<void> insertProduit(ProduitsCompanion entry) => 
      attachedDatabase.into(attachedDatabase.produits).insert(entry);

  // 2. Récupération de TOUS les produits (Read - Stream pour la réactivité)
  Stream<List<Produit>> getProduitsStream() => 
      attachedDatabase.select(attachedDatabase.produits).watch();

  // 3. Récupération d'un produit par ID
  Future<Produit> getProduitById(int id) {
    return (attachedDatabase.select(attachedDatabase.produits)
          ..where((p) => p.id.equals(id)))
        .getSingle();
  }

  // 4. Mise à jour d'un produit
  Future<void> updateProduit(Produit entry) => 
      attachedDatabase.update(attachedDatabase.produits).replace(entry);

  // 5. Suppression d'un produit par ID
  Future<void> deleteProduitById(int id) => 
      (attachedDatabase.delete(attachedDatabase.produits)..where((p) => p.id.equals(id))).go();
}