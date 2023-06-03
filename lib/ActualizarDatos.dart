//Actualizar
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lineadeprof/DTO/Token.dart';


class EditNamePage extends StatefulWidget {
  const EditNamePage({super.key});

  @override
  State<EditNamePage> createState() => _EditNamePageState();
}

class _EditNamePageState extends State<EditNamePage> {

  TextEditingController nameController= TextEditingController(text: "");
  TextEditingController CorreoController=TextEditingController(text: "");
  TextEditingController IdentidadController=TextEditingController(text: "");
  TextEditingController TelefonoController=TextEditingController(text: "");
  TextEditingController ContrasenaController=TextEditingController(text: "");
  TextEditingController RolController=TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {

    final Map arguments=ModalRoute.of(context)!.settings.arguments as Map;

    nameController.text=arguments['NombreUsuario'];
    CorreoController.text=arguments['CorreoUsuario'];
    IdentidadController.text=arguments['IdentidadUsuario'];
    TelefonoController.text=arguments['Telefonousuario'];
    ContrasenaController.text=arguments['ContraseñaUsuario'];
    RolController.text=arguments['Rol'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar datos'),
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
                  await updatepeople(arguments['uid'],nameController.text,CorreoController.text,IdentidadController.text,TelefonoController.text,ContrasenaController.text,RolController.text);
                },
                child: const Text("Actualizar"))
          ],
        ),
      ),
    );
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

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