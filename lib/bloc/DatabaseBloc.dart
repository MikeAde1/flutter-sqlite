import 'dart:async';

import 'package:fluttersqlite/data/ClientModel.dart';
import 'package:fluttersqlite/data/Database.dart';


  /*getClients()
  will get the data from the Database (Client table)
  asynchronously. We will call this method whenever we update
  the table hence the reason for placing it into the
  constructor’s body*/

  /*We StreamController<T>.broadcast constructor
  so that we are able to listen to the stream more than once.
  Don't forget to close your stream. '
  This prevents us from getting memory leaks.
  we will close it using the dispose method of our StatefulWidget.*/

class ClientsBloc {
  ClientsBloc() {
    getClients();
  }
  //initialize stream controller for client list broadcast
  final _clientController = StreamController<List<Client>>.broadcast();

  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await DBProvider.db.getAllClients());
  }

  blockUnblock(Client client) {
    DBProvider.db.blockOrUnblock(client);
    getClients();
  }

  delete(int id) {
    DBProvider.db.deleteClient(id);
    getClients();
  }

  add(Client client) {
    DBProvider.db.createClient(client);
    getClients();
  }
}
