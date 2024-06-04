class SalidaProductos {
  int id;
  int idProducto;
  int cantidad;
  DateTime fechaSalida;
  int idInventario;

  SalidaProductos({
    required this.id,
    required this.idProducto,
    required this.cantidad,
    required this.fechaSalida,
    required this.idInventario,
  });

  factory SalidaProductos.fromJson(Map<String, dynamic> json) {
    return SalidaProductos(
      id: json['id'],
      idProducto: json['id_producto'],
      cantidad: json['cantidad'],
      fechaSalida: DateTime.parse(json['fecha_salida']),
      idInventario: json['id_inventario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'fecha_salida': fechaSalida.toIso8601String(),
      'id_inventario': idInventario,
    };
  }
}
