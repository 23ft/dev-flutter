import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() {
  runApp(MaterialApp(home: TutorialHome()));
}

class TutorialHome extends StatefulWidget {
  List<String> names = <String>[];
  List<BluetoothDevice> devicesList = <BluetoothDevice>[];
  String _device_esp = "84:CC:A8:2C:7E:4A";

  @override
  _HubApp createState() => _HubApp();
}

class _HubApp extends State<TutorialHome> {
  void _test() {
    print("Value of devies names is: ${widget.devicesList}");
  }

  @override
  void initState() {
    super.initState();
    FlutterBlue flutterBlue = FlutterBlue.instance;

    widget.names = <String>[];
    widget.devicesList = <BluetoothDevice>[];

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      // do something with scan results
      for (ScanResult r in results) {
        if (!widget.devicesList.contains(r.device)) {
          widget.devicesList.add(r.device);

          if (r.device.id.id == widget._device_esp) {
            // ignore: avoid_print
            print("Yes encontado!: ${r.device.id.id} ");
          }
        }
      }
    });

    // Stop scanning
    flutterBlue.stopScan();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(115, 15, 15, 15),
          leading: IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'MAM - CARS',
            onPressed: _test,
          ),
          title: const Text('MAM - CARS'),
        ),
        // el body es la mayor parte de la pantalla.
        body: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: Colors.black12,
                  height: 130.0,
                  width: 130.0,
                  margin: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // x
                    crossAxisAlignment: CrossAxisAlignment.center, // y
                    children: <Widget>[
                      IconButton(
                        iconSize: 80.0,
                        icon: Icon(Icons.bluetooth_sharp),
                        tooltip: 'hover message',
                        onPressed: _test,
                      ),
                      Text("Devices View")
                    ],
                  ),
                ),
                Container(
                    color: Colors.black12,
                    height: 130.0,
                    width: 130.0,
                    margin: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          iconSize: 80.0,
                          icon: Icon(Icons.cloud_circle_sharp),
                          tooltip: 'hover message',
                          onPressed: _test,
                        ),
                        Text("AMR View")
                      ],
                    ))
              ]),
        ),

        //floatingActionButton: FloatingActionButton(
        //  backgroundColor: Color.fromARGB(115, 10, 10, 10),
        //  tooltip:
        //      'Add', // utilizado por las tecnologías de accesibilidad para discapacitados
        //  child: const Icon(Icons.add),
        //  onPressed: null,
        //),
      );
}
