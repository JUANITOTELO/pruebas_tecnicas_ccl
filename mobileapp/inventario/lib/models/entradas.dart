class IngresoProductos {
  int id;
  int idProducto;
  int cantidad;
  DateTime fechaIngreso;
  int idInventario;

  IngresoProductos({
    required this.id,
    required this.idProducto,
    required this.cantidad,
    required this.fechaIngreso,
    required this.idInventario,
  });

  factory IngresoProductos.fromJson(Map<String, dynamic> json) {
    return IngresoProductos(
      id: json['id'],
      idProducto: json['id_producto'],
      cantidad: json['cantidad'],
      fechaIngreso: DateTime.parse(json['fecha_ingreso']),
      idInventario: json['id_inventario'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_producto': idProducto,
      'cantidad': cantidad,
      'fecha_ingreso': fechaIngreso.toIso8601String(),
      'id_inventario': idInventario,
    };
  }
}
