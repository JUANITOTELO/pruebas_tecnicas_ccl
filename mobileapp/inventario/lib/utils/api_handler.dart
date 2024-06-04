import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:inventario/models/entradas.dart';
import 'package:inventario/models/inventario.dart';
import 'package:inventario/models/productos.dart';
import 'package:http/http.dart' as http;
import 'package:inventario/models/salidas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHandler {
  static const String apiUrl = 'http://192.168.0.9:5000';

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      return token;
    }
    return '';
  }

  setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
  }

  removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<List<Productos>> getProductos() async {
    // Get the list of products from the API
    List<Productos> productos = [];
    String token = await getToken();

    final uri = Uri.parse('$apiUrl/api/productos');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        productos = data.map((e) => Productos.fromJson(e)).toList();
        return productos;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    // Return a list of Productos
    return [];
  }

  Future<String> addProducto(String text, String text2, double parse) async {
    // Add a new product to the API
    final uri = Uri.parse('$apiUrl/api/productos');
    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
        body:
            jsonEncode({'Nombre': text, 'Descripcion': text2, 'Precio': parse}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'OK';
      } else {
        return 'Error';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Error';
    }
  }

  Future<String> deleteProducto(int id) async {
    // Delete a product from the API
    final uri = Uri.parse('$apiUrl/api/productos/$id');
    try {
      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'OK';
      } else {
        return 'Error';
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'Error';
    }
  }

  Future<String> putProducto(
      int id, String text, String text2, double parse) async {
    // Update a product in the API
    final uri = Uri.parse('$apiUrl/api/productos/$id');
    try {
      final response = await http.put(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
        body:
            jsonEncode({'Nombre': text, 'Descripcion': text2, 'Precio': parse}),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'OK';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<List<Inventario>> getInventario() async {
    // Get the list of products from the inventory API
    List<Inventario> inventario = [];
    String token = await getToken();

    final uri = Uri.parse('$apiUrl/api/inventario');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        inventario = data.map((e) => Inventario.fromJson(e)).toList();
        return inventario;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<String> deleteInventario(int id) async {
    // Delete a product from the inventory API
    final uri = Uri.parse('$apiUrl/api/inventario/$id');
    try {
      final response = await http.delete(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await getToken()}',
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return 'OK';
      } else {
        return 'Error';
      }
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> addProductoInventario(int i, int parse) async {
    // Add a product to the inventory API
    final uri = Uri.parse('$apiUrl/api/inventario');
    String token = await getToken();
    final response = await http.post(
      uri,
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'Id_producto': i, 'Cantidad': parse}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'OK';
    } else {
      return 'Error';
    }
  }

  Future<String> updateProductoInventario(int i, int parse) async {
    // Update a product in the inventory API
    final uri = Uri.parse('$apiUrl/api/inventario/cantidad/$i/$parse');
    String token = await getToken();
    final response = await http.put(uri, headers: <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return 'OK';
    } else {
      return 'Error';
    }
  }

  Future<List<IngresoProductos>> getEntradas() async {
    // Get the list of products from the inventory API
    List<IngresoProductos> entradas = [];
    String token = await getToken();

    final uri = Uri.parse('$apiUrl/api/entradas');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        entradas = data.map((e) => IngresoProductos.fromJson(e)).toList();
        return entradas;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }

  Future<List<SalidaProductos>> getSalidas() async {
    // Get the list of products from the inventory API
    List<SalidaProductos> salidas = [];
    String token = await getToken();

    final uri = Uri.parse('$apiUrl/api/salidas');
    try {
      final response = await http.get(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final List<dynamic> data = jsonDecode(response.body);
        salidas = data.map((e) => SalidaProductos.fromJson(e)).toList();
        return salidas;
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return [];
    }
  }
}
