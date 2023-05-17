import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:flutter/services.dart';
import 'dart:async';

  class WS extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("WS"),
          backgroundColor: Colors.greenAccent,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Volver a pantalla de inicio'),
          ),
        ),
      );
    }

    /****************************************************************************************************************************/
    //Conexión con la DB
    static String host = 'localhost',
        user = 'root',
        password = '',
        db = 'lprofundizacionii';
    static int port = 3306;

    Mysql() {
      // TODO: implement Mysql
      throw UnimplementedError();
    }

    Future<MySqlConnection> getConnection() async {
      var settings = new ConnectionSettings(
          host: host,
          port: port,
          user: user,
          password: password,
          db: db

      );
      return await MySqlConnection.connect(settings);
    }
  }