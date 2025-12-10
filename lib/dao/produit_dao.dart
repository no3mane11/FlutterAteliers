// lib/dao/produit_dao.dart

import 'package:drift/drift.dart';
import 'package:productapp/data/base.dart';

class ProduitDAO {
  final ProduitsDatabase attachedDatabase;

  ProduitDAO(this.attachedDatabase);

  // 1. Insertion d'un nouveau produit (Create)
  Future<int> insertProduit(ProduitsCompanion entry) =>
      attachedDatabase.into(attachedDatabase.produits).insert(entry);

  // 2. Récupération de TOUS les produits (Read - Stream pour la réactivité)
  Stream<List<Produit>> getProduitsStream() =>
      attachedDatabase.select(attachedDatabase.produits).watch();

  // 3. Récupération d'un produit par ID (nullable si pas trouvé)
  Future<Produit?> getProduitById(int id) async {
    final query = attachedDatabase.select(attachedDatabase.produits)
      ..where((p) => p.id.equals(id));
    return query.getSingleOrNull();
  }

  // 4. Mise à jour d'un produit
  Future<bool> updateProduit(Produit entry) async {
    final rows = await attachedDatabase.update(attachedDatabase.produits).replace(entry);
    // replace retourne void, donc on considère que si aucune exception, ok.
    return true;
  }

  // 5. Suppression d'un produit par ID
  Future<int> deleteProduitById(int id) =>
      (attachedDatabase.delete(attachedDatabase.produits)..where((p) => p.id.equals(id))).go();
}
