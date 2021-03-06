import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import 'package:band_names/models/band.dart';
import 'package:band_names/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
/*     Band(id: '1', name: 'Metalica', votes: 5),
    Band(id: '2', name: 'Queen', votes: 1),
    Band(id: '3', name: 'Heroes del Silencio', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 5), */
  ];

  //* con esto escuchamos evento del backend, socket server
  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBands);
    super.initState();
  }

  _handleActiveBands(dynamic payload) {
    //print(payload); //! recibo un listado y dentro una coleccion de mapas
    //* lo mapeo y luego ya podriamos teenr los metodos y propiedades
    //* que nosotros necesitamos, porque payload que recibimos es dynamic
    bands = (payload as List).map((band) => Band.fromMap(band)).toList();
    setState(() {});
  }

  //* cuando dejo de escuchar..... limpio todo!..limpieza!
  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands'); //dejo de escuchar el evento
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'BandNames',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            //socketService.socket.connected
            child: (socketService.serverStatus == ServerStatus.Online)
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(Icons.offline_bolt, color: Colors.red),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          //
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
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
  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) {
        //onDismissed: (direction) {
        //print('direction: $direction');
        //print('id: ${band.id}');
        //emitir: delete-band
        // {'id': band.id}
        socketService.emit('delete-band', {'id': band.id});
      },
      background: Container(
        padding: const EdgeInsets.only(left: 8.0),
        color: Colors.red,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Delete Band', style: TextStyle(color: Colors.white)),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          //print(band.name); print(name.id);
          socketService.socket.emit('vote-band', {'id': band.id});
        },
      ),
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
        builder: (_) {
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
      //bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      //setState(() {});

      // * emitir: 'add-band'
      // * {'name':name}....envio un mapa
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.emit('add-band', {'name': name});
    }
    // cerramos el dialogo
    Navigator.pop(context);
  }

  // Mostrar Grafica
  Widget _showGraph() {
    //
    Map<String, double>? dataMap = {
      'hi': 3,
    };
//    Map<String, double> dataMap = Map();
    //dataMap.putIfAbsent('Flutter', () => 5);
    // ! o tb bands.forEach((band){ <=> for (var band in bands) {
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

/*     final List<Color> colorList = [
      Colors.blue[50],
      Colors.blue[200],
      Colors.pink[50],
      Colors.pink[200],
      Colors.yellow[50],
      Colors.yellow[200],
    ]; */

    return Container(
      padding: const EdgeInsets.only(top: 10),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        //colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 32,
        //centerText: "HYBRID",
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          //legendShape: _BoxShape.circle,
          legendTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
        // gradientList: ---To add gradient colors---
        // emptyColorGradient: ---Empty Color gradient---
      ),
    );
  }
}
