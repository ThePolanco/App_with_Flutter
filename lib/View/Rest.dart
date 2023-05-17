import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../DTO/User.dart';


class Rest extends StatefulWidget{
  Rest(User objUser);

  RestApp createState() => RestApp();
}

class RestApp extends State<Rest> {
  TextEditingController id = TextEditingController();
  TextEditingController  value = TextEditingController();
  TextEditingController title = TextEditingController();

  consumirGet(var id) async {
    try {
      Response response = await get(
          Uri.parse("http://heaven4.tripod.com/index2.htm/" + id));
      Map data = jsonDecode(response.body);

      print(response.statusCode.toString());

      if (response.statusCode.toString() == '200') {

        title.text='${data['name']}';
        value.text=response.statusCode.toString();
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Http Recuest'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: (){
                    consumirGet(id.text);
                  },child: Text('HTTP'),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30, left: 500, right: 500),
                child: TextField(
                  controller: id,
                  decoration: InputDecoration(
                      labelText: 'Dato'
                  ),
                  style: TextStyle(
                      color: Color(0xFF0097ff)
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30, left: 500, right: 500),
                child: TextField(
                  controller: value,
                  decoration: InputDecoration(
                      labelText: 'Response'
                  ),
                  style: TextStyle(
                      color: Color(0xFF0097ff)
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 30, left: 500, right: 500),
                child: TextField(
                  controller: title,
                  decoration: InputDecoration(
                      labelText: 'Code response'
                  ),
                  style: TextStyle(
                      color: Color(0xFF0097ff)
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

