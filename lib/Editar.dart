//Editar
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineadeprof/DTO/Token.dart';

class AddNamePage extends StatefulWidget {
  const AddNamePage({super.key});

  @override
  State<AddNamePage> createState() => _AddNamePageState();
}

class _AddNamePageState extends State<AddNamePage> {

  TextEditingController nameController= TextEditingController(text: "");
  TextEditingController CorreoController=TextEditingController(text: "");
  TextEditingController IdentidadController=TextEditingController(text: "");
  TextEditingController TelefonoController=TextEditingController(text: "");
  TextEditingController ContrasenaController=TextEditingController(text: "");
  TextEditingController RolController=TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Name'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el nuevo nombre',
              ),
            ),
            TextField(
              controller: CorreoController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el nuevo Correo',
              ),
            ),
            TextField(
              controller: IdentidadController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el nuevo documento de identidad',
              ),
            ),
            TextField(
              controller: TelefonoController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el nuevo Telefono celular',
              ),
            ),
            TextField(
              controller: ContrasenaController,
              decoration: const InputDecoration(
                hintText: 'Ingrese la nueva contraseña',
              ),
            ),
            TextField(
              controller: RolController,
              decoration: const InputDecoration(
                hintText: 'Ingrese el Rol del usuario',
              ),
            ),
            ElevatedButton(
                onPressed: () async {
                  addPeople(nameController.text,CorreoController.text,IdentidadController.text,TelefonoController.text,ContrasenaController.text,RolController.text);
                },
                child: const Text("Guardar"))
          ],
        ),
      ),
    );
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

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
