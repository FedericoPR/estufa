import'package:flutter/material.dart';
import'package:http/http.dart'as http;
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart';

void main(){
  runApp(MyApp());}


// UI -----------------------------------------
class MyApp extends StatefulWidget{

  @override
  State<MyApp> createState() {
    print("Constructor MyApp");
    return new MyAppState();//el estado ---> otra clase
  }
}

class MyAppState extends State<MyApp> {

  var texto;
  final myController = TextEditingController();

  Future<String> consultar() async{

    print("Lanzar la peticion");
    var respuesta = await http.get("http://192.168.43.29:8008/hello/");
    //192.168.43.29
    // 10.134.1.179
    // sample info available in response
    int statusCode = respuesta.statusCode;
    Map<String, String> headers = respuesta.headers;
    String contentType = headers['content-type'];
    String js = respuesta.body;print(statusCode.toString()+"\n"+ headers.toString()+"\n"+ js.toString());
    print(respuesta.toString());

    return js;

  }

  MyAppState(){
    print("Costructor del State");
    consultar().then(
      (x){
        print(" ======== \n LOTENGO!" + x);
        setState(() {
          texto = json.decode(x);
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Sateful widget'),
        ),
        body: Center(
            child:
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(100.0),
                  child:
                  Text(texto['nombre']),

                ),
                Container(
                  child:
                  Text(texto['estado']['temp'].toString()),
                )
              ],
            )
        ),
      ),
    );
  }

}