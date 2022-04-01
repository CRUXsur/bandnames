import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;

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
      print('connect');
    });

    socket.on('disconnect', (_) => print('disconnect'));
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