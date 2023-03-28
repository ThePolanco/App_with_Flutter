import "dart:async";

import "package:flutter/material.dart";
import "package:geolocator/geolocator.dart";

class Geoposition extends StatefulWidget {
  GeopositionApp createState() => GeopositionApp();
}

class GeopositionApp extends State<Geoposition> {
  TextEditingController latitud = TextEditingController();
  TextEditingController longitud = TextEditingController();
  late Position position;
  @override
  Widget build(BuildContext) {
    return Scaffold(
      appBar: AppBar(
        title: Text("GPS"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child:
                    ElevatedButton(onPressed: () async{
                      print(await determinePosition());
                      longitud.text = await determinePosition().toString();
                      latitud.text = await determinePosition().toString();
                    }, child: Text("Ubicación")),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: latitud,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: false,
                      labelText: "Latitud"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                  controller: longitud,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      enabled: false,
                      labelText: "Longitud"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
    } else {
      Geolocator.openLocationSettings();
    }
    if (!serviceEnabled) {
      return Future.error("No disponible");
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == await LocationPermission.denied) {
        return Future.error("Permiso denegado");
      }
    }
    print (await Geolocator.getCurrentPosition());
    return await Geolocator.getCurrentPosition();
  }
}
