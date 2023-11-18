import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto/Models/Venta.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:table_calendar/table_calendar.dart';

class NewVenta extends StatefulWidget {
  final int idVenta;

  const NewVenta({super.key, required this.idVenta});

  @override
  State<NewVenta> createState() => _NewVentaState();
}

class _NewVentaState extends State<NewVenta> {

  TextEditingController txtnumV = TextEditingController();
  TextEditingController txtfecha = TextEditingController();
  DateTime _selectedDay = DateTime.now();

  Future<void> fnGuardarPro() async {
    txtfecha.text = _selectedDay.toLocal().toString();
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/venta/save'),
      body: jsonEncode(<String, String>{
        'num_ventas': txtnumV.text,
        'fecha': txtfecha.text,
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
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/venta/get'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idVenta,

      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if(response.statusCode == 200){
      Map<String, dynamic> jsonResp = jsonDecode(response.body);
      txtfecha.text = _selectedDay.toLocal().toString();
      var objResp = Ventas.fromJson(jsonResp);
      txtnumV.text = objResp.num_ventas.toString();
    }
  }

  Future<void> fnSave() async {
    txtfecha.text = _selectedDay.toLocal().toString();
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/venta/save'),
      body: jsonEncode(<String, String>{
        'id': widget.idVenta.toString(),
        'num_ventas': txtnumV.text,
        'fecha': txtfecha.text,
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
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/venta/delete'),
      body: jsonEncode(<String, String>{
        'id': widget.idVenta.toString(),

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
    if(widget.idVenta != ""){
      fnGetProd();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nueva Venta"),
      ),
      body: Column(
        children: [
          TextField(
            controller: txtnumV,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Numero de venta',
            ),
          ),
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2050),
            focusedDay: DateTime.now(),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
              // Esta función se llama cuando se selecciona una fecha
              print('Fecha seleccionada: $selectedDay');
              // Aquí puedes manejar la fecha seleccionada según tus necesidades.
            },
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
            visible: widget.idVenta!=0,
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
