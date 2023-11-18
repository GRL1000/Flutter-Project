import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Models/Productos.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class NewProduct extends StatefulWidget {
  final int idProd;

  const NewProduct({super.key, required this.idProd});

  @override
  State<NewProduct> createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {

  TextEditingController txtcodigoController = TextEditingController();
  TextEditingController txtDescripcionController = TextEditingController();
  TextEditingController txtPrecioController = TextEditingController();


  Future<void> fnGuardarPro() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/producto/save'),
      body: jsonEncode(<String, String>{
        'codigo': txtcodigoController.text,
        'descripcion': txtDescripcionController.text,
        'precio': txtPrecioController.text,
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

  Future<void> fnGetProd() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/producto/get'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idProd,

      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> jsonResp = jsonDecode(response.body);
      var objResp = Productos.fromJson(jsonResp);
      txtcodigoController.text = objResp.codigo;
      txtDescripcionController.text = objResp.descripcion;
      txtPrecioController.text = objResp.precio.toString();
    }
  }

  Future<void> fnSave() async {
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/producto/save'),
      body: jsonEncode(<String, String>{
        'id': widget.idProd.toString(),
        'codigo': txtcodigoController.text,
        'descripcion': txtDescripcionController.text,
        'precio': txtPrecioController.text,
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
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/producto/delete'),
      body: jsonEncode(<String, String>{
        'id': widget.idProd.toString(),

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
    if(widget.idProd != ""){
      fnGetProd();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nuevo Producto"),
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
            controller: txtDescripcionController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Descripcion',
            ),
          ),
          TextField(
            controller: txtPrecioController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Precio',
            ),
          ),
          TextButton(
            onPressed: () {
                fnSave();
            },
            style: ButtonStyle(
              foregroundColor:
              MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text("Guardar"),
          ),
          Visibility(
            visible: widget.idProd!=0,
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
        ],
      ),
    );
  }
}
