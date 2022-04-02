import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket; //expongo al mundo
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://192.168.1.8:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //* otro evento personalizado, recibimos un Mapa
    //* escuchamos un evento desde mi backend o Socket Server!
    //* inconveniente es que: esta en duro que siempre tengo que escuchar
    //* 'nuevo-mensaje'....
/*     socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje:');
      print('nombre:' + payload['nombre']);
      print('mensaje:' + payload['mensaje']);
      //print('mensaje:' + payload['mensaje2']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    }); */
  }
}
