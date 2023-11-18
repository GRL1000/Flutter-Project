import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyecto/Models/Clientes.dart';
import 'package:proyecto/Models/Productos.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:proyecto/page/Home.dart';
import 'package:proyecto/page/NewCliente.dart';
import 'package:proyecto/page/NewDetalleVenta.dart';
import 'package:proyecto/page/NewProduct.dart';
import 'package:proyecto/page/NewVenta.dart';
import 'package:proyecto/page/ProductoVenta.dart';
import 'package:proyecto/page/Venta.dart';

class Cliente extends StatefulWidget {
  const Cliente({super.key});

  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  List<Clientes> clientes = [];

  Future<void> fnProductos() async {
    var response = await http.get(
      Uri.parse("${Ambiente.urlServer}/api/clientes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
    );
    print(response.body);
    if(response.statusCode == 200){
      Iterable l = jsonDecode(response.body);
      clientes = List<Clientes>.from(l.map((model) => Clientes.fromJson(model)));
    }else{
      print("Ocurrio un error: " + response.statusCode.toString());
    }
    setState(() {

    });

  }
  Widget _listViewProductos(List<Clientes> prods) {
    return ListView.builder(
        itemCount: prods.length,
        itemBuilder: (context, index){
          var prod = prods[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(prod.codigo[0]),
            ),
            title: Text(prod.nombre),
            subtitle: Text("Telefono: ${prod.telefono}"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NewCliente(idClien: prod.id,)));
            },
          );
        }
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fnProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
      ),
      body: RefreshIndicator(
        onRefresh: fnProductos,
        child: _listViewProductos(clientes),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewCliente(idClien: 0,)),
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
                  MaterialPageRoute(builder: (context) => NewCliente(idClien: 0,)),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopify),
              title: Text("Ventas"),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Venta()),
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
