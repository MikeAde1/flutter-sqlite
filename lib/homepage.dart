
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/ClientModel.dart';
import 'main.dart';
import 'data/Database.dart';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool visibleState = false;
Client chosenClient;
int chosenItem = -1;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  // data for testing
  List<Client> testClients = [
    Client(firstName: "Mickel", lastName: "Adeneye", blocked: false),
    Client(firstName: "Samuel", lastName: "Adeniyi", blocked: true),
    Client(firstName: "Daniel", lastName: "Adeola", blocked: false),
  ];

  _onItemTap(Client client){
    Navigator.pushNamed(context, DetailPage, arguments: {"client": client});
  }

  _onBackPressed() {
    if (visibleState) {
      setState(() {
        chosenItem = -1;
        visibleState = false;
      });
    } else {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    return WillPopScope(
        onWillPop: () async {
          _onBackPressed();
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              Visibility(
                visible: chosenItem != -1,
                child: Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 15, 0),
                    child: IconButton(
                        icon: Icon(Icons.edit, color: Colors.white),
                        onPressed: (){
                          if(visibleState){
                            setState(() {
                              visibleState = false;
                            });
                            Fluttertoast.showToast(msg: chosenClient.lastName);
                            _onItemTap(chosenClient);
                          }
                        }
                    )
                ),
              )
            ],
          ),
          body: new FutureBuilder<List<Client>>(
              future: DBProvider.db.getAllClients(),
              builder: (BuildContext context, AsyncSnapshot<List<Client>> snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      Client client = snapshot.data[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          DBProvider.db.deleteClient(client.id);
                        },
                        child: Ink(
                            color: visibleState && index == chosenItem ? Colors.blue : Colors.transparent,
                            child: ListTile(
                              onLongPress: (){
                                if(!visibleState) {
                                  setState(() {
                                    chosenClient = client;
                                    chosenItem = index;
                                    visibleState = true;
                                    debugPrint('state: $visibleState');
                                  });
                                }
                              },
                              title: Text(client.lastName),
                              leading:Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(client.id.toString())
                                ],
                              ),
                              trailing: Checkbox(
                                onChanged: (bool value) {
                                  DBProvider.db.blockOrUnblock(client);
                                },
                                value: client.blocked,
                              ),
                            )
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              Client rnd = testClients[math.Random().nextInt(testClients.length)];
              await DBProvider.db.createClient(rnd);
              setState(() {});
            },
          ),
        )
    );
  }
}
