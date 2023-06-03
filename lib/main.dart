import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:lineadeprof/View/Geoposition.dart';
import 'package:lineadeprof/View/WS.dart';
import 'package:local_auth/auth_strings.dart';
import 'package:lineadeprof/Editar.dart';
import 'package:lineadeprof/ActualizarDatos.dart';
import 'DTO/Token.dart';
import 'DTO/User.dart';
import 'View/Registro.dart';
import 'View/Rest.dart';
import 'firebase_options.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

final db=FirebaseFirestore.instance;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        initialRoute:'/',
        routes: {
          '/': (context) => Home(),
          '/editar': (context)=> const AddNamePage(),
          '/actualizar': (context)=> const EditNamePage(),
        },
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeStart createState() => HomeStart();
}

class HomeStart extends State<Home> {
  TextEditingController nombre = TextEditingController();
  TextEditingController contrasena = TextEditingController();
  final LocalAuthentication auth = LocalAuthentication();
  User objUser = User();
  //Declaración variable que definira si es Invitado o Administrador
  int IyA = 0;

  validarDatos() async {
    try {
      CollectionReference ref =
          FirebaseFirestore.instance.collection("Usuarios");
      QuerySnapshot usuario = await ref.get();

      if (usuario.docs.length != 0) {
        for (var cursor in usuario.docs) {
          if (cursor.get("NombreUsuario") == nombre.text) {
            print("Usuario Encontrado");
            print(cursor.get("IdentidadUsuario"));
            if (cursor.get("ContraseñaUsuario") == contrasena.text) {
              print("ACCESO PERMITIDO!");
              print("BIENVENIDO " + nombre.text);
              objUser.nombre = cursor.get("NombreUsuario");
              objUser.identidad = cursor.get("IdentidadUsuario");
              objUser.rol = ("Administrador");
              objUser.estado = cursor.get("Estado");

              //Definicion que indica que Invitado correspondera a 1 y Admin a 2,
              // llamando la clase mensaje para indicar el modulo de bienvenida
              if (cursor.get("Rol") == "Invitado") {
                mensaje("Invitado", "Bienvenido INVITADO " + nombre.text);
                IyA = 1;
              } else if (cursor.get("Rol") == "Admin") {
                mensaje(
                    "Administrador", "Bienvenido ADMINISTRADOR " + nombre.text);
                IyA = 2;
              }
            } else {
              print("La contraseña es incorrecta");
            }
          }
        }
      } else {
        print("No hay documentos en la colección!");
      }
    } catch (e) {
      print("ERROR... " + e.toString());
    }
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenidos',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Linea de Profundización II'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Container(
                  width: 300,
                  height: 300,
                  child: Image.asset('img/img1.png'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 50, right: 50),
                child: TextField(
                  controller: nombre,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Usuario',
                      hintText: 'Digite su usuario'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30, left: 50, right: 50),
                child: TextField(
                  controller: contrasena,
                  obscureText: true,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      labelText: 'Password Usuario',
                      hintText: 'Digite contraseña de usuario'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: ElevatedButton(
                  onPressed: () {
                    print('Ingresando...!');
                    validarDatos();
                  },
                  child: Text('Ingresar'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Registro(objUser)));
                  },
                  child: Text('Registrar'),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(50, 50),
                  ),
                  onPressed: () async {
                    if (await biometrico()) {
                      mensaje("Huella", "Huella Encontrada");
                    }
                  },
                  child: Icon(Icons.fingerprint, size: 80),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => Rest(objUser)));
                  },
                  child: Text('Rest'),
                ),
              ),

              //Boton para el web service

              Padding(
                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => WS()));
                  },
                  child: Text('WS'),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void mensaje(String titulo, String contenido) {
    showDialog(
        context: context,
        builder: (buildcontext) {
          return AlertDialog(
            title: Text(titulo),
            content: Text(contenido),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Geoposition()));
                  if (IyA == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => invitado()),
                    );
                  } else if (IyA == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => admin()),
                    );
                  }
                },
                child: Text('Aceptar'),
              )
            ],
          );
        });
  }

  Future<bool> biometrico() async {
    //print("biométrico");

    // bool flag = true;
    bool authenticated = false;

    const androidString = AndroidAuthMessages(
      cancelButton: "Cancelar",
      goToSettingsButton: "Ajustes",
      signInTitle: "Ingrese",
      //fingerprintNotRecognized: 'Error de reconocimiento de huella digital',
      goToSettingsDescription: "Confirme su huella",
      //fingerprintSuccess: 'Reconocimiento de huella digital exitoso',
      biometricHint: "Toque el sensor",
      //signInTitle: 'Verificación de huellas digitales',
      biometricNotRecognized: "Huella no reconocida",
      biometricRequiredTitle: "Required Title",
      biometricSuccess: "Huella reconocida",
      //fingerprintRequiredTitle: '¡Ingrese primero la huella digital!',
    );
    bool canCheckBiometrics = await auth.canCheckBiometrics;
    // bool isBiometricSupported = await auth.();
    bool isBiometricSupported = await auth.isDeviceSupported();
    List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    print(canCheckBiometrics); //Returns trueB
    // print("support -->" + isBiometricSupported.toString());
    print(availableBiometrics.toString()); //Returns [BiometricType.fingerprint]
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Autentíquese para acceder",
          useErrorDialogs: true,
          stickyAuth: true,
          //biometricOnly: true,
          androidAuthStrings: androidString);
      if (!authenticated) {
        authenticated = false;
      }
    } on PlatformException catch (e) {
      print(e);
    }
    /* if (!mounted) {
        return;
      }*/

    return authenticated;
  }
}

//Creación pantallas de Invitado y Administrador,
//cada una con diferente color y con botones de regreso a la clase main
class invitado extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Invitado"),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('GPS'),
        ),
      ),
    );
  }
}

//DESDE ADMIN SE MANEJARAN LAS ACCIONES DEL CRUD EXCEPTUANDO LA DE INSERTAR QUE YA SE ENCUENTRA EN REGISTRAR
/********************************************************************************************************************/
final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('Usuarios');
class admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin'),
        backgroundColor: Colors.amberAccent,
      ),
      body: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => Actualizar()));

                },
                child: Text('Consultar'),
              ),
            ),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context,'/editar');
                },
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),

      ),
    );

  }
}

//Actualizar

//Pagina para consultar y actualizar
class Actualizar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultar'),
        backgroundColor: Colors.deepPurple,
      ),
      body: FutureBuilder(
          future: getPeople(),
          builder: ((context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index){
                    return ListTile(
                        onLongPress: ()  async {
                          deletePeople(snapshot.data?[index]['uid']);
                        },
                        title: Text(snapshot.data?[index]['NombreUsuario']),
                        onTap: (() {
                          Navigator.pushNamed(context, "/actualizar", arguments: {
                            "NombreUsuario": snapshot.data?[index]['NombreUsuario'],
                            "CorreoUsuario":snapshot.data?[index]['CorreoUsuario'],
                            "IdentidadUsuario":snapshot.data?[index]['IdentidadUsuario'],
                            "Telefonousuario":snapshot.data?[index]['Telefonousuario'],
                            "ContraseñaUsuario":snapshot.data?[index]['ContraseñaUsuario'],
                            "Rol":snapshot.data?[index]['Rol'],
                            "uid":snapshot.data?[index]['uid'],
                          });
                        }));
                  });
            }else{
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }
          )
      ),
    );
  }
}

FirebaseFirestore firestore = FirebaseFirestore.instance;

// Funcion para eliminar datos

Future<void> deletePeople(String uid) async{
  await firestore.collection("Usuarios").doc(uid).delete();
}

//Fin de la funcion para eliminar datos


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
