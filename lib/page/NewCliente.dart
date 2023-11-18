import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:proyecto/Models/Clientes.dart';
import 'package:proyecto/extra/Ambiente.dart';

import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class NewCliente extends StatefulWidget {
  final int idClien;

  const NewCliente({super.key, required this.idClien});

  @override
  State<NewCliente> createState() => _NewClienteState();
}

class _NewClienteState extends State<NewCliente> {

  TextEditingController txtcodigoController = TextEditingController();
  TextEditingController txtNombreController = TextEditingController();
  TextEditingController txtTelefonoController = TextEditingController();
  TextEditingController txtDireccionController = TextEditingController();
  TextEditingController txtLatitudController = TextEditingController();
  TextEditingController txtLongitudController = TextEditingController();



  Future<void> fnGetProd() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/cliente/get'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idClien,

      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> jsonResp = jsonDecode(response.body);
      var objResp = Clientes.fromJson(jsonResp);
      txtcodigoController.text = objResp.codigo;
      txtNombreController.text = objResp.nombre;
      txtTelefonoController.text = objResp.telefono;
      txtDireccionController.text = objResp.direccion;
      txtLongitudController.text = objResp.longitud;
      txtLatitudController.text = objResp.latitud;
    }
  }

  Future<void> fnSave() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/cliente/save'),
      body: jsonEncode(<String, String>{
        'id': widget.idClien.toString(),
        'codigo': txtcodigoController.text,
        'nombre': txtNombreController.text,
        'telefono': txtTelefonoController.text,
        'direccion': txtDireccionController.text,
        'longitud': txtLongitudController.text,
        'latitud': txtLatitudController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var respuesta = response.body;

    if (respuesta == "OK") {
      Navigator.pop(context);

    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Ocurrio un error',
      );
    }
  }

  Future<void> fnDelete() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/cliente/delete'),
      body: jsonEncode(<String, String>{
        'id': widget.idClien.toString(),

      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var respuesta = response.body;

    if (respuesta == "OK") {
      Navigator.pop(context);

    } else {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Ocurrio un error',
      );
    }
  }

  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.idClien != ""){
      fnGetProd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Cliente"),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtcodigoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Codigo',
            ),
          ),
          TextField(
            controller: txtNombreController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Nombre',
            ),
          ),
          TextField(
            controller: txtTelefonoController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Telefono',
            ),
          ),
          TextField(
            controller: txtDireccionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Dirección',
            ),
          ),
          TextField(
            controller: txtLatitudController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Latitud',
            ),
          ),
          TextField(
            controller: txtLongitudController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Longitud',
            ),
          ),
          TextButton(
            onPressed: () {
              fnSave();
            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text("Guardar"),
          ),
          Visibility(
            visible: widget.idClien!=0,
            child: TextButton(
              onPressed: (){
                fnDelete();
              },

              style: ButtonStyle(
                foregroundColor:
                MaterialStateProperty.all<Color>(Colors.redAccent),
              ),
              child: const Text("Eliminar"),
            ),),
          TextButton(
            onPressed: () {

            },
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text("Obtener Ubicación"),
          ),
        ],
      ),
    );
  }
}
