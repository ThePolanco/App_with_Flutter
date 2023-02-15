import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Home());
    }
}
class Home extends StatefulWidget {
  @override
  HomeStart createState() => HomeStart();
}

class HomeStart extends State<Home>{
Widget build(BuildContext context){
  return MaterialApp(
    title: 'Bienvenidos',
    home: Scaffold(
      appBar: AppBar(
        title: Text('Linea de Profundización II'),

      ),
      body: SingleChildScrollView(
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 10, left: 10, right: 10),
          child: Container(
            width: 300,
            height: 300,
            child: Image.asset('img/img1.png'),
          ),
          ),
          Padding(padding: EdgeInsets.only(top: 10, left: 500, right: 500),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
                ),
                  labelText: 'Email Usuario',
                  hintText: 'Digite email de usuario'
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 30, left: 500, right: 500),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  labelText: 'Password Usuario',
                  hintText: 'Digite contraseña de usuario'
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20, left: 30,right: 30),
           child: ElevatedButton(
             onPressed: (){
                print('Hola Mundo');
             },
             child: Text('Enviar'),
           ),
          )
        ],
      ),
      ),
    ),
  );
  }
}