import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyecto/Models/Clientes.dart';
import 'package:proyecto/Models/Productos.dart';
import 'package:proyecto/Models/Venta.dart';
import 'package:proyecto/Models/VentaProducto.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:proyecto/page/Cliente.dart';
import 'package:proyecto/page/Home.dart';
import 'package:proyecto/page/NewCliente.dart';
import 'package:proyecto/page/NewDetalleVenta.dart';
import 'package:proyecto/page/NewProduct.dart';
import 'package:proyecto/page/NewVenta.dart';
import 'package:proyecto/page/ProductoVenta.dart';
import 'package:intl/intl.dart';

class Venta extends StatefulWidget {
  const Venta({super.key});

  @override
  State<Venta> createState() => _VentaState();
}

class _VentaState extends State<Venta> {
  List<VentaProducto> ventas = [];
  DateTime fechaInicioSeleccionada = DateTime.now().subtract(Duration(days: 7)); // Valor por defecto: hace una semana
  DateTime fechaFinSeleccionada = DateTime.now();

  Future<void> fnVentas() async {
    var response = await http.get(
      Uri.parse("${Ambiente.urlServer}/api/detalles"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.body);
    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      ventas = List<VentaProducto>.from(l.map((model) => VentaProducto.fromJson(model)));

      // Filtrar las ventas por fecha
      ventas = ventas.where((venta) =>
      venta.createdAt.isAfter(fechaInicioSeleccionada) &&
          venta.createdAt.isBefore(fechaFinSeleccionada)).toList();
    } else {
      print("Ocurrio un error: " + response.statusCode.toString());
    }
    setState(() {});
  }
  Widget _listViewProductos(List<VentaProducto> prods) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: fechaInicioSeleccionada,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != fechaInicioSeleccionada) {
                  setState(() {
                    fechaInicioSeleccionada = pickedDate;
                  });
                }
              },
              child: Text("Fecha de Inicio: ${DateFormat('dd-MM-yyyy').format(fechaInicioSeleccionada)}"),
            ),
            TextButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: fechaFinSeleccionada,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null && pickedDate != fechaFinSeleccionada) {
                  setState(() {
                    fechaFinSeleccionada = pickedDate;
                  });
                }
              },
              child: Text("Fecha de Fin: ${DateFormat('dd-MM-yyyy').format(fechaFinSeleccionada)}"),
            ),
          ],
        ),
        Expanded(
          child: ListView.builder(
            itemCount: prods.length,
            itemBuilder: (context, index) {
              var prod = prods[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(prod.id.toString()[0]),
                ),
                title: Text("Cliente: "+prod.nombre),
                subtitle: Text("Producto: "+prod.descripcion),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductoVenta(idNueva: prod.id)));
                },
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnVentas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
      ),
      body: RefreshIndicator(
        onRefresh: fnVentas,
        child: _listViewProductos(ventas),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductoVenta(idNueva: 0,)),
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(decoration: BoxDecoration(color: Colors.greenAccent),
                child: Column(
                  children: [
                    Expanded(child: Image.asset('assets/images/login.png'),),
                    Text("Usuario")
                  ],
                )),
            ListTile(
              leading: Icon(Icons.price_change),
              title: Text("Productos"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Clientes"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Cliente()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopify),
              title: Text("Ventas"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductoVenta(idNueva: 0,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shop_sharp),
              title: Text("Detalle de Ventas"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewDetalleVenta()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}