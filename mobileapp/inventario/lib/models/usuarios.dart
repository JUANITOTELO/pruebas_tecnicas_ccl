class Usuarios {
  final int id;
  final String nombre;
  final String email;
  final String contrasena;

  Usuarios(
      {required this.id,
      required this.nombre,
      required this.email,
      required this.contrasena});

  factory Usuarios.fromJson(Map<String, dynamic> json) {
    return Usuarios(
      id: json['Id'],
      nombre: json['Nombre'],
      email: json['Email'],
      contrasena: json['Contraseña'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Nombre': nombre,
      'Email': email,
      'Contraseña': contrasena,
    };
  }
}
