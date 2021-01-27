
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance';

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  void realchanged(String text){
    print(text);
  }
  void dolarchanged(String text){
    print(text);
  }
  void eurochanged(String text){
    print(text);
  }

  final realcontroller = TextEditingController();
  final dolarcontroller = TextEditingController();
  final eurocontroller = TextEditingController();

  double dolar;
  double euro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text('Conversor ', style: TextStyle(color: Colors.black87)),
            backgroundColor: Colors.amber,
            centerTitle: true),
        body: FutureBuilder<Map>(
            future: getData(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Icon(
                    Icons.get_app_rounded,
                    color: Colors.amber,
                    size: 150,
                  ));
                  break;

                  default:
                  if (snapshot.hasError
                  || snapshot.data.containsKey('error')) {
                    return Center(
                        child: Text(
                      'Erro ao carregar dados',
                      style: TextStyle(color: Colors.amber, fontSize: 20),
                    ));
                  } else {

                    dolar = snapshot.data['results']['currencies']['USD']['buy'];
                    euro = snapshot.data['results']['currencies']['EUR']['buy'];

                    return SingleChildScrollView(
                      child: Padding(padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Icon(
                              Icons.monetization_on, size: 145,
                              color: Colors.amber,
                            ),
                          TextField(
                            controller: realcontroller,
                            decoration: InputDecoration(
                              labelText: 'Real',
                              labelStyle: TextStyle(color: Colors.amber,
                                fontSize: 18,
                              ),

                            ),
                          onChanged: realchanged,
                          ),
                          Divider(),
                          TextField(
                            controller: dolarcontroller,
                            decoration: InputDecoration(
                              labelText: 'Dólar',
                              labelStyle: TextStyle(color: Colors.amber,
                                fontSize: 18,
                              ),
                              border: OutlineInputBorder(),
                              prefixText: 'US \$',
                            ),
                            onChanged: dolarchanged,),
                          Divider(),
                          buildTextField( 'Euro', "euro"),
                          ],
                        ),
                      ),
                    );
                  }
                  break;
              }
            }));
  }
}

  Widget buildTextField( String label, String prefix){
  return TextField(
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber,
        fontSize: 18,
      ),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),);
}

void main() async {
  print(await getData());

  runApp(
    MaterialApp(
      home: Home(),
      theme: ThemeData(
          hintColor: Colors.amber,
          primaryColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
            hintStyle: TextStyle(color: Colors.amber),
          ))
    ));
}
