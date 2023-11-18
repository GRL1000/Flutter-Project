import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proyecto/Models/Clientes.dart';
import 'package:proyecto/Models/Productos.dart';
import 'package:proyecto/Models/VentaProducto.dart';
import 'package:proyecto/extra/Ambiente.dart';
import 'package:proyecto/page/Cliente.dart';
import 'package:proyecto/page/Home.dart';
import 'package:proyecto/page/NewCliente.dart';
import 'package:proyecto/page/NewDetalleVenta.dart';
import 'package:proyecto/page/NewProduct.dart';
import 'package:proyecto/page/NewVenta.dart';
import 'package:proyecto/page/Venta.dart';
import 'package:quickalert/quickalert.dart';

class ProductoVenta extends StatefulWidget {
  final int idNueva;
  const ProductoVenta({super.key, required this.idNueva});

  @override
  State<ProductoVenta> createState() => _ProductoVentaState();
}

class _ProductoVentaState extends State<ProductoVenta> {
  Clientes? clienteSeleccionado;
  Productos? productoSeleccionado;
  var idclien = 0;
  var idprod = 0;


  TextEditingController txtNombre = TextEditingController();
  TextEditingController txtProd = TextEditingController();
  TextEditingController txtCantidadController = TextEditingController();
  TextEditingController txtPrecioController = TextEditingController();
  TextEditingController IdClienteController = TextEditingController();

  bool compraGuardada = false;

  Future<void> fnGetProd() async {
    var response = await http.post(
      Uri.parse('${Ambiente.urlServer}/api/detalle/get'),
      body: jsonEncode(<String, dynamic>{
        'id': widget.idNueva,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResp = jsonDecode(response.body);
      var objResp = VentaProducto.fromJson(jsonResp);
      idclien = objResp.idClien;
      idprod = objResp.idProd;
      txtNombre.text = objResp.nombre;
      txtProd.text = objResp.descripcion;
      txtCantidadController.text = objResp.cantidad;
      txtPrecioController.text = objResp.precio;

      await fnClientes();
      await fnSeleccionarCliente();
      await fnProductos();
      await fnSeleccionarProducto();
    }
  }


  List<Clientes> clientes = [];

  Future<void> fnClientes() async {
    var response = await http.get(
      Uri.parse("${Ambiente.urlServer}/api/clientes"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      clientes = List<Clientes>.from(l.map((model) => Clientes.fromJson(model)));
    } else {
      print("Ocurrio un error: " + response.statusCode.toString());
    }

    // Llamar a la función fnSeleccionarCliente aquí
    await fnSeleccionarCliente();
    return Future.value(); // Asegurar que se retorne un Future<void>
  }


  Future<void> fnSeleccionarCliente() async {
    print("ID del cliente a buscar: $idclien");
    print("Lista de clientes: $clientes");

    if (widget.idNueva != 0 && idclien != 0 && idprod != 0) {
      // Buscar el cliente por ID
      clienteSeleccionado = clientes.firstWhere(
            (cliente) => cliente.id == idclien,
        orElse: () => Clientes(0, '', '', '', '', '', ''),
      );

      print("Cliente seleccionado: $clienteSeleccionado");

      setState(() {});
    } else {
      // Si idNueva es nulo, establecer clienteSeleccionado en null
      clienteSeleccionado = null;
      setState(() {});
    }

    return Future.value();
  }



  Widget _listViewClientes(List<Clientes> prods) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: prods.length,
        itemBuilder: (context, index) {
          var prod = prods[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(prod.codigo[0]),
            ),
            title: Text(prod.nombre),
            subtitle: Text("Telefono: ${prod.telefono}"),
            onTap: () {
              setState(() {
                clienteSeleccionado = prod;
              });
            },
          );
        },
      ),
    );
  }
  Widget _buildClienteTab() {
    return Column(
      children: [
        Visibility(
          visible: clienteSeleccionado == null,
          child: Expanded(
            child: ListView(
              children: [
                RefreshIndicator(
                  onRefresh: fnClientes,
                  child: _listViewClientes(clientes),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: clienteSeleccionado != null,
          child: Expanded(
            child: _buildClienteInfo(),
          ),
        ),
      ],
    );
  }



  Widget _buildClienteInfo() {
    if (clienteSeleccionado != null) {
      // Si ya se ha seleccionado un cliente, muestra la información
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Información del Cliente",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Nombre: ${clienteSeleccionado!.nombre}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Teléfono: ${clienteSeleccionado!.telefono}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Dirección: ${clienteSeleccionado!.direccion}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (idclien != null) {
      Clientes cliente = clientes.firstWhere(
            (cliente) => cliente.id == idclien,
        orElse: () => Clientes(0, '', '', '', '', '', ''),
      );

      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.person,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Información del Cliente",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Nombre: ${cliente.nombre}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Teléfono: ${cliente.telefono}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Dirección: ${cliente.direccion}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }


  List<Productos> productos = [];

  Future<void> fnProductos() async {
    var response = await http.get(
      Uri.parse("${Ambiente.urlServer}/api/productos"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable l = jsonDecode(response.body);
      productos = List<Productos>.from(l.map((model) => Productos.fromJson(model)));
    } else {
      print("Ocurrio un error: " + response.statusCode.toString());
    }

    await fnSeleccionarProducto();
    return Future.value();
  }

  Future<void> fnSeleccionarProducto() async {
    print("ID del producto a buscar: $idprod");
    print("Lista de clientes: $productos");

    if (widget.idNueva != 0 && idprod != 0 && idclien != 0) {
      productoSeleccionado = productos.firstWhere(
            (producto) => producto.id == idprod,
        orElse: () => Productos(0, '', '', 0),
      );

      print("producto seleccionado: $productoSeleccionado");

      setState(() {});
    } else {
      // Si idNueva es nulo, establecer clienteSeleccionado en null
      productoSeleccionado = null;
      setState(() {});
    }

    return Future.value();
  }

  Widget _listViewProductos(List<Productos> prods) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: prods.length,
        itemBuilder: (context, index) {
          var Prd = prods[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(Prd.codigo[0]),
            ),
            title: Text(Prd.descripcion),
            subtitle: Text("Telefono: ${Prd.precio}"),
            onTap: () {
              setState(() {
                productoSeleccionado = Prd;
              });
            },
          );
        },
      ),
    );
  }

  Widget _buildProductoTab() {
    return Column(
      children: [
        Visibility(
          visible: productoSeleccionado == null,
          child: Container(
            height: 200,
            child: ListView(
              children: [
                RefreshIndicator(
                  onRefresh: fnProductos,
                  child: _listViewProductos(productos),
                ),
              ],
            ),
          ),
        ),
        Visibility(
          visible: productoSeleccionado != null,
          child: _buildProductoInfo(),
        ),
      ],
    );
  }


  Widget _buildProductoInfo() {
    if (productoSeleccionado != null) {
      return Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(
                  Icons.shopping_cart,
                  size: 64,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Información del Producto",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Descripción: ${productoSeleccionado!.descripcion}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              Text(
                "Código: ${productoSeleccionado!.codigo}",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: compraGuardada,
                child: Column(
                  children: [
                    Text(
                      "Cantidad: ${txtCantidadController.text}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "Precio: \$${txtPrecioController.text}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () {
                            _eliminarCompra();
                          },
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Eliminar Compra",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Visibility(
                visible: !compraGuardada,
                child: Column(
                  children: [
                    TextField(
                      controller: txtCantidadController,
                      decoration: InputDecoration(
                        labelText: 'Cantidad (PZA)',
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !compraGuardada,
                    ),
                    TextField(
                      controller: txtPrecioController,
                      decoration: InputDecoration(
                        labelText: 'Precio',
                      ),
                      keyboardType: TextInputType.number,
                      enabled: !compraGuardada,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        fnSave();
                        setState(() {
                          compraGuardada = true;
                        });
                      },
                      child: Text('Guardar Compra'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _eliminarCompra() async {
    // Agrega aquí la lógica para eliminar la compra
    // Puedes usar el widget Dialog para confirmar la eliminación, por ejemplo
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Eliminar Compra"),
          content: Text("¿Estás seguro de que deseas eliminar esta compra?"),
          actions: [
            TextButton(
              onPressed: () async {
                await fnDelete();
                // Después de eliminar la compra, reinicia el estado y carga las listas nuevamente
                fnReset();
                Navigator.of(context).pop();
              },
              child: Text("Sí"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("No"),
            ),
          ],
        );
      },
    );
  }


  Future<void> fnReset() async {
    setState(() {
      clienteSeleccionado = null;
      productoSeleccionado = null;
      compraGuardada = false;
    });

    await fnClientes();
    await fnProductos();
  }



  Future<void> fnSave() async {
    txtNombre.text = clienteSeleccionado!.nombre;
    idclien = clienteSeleccionado!.id;
    idprod = productoSeleccionado!.id;
    print(txtNombre);
    txtProd.text = productoSeleccionado!.descripcion;
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/detalle/save'),
      body: jsonEncode(<String, String>{
        'id': widget.idNueva.toString(),
        'idClien': idclien.toString(),
        'idProd': idprod.toString(),
        'nombre':txtNombre.text,
        'descripcion': txtProd.text,
        'cantidad': txtCantidadController.text,
        'precio': txtPrecioController.text,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    var respuesta = response.body;

    if (respuesta == "OK") {
      setState(() {
        compraGuardada = true;
      });

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
    var response = await http.post(Uri.parse('${Ambiente.urlServer}/api/detalle/delete'),
      body: jsonEncode(<String, String>{
        'id': widget.idNueva.toString(),

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
    if(widget.idNueva != ""){
      fnGetProd();
      fnSeleccionarCliente();
      fnSeleccionarProducto();
    }
    fnClientes();
    fnProductos();

  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Nuevo Pedido"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.person),
                text: "Cliente",
              ),
              Tab(
                icon: Icon(Icons.shop),
                text: "Producto",
              ),
              Tab(
                icon: Icon(Icons.add_business_rounded),
                text: "Resumen",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildClienteTab(),
            ListView(
              children: [
                _buildProductoTab(),
                // Agrega más elementos según tus necesidades
              ],
            ),
            ListView(
              children: [
                ListTile(
                  title: Text("Resumen 1"),
                ),
                ListTile(
                  title: Text("Resumen 2"),
                ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewCliente(idClien: 0)),
            );
          },
        ),

      ),
    );
  }
}

