import 'dart:ffi';
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

void main() {
  runApp(MaterialApp(home: RobotApp()));
}

class RobotApp extends StatefulWidget {
  late BluetoothConnection connection;
  late FlutterBluetoothSerial bluetooth;
  List<BluetoothDevice> _devicesList = [];
  BluetoothDevice? _device;
  bool _connected = false;
  bool _pressed = false;

  @override
  _RobotApp createState() => _RobotApp();
}

class _RobotApp extends State<RobotApp> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    widget.bluetooth = FlutterBluetoothSerial.instance;
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> bluetoothConnectionState(
      FlutterBluetoothSerial obj, List<BluetoothDevice> lista) async {
    try {
      lista = await obj.getBondedDevices();
      print("LISTA DEVICES: ${lista[0].address}");

      BluetoothConnection.toAddress(lista[0].address).then((conn) {
        widget.connection = conn;
        widget.connection.output
            .add(Uint8List.fromList(utf8.encode("b" + "\r\n")));
        widget.connection.output.allSent
            .then((value) => print("Value of AllSent: ${value}"));

        widget.connection.input!.listen(_onDataRecibed);

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                content: Text("Conectado!"),
              );
            });
      });
    } catch (err) {
      print("Error");
    }
  }

  // Enviar mensaje desde input.
  void _inputSend() {
    print("Campo de texto: ${_controller.text.trim()}");
    _sendMessage(_controller.text.trim());
  }

  // CallBack data recibed.
  void _onDataRecibed(Uint8List data) {
    String _decode = String.fromCharCodes(data);
    print("Data recibida: ${_decode}");
  }

  // Function to send sms to device connected.
  void _sendMessage(String sms) async {
    widget.connection.output.add(Uint8List.fromList(utf8.encode(sms + "\r\n")));
    widget.connection.output.allSent
        .then((value) => print("Value of AllSent: ${value}"));
  }

  // Connect HC with funcion async bluetoothConnectionState()
  void _connectHC() {
    bluetoothConnectionState(widget.bluetooth, widget._devicesList);
  }

/*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(TextField(
          controller: _controller,

        child:           
          onSubmitted: (String value) async {
            await showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Thanks!'),
                  content: Text(
                      'You typed "$value", which has length ${value.characters.length}.'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
*/

  Widget build(BuildContext context) {
    // Scaffold es un layout para la mayoría de los Material Components.
    return Scaffold(
      // el body es la mayor parte de la pantalla.
      body: Center(
        child: Container(
            color: Colors.black12,
            height: 140.0,
            width: 140.0,
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(16.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // x
                crossAxisAlignment: CrossAxisAlignment.center, // y
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0)),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1.0))),
                    controller: _controller,
                    cursorColor: Colors.black,
                  ),
                  IconButton(
                    icon: Icon(Icons.send_sharp),
                    tooltip: 'Send message',
                    onPressed: _inputSend,
                  )
                ])),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        tooltip:
            'Connect', // utilizado por las tecnologías de accesibilidad para discapacitados
        child: const Icon(Icons.bluetooth_drive),
        onPressed: _connectHC,
      ),
    );
  }
}
