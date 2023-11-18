import 'package:proyecto/Models/Clientes.dart';
import 'package:proyecto/Models/Productos.dart';

class VentaProducto {
  final int id;
  final int idClien;
  final int idProd;
  final String nombre;
  final String descripcion;
  final String cantidad;
  final String precio;
  final DateTime createdAt;
  final DateTime updatedAt;

  VentaProducto({
    required this.id,
    required this.idClien,
    required this.idProd,
    required this.nombre,
    required this.descripcion,
    required this.cantidad,
    required this.precio,
    required this.createdAt,
    required this.updatedAt,
  });

  factory VentaProducto.fromJson(Map<String, dynamic> json) {
    return VentaProducto(
      id: json['id'],
      idClien: json['idClien'],
      idProd: json['idProd'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      cantidad: json['cantidad'],
      precio: json['precio'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}


