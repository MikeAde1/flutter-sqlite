
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'data/ClientModel.dart';
import 'data/Database.dart';

class DetailScreen extends StatefulWidget{

  final Client client;
  DetailScreen({this.client});

  @override
  Detail createState() => Detail(client);
}

class Detail extends State<DetailScreen>{
  final Client client;

  Detail(this.client);
  var textController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    textController.text = "${client.lastName}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Client detail"),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(controller: textController),
              SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: RaisedButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      child: Text("Update"),
                      onPressed: (){
                        Client client = new Client(
                            id: this.client.id,
                            firstName: this.client.firstName,
                            lastName: textController.text,
                            blocked: this.client.blocked);
                        DBProvider.db.updateClient(client);
                        Fluttertoast.showToast(msg: textController.text);
                        Navigator.pop(context);
                      }
                  )
              )
            ],
          )
      ),
    );
  }
}