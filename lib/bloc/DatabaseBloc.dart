import 'dart:async';

import 'package:fluttersqlite/data/ClientModel.dart';
import 'package:fluttersqlite/data/Database.dart';

class ClientsBloc {
  final _clientController = StreamController<List<Client>>.broadcast();

  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await DBProvider.db.getAllClients());
  }

  ClientsBloc() {
    getClients();
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
