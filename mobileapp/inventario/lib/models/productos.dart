class Productos {
  int id;
  String nombre;
  String descripcion;
  double precio;

  Productos(this.id, this.nombre, this.descripcion, this.precio);

  factory Productos.fromJson(Map<String, dynamic> json) {
    return Productos(
      json['id'],
      json['nombre'],
      json['descripcion'],
      json['precio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
