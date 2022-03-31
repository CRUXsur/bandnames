import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          elevation: 1,
          onPressed: addNewBand //* mando la referencia del metodo
          ),
    );
  }

  //! recibo una banda band de tipo Band!
  //! ya no recibo un int index!!
  ListTile _bandTile(Band band) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(band.name.substring(0, 2)),
        backgroundColor: Colors.blue[100],
      ),
      title: Text(band.name),
      trailing: Text(
        '${band.votes}',
        style: const TextStyle(fontSize: 20),
      ),
      onTap: () {},
    );
  }

  //* Metodo
  addNewBand() {
    //para obtener el texto que ingresa el usuario
    final textController = TextEditingController();

    if (!Platform.isAndroid) {
      // Android
      return showDialog(
        context: context,
        //construye el mensaje que va a aparecer
        builder: (context) {
          return AlertDialog(
            title: const Text('New band name:'),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                  child: const Text('Add'),
                  elevation: 5,
                  textColor: Colors.blue,
                  onPressed: () => addBandToList(textController.text))
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: const Text('New band name:'),
          content: CupertinoTextField(
            controller: textController,
          ),
          actions: <Widget>[
            CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Add'),
                onPressed: () => addBandToList(textController.text)),
            CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text('Dismiss'),
                onPressed: () => Navigator.pop(context))
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    //print(name);

    if (name.length > 1) {
      // Podemos agregar
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    // cerramos el dialogo
    Navigator.pop(context);
  }
}
