import 'package:flutter/material.dart';

class NewDetalleVenta extends StatefulWidget {
  const NewDetalleVenta({super.key});

  @override
  State<NewDetalleVenta> createState() => _NewDetalleVentaState();
}

class _NewDetalleVentaState extends State<NewDetalleVenta> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalle del producto"),
      ),
      body: Column(
        children: [
          TextField(

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Id de la venta',
            ),
          ),
          TextField(

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Id del producto',
            ),
          ),
          TextField(

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Cantidad',
            ),
          ),
          TextField(

            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Precio',
            ),
          ),
          TextButton(
            onPressed: () {

            },
            style: ButtonStyle(
              foregroundColor:
              MaterialStateProperty.all<Color>(Colors.redAccent),
            ),
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
