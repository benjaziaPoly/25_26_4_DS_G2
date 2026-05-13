import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:projet/projet_e_commerce/data/list_produits.dart';
import 'package:projet/projet_e_commerce/services/firebase_services_crud.dart';

class MonMenu extends StatefulWidget {
  const MonMenu({super.key});

  @override
  State<MonMenu> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MonMenu> {
 

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Ben Jazia"),
            accountEmail: Text("monemail@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                "https://st2.depositphotos.com/1006318/5909/v/450/depositphotos_59094701-stock-illustration-businessman-profile-icon.jpg",
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Acceuil"),
            onTap: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text("Liste Produit"),
            onTap: () {
              Navigator.pushNamed(context, 'listProduit');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text("Mon Panier"),
            onTap: () {
              Navigator.pushNamed(context, 'panier');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favori"),
            onTap: () {
              Navigator.pushNamed(context, 'favorite');
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Profil"),
            onTap: () {
              Navigator.pushNamed(context, 'profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.dangerous),
            title: Text("Exporter liste Produit "),
            enabled: false,
            onTap: () {
              var fbc = FirebaseCrud();
              fbc.saveData(AllProductData.Produits);
            },
          ),
          ListTile(
            leading: Icon(Icons.sunny),
            title: Text("Consulter Méteo "),
            onTap: () {
              Navigator.pushNamed(context, "meteo");
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app_sharp),
            title: Text("Quitter"),
            onTap: () {
              // Test Android : <20 : > 20
              //web :
              //ios :
              //SystemNavigator.pop();
              exit(0);
            },
          ),
        ],
      ),
    );
  }
}
//
/*Future<void> getApi() async{
  await // appel
  // recupération de la réponse
  // utilsiation des data
}*/