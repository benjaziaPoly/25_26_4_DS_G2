import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MeteoScreen extends StatefulWidget {
  @override
  _MeteoScreenState createState() => _MeteoScreenState();
}

class _MeteoScreenState extends State<MeteoScreen> {
  String temperature = "";
  bool isLoading = false;
  //2xx
  //3xx
  //4xx erreur Client => req
  //5xx
  Future<Position?> getPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled)
      return Future.error('Le service de localisation est désactivé.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied)
        return Future.error('Permissions refusées.');
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  Future<void> getMeteoInfo() async {
    setState(() {
      isLoading = true;
    });

    Position? position = await getPosition();

    double latitude = position!.latitude;
    double longitude = position.longitude;
    String endpoint =
        "https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current_weather=true";
    Uri endpoint_verified = Uri.parse(endpoint);
    //Appel !!! : endpoint + parametre + Méthod: get
    try {
      final resultat = await http.get(endpoint_verified);
      if (resultat.statusCode == 200) {
        final data = jsonDecode(resultat.body);
        print(data);
        setState(() {
          temperature =
              data['current_weather']['temperature'].toString() +
              data['current_weather_units']['temperature'].toString();
        });
      } else {
        print("Erreur détectée:" + resultat.statusCode.toString());
      }
    } catch (e) {
      print("Exception détectée:$e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Info de Méteo..."),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 162, 249, 139), Color(0xFF00f2fe)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),

              const Text(
                "//NOM VILLE TODO",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                "//DATE TODO",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(),
              isLoading
                  ? CircularProgressIndicator()
                  : Container(
                      padding: const EdgeInsets.all(30),
                      margin: const EdgeInsets.symmetric(horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            size: 80,
                            color: Colors.yellowAccent,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            temperature,
                            style: const TextStyle(
                              fontSize: 64,
                              fontWeight: FontWeight.w200,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            "//ETAT METEROLOGIQUE",
                            style: const TextStyle(
                              fontSize: 14,
                              letterSpacing: 1.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: () {
                    getMeteoInfo();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "ACTUALISER",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
