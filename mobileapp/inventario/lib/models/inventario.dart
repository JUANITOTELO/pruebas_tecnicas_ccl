class Inventario {
  int id;
  int idProducto;
  int cantidad;
  DateTime lastUpdated = DateTime.now();

  Inventario(this.id, this.idProducto, this.cantidad) {
    lastUpdated = DateTime.now();
  }

  factory Inventario.fromJson(Map<String, dynamic> json) {
    return Inventario(
      json['id'],
      json['id_producto'],
      json['cantidad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_producto': idProducto,
      'cantidad': cantidad,
    };
  }
}
