import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Token{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String isToken = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  guardarToken(String idDoc) async{
    await Firebase.initializeApp();
    isToken = (await FirebaseMessaging.instance.getToken())!;

    try{
      await firestore.collection("Usuarios").doc(idDoc).set(
          {"Token":isToken});
    }catch(e){
      print("ERROR en el token --> " + e.toString());
    }
  }

  Future<String> generarToken() async{
    await Firebase.initializeApp();
    isToken = (await FirebaseMessaging.instance.getToken())!;
    print("dato.....token ---> " + isToken);
    return await isToken;
  }
}