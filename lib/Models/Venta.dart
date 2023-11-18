class Ventas {
  final int id;
  final int num_ventas;
  final String fecha;


  Ventas(this.id, this.num_ventas, this.fecha);

  factory Ventas.fromJson(Map<String, dynamic> json) {
    return Ventas(
        json['id'],
        json['num_ventas'],
        json['fecha']
    );
  }
}