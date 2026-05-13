import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet/projet_e_commerce/model/class_produit.dart';

class FirebaseCrud {
  //exporter la liste des Produits
  // vers La collection produit
  Future<void> saveData(List<Produit> listep) async {
    // connexion FB
    // flutter pub add cloud_firestore
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    WriteBatch batch = firestore.batch();

    for (var produit in listep) {
      DocumentReference docRef = firestore.collection('produits').doc();
      batch.set(docRef, produit.toMap());
    }

    try {
      await batch.commit();
      print("List produits saved !!");
    } catch (e) {
      print("Erreur de sauvegarde...:$e");
    }
  }

  //get all products from Collection
  Future<List<Produit>> loadData() async {
    List<Produit> res = [];

    final CollectionReference collectionProduits = FirebaseFirestore.instance
        .collection('produits');
    //recupération Select
    QuerySnapshot snapshot = await collectionProduits.get();

    ///liste de document JOSN
    for (var p in snapshot.docs) {
      res.add(
        Produit.fromMap({
          "id": p['id'],
          "title": p['title'],
          "description": p['description'],
          "price": p['price']?.toDouble() ?? 0.0,
          "imageUrl": p['imageUrl'],
          "brand": p['brand'] ?? '',
          "produitCategoryName": p['produitCategoryName'] ?? '',
          "quantity": p['quantity']?.toInt() ?? 0,
        }),
      );
    }
    print("Nombre PRoduit réupéré=${res.length}");
    return res;
  }
}
