import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:band_names/services/socket_service.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    //*
    //socketService.socket.emit(event)

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('ServerStatus: ${socketService.serverStatus}'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.message),
        onPressed: () {
          // TAREA
          // emitir:
          // { nombre: 'Flutter', mensaje: 'Hola desde Flutter'}
          socketService.socket.emit(
            'emitir-mensaje',
            {'nombre': 'Flutter', 'mensaje': 'Hola desde Flutter'},
          );
        },
      ),
    );
  }
}
