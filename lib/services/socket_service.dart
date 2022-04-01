import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

  get serverStatus => _serverStatus;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    IO.Socket socket = IO.io('http://192.168.1.8:3000', {
      'transports': ['websocket'],
      'autoConnect': true,
    });

    socket.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    //* otro evento personalizado, recibimos un Mapa
    socket.on('nuevo-mensaje', (payload) {
      print('nuevo-mensaje:');
      print('nombre:' + payload['nombre']);
      print('mensaje:' + payload['mensaje']);
      //print('mensaje:' + payload['mensaje2']);
      print(payload.containsKey('mensaje2') ? payload['mensaje2'] : 'no hay');
    });
  }
}





/* 
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  //creo la propiedad
  final ServerStatus _serverStatus = ServerStatus.connecting;

  SocketService() {
    //no quiero cargar mucho el constructor, so
    //me creo un metodo privado, no regresa nada y se llama _initConfig
    _initConfig();
  }
  void _initConfig() {
    // Dart client
    IO.Socket socket = IO.io(
      'http://192.168.1.8:3000',
      {
        'transports': ['websocket'],
        'autoConnect': true,
      },
    );
    socket.onConnect((_) {
      print('connect');
      //socket.emit('msg', 'test');
    });
    //socket.on('event', (data) => print(data));
    socket.onDisconnect((_) => print('disconnect'));
    //socket.on('fromServer', (_) => print(_));
  }
}
 */