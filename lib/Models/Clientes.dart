class Clientes {
  final int id;
  final String codigo;
  final String nombre;
  final String telefono;
  final String direccion;
  final String longitud;
  final String latitud;

  Clientes(this.id, this.codigo, this.nombre, this.telefono, this.direccion, this.longitud, this.latitud);

  factory Clientes.fromJson(Map<String, dynamic> json) {
    return Clientes(
        json['id'],
        json['codigo'],
        json['nombre'],
        json['telefono'],
        json['direccion'],
        json['longitud'],
        json['latitud']
    );
  }
}
