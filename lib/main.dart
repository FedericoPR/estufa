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
      home: Scaffold(
          body: Center(
              child: ListView(
                children: [
                Text(texto['nombre'],style: TextStyle(fontSize: 50,fontWeight: FontWeight.bold)),
               SfRadialGauge(
                axes: <RadialAxis>[
                    RadialAxis(minimum: 0, maximum: double.parse(texto['estado']['maxtemp'].toString()),
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: 30, color:Colors.green),
                      GaugeRange(startValue: 30,endValue: 70,color: Colors.orange),
                      GaugeRange(startValue: 70,endValue: 100,color: Colors.red)],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: double.parse(texto['estado']['temp'].toString()))],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(widget: Container(child:
                      Text(texto['estado']['temp'].toString(),style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                          angle: 90, positionFactor: 0.5
                      )]
                )])
                ],
              ),
          ),
      ),
    );
  }

}