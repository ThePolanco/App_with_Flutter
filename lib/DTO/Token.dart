import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class Token{
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String isToken = "";
  FirebaseFirestore firestore = FirebaseFirestore.instance;



  //Crear funcion para consultar del crud
  Future<List> getPeople() async{
    List people = [];
    QuerySnapshot querySnapshot=await firestore.collection('Usuarios').get();
    for (var doc in querySnapshot.docs){
      final Map<String, dynamic> data=doc.data() as Map<String, dynamic>;
      final person ={
        "NombreUsuario": data['NombreUsuario'],
        "CorreoUsuario": data['CorreoUsuario'],
        "IdentidadUsuario": data['IdentidadUsuario'],
        "Telefonousuario": data ['Telefonousuario'],
        "ContraseñaUsuario": data ['ContraseñaUsuario'],
        "Rol": data ['Rol'],
        "uid":doc.id,
      };
      people.add(person);
    };

    return people;
  }
//Fin de funcion para consultar el crud

//Funcion para enviar info
  Future<void> addPeople(name,Correo, Identidad, Telefono,Contrasena,Rol) async {
    await firestore.collection('Usuarios').add({
      "NombreUsuario": name,
      "CorreoUsuario":Correo,
      "IdentidadUsuario":Identidad,
      "Telefonousuario":Telefono,
      "ContraseñaUsuario":Contrasena,
      "Estado":true,
      "Rol":Rol});
  }

//Fin de la funcion para envio de informacion

//funcion para actualizar datos
  Future<void> updatepeople(String uid, newname,newCorreo, newIdentidad, newTelefono,newContrasena,newRol) async {
    await firestore.collection('Usuarios').doc(uid).set({
      "NombreUsuario": newname,
      "CorreoUsuario":newCorreo,
      "IdentidadUsuario":newIdentidad,
      "Telefonousuario":newTelefono,
      "ContraseñaUsuario":newContrasena,
      "Rol":newRol});
  }
//fin de la funcion para actualizar datos

// Funcion para eliminar datos

  Future<void> deletePeople(String uid) async{
    await firestore.collection("Usuarios").doc(uid).delete();
  }

//Fin de la funcion para eliminar datos




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
    print("Dato.....token ---> " + isToken);
    return await isToken;
  }
}