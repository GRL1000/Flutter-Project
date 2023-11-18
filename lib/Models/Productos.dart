class Productos {
  final int id;
  final String codigo;
  final String descripcion;
  final double precio;

  Productos(this.id, this.codigo, this.descripcion, this.precio);

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      json['id'],
      json['codigo'],
      json['descripcion'],
      double.parse(json['precio']),
    );
  }
}
