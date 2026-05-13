import 'package:flutter/material.dart';
import 'package:projet/projet_e_commerce/data/list_produits.dart';
import 'package:projet/projet_e_commerce/model/class_produit.dart';
import 'package:projet/projet_e_commerce/myWidgets/un_produit.dart';
import 'package:projet/projet_e_commerce/pages/produit_detail.dart';
import 'package:projet/projet_e_commerce/services/firebase_services_crud.dart';

class ProduitListPage extends StatefulWidget {
  const ProduitListPage({super.key});

  @override
  State<ProduitListPage> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProduitListPage> {
  List<Produit> mesProduits = [];
  var fbc = FirebaseCrud();
  var isLoading = false;

  Future<void> getListProduit() async {
    setState(() {
      isLoading = true;
    });

    dynamic tmp = await fbc.loadData();
    setState(() {
      mesProduits = tmp;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getListProduit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Page Liste des produits"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 0.4,
              children: List.generate(mesProduits.length, (index) {
                return InkWell(
                  onTap: () {
                    //Implémenter la navigation pour charger la page Detail produits
                    Navigator.pushNamed(
                      context,
                      'detailProduit',
                      arguments: index,
                    );
                    // ProduitDetailPage(produit: AllProductData.Produits[index]);
                  },
                  child: WidgetProduit(p: mesProduits[index]),
                );
              }),
            ),
    );
  }
}
