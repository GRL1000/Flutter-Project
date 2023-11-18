import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyecto/Models/Productos.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:proyecto/page/Cliente.dart';
import 'package:proyecto/page/NewCliente.dart';
import 'package:proyecto/page/NewDetalleVenta.dart';
import 'package:proyecto/page/NewProduct.dart';
import 'package:proyecto/page/NewVenta.dart';
import 'package:proyecto/page/ProductoVenta.dart';
import 'package:proyecto/page/Venta.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  List<Productos> productos = [];
  
  Future<void> fnProductos() async {
    var response = await http.get(
      Uri.parse("${Ambiente.urlServer}/api/productos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',

      },
    );
    print(response.body);
    if(response.statusCode == 200){
      Iterable l = jsonDecode(response.body);
      productos = List<Productos>.from(l.map((model) => Productos.fromJson(model)));
    }else{
      print("Ocurrio un error: " + response.statusCode.toString());
    }
    setState(() {

    });

  }
  Widget _listViewProductos(List<Productos> prods) {
    return ListView.builder(
        itemCount: prods.length,
        itemBuilder: (context, index){
          var prod = prods[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(prod.codigo[0]),
            ),
            title: Text(prod.descripcion),
            subtitle: Text("Precio: ${prod.precio}"),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => NewProduct(idProd: prod.id,)));
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
        title: Text("Home"),
      ),
      body: RefreshIndicator(
        onRefresh: fnProductos,
        child: _listViewProductos(productos),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewProduct(idProd: 0,)),
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
                  MaterialPageRoute(builder: (context) => Venta()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
