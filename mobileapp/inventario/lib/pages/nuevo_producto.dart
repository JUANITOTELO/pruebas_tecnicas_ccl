// Page that creates a new product
import 'package:flutter/material.dart';
import 'package:inventario/utils/api_handler.dart';

class NuevoProducto extends StatefulWidget {
  const NuevoProducto({super.key});

  @override
  State<NuevoProducto> createState() => _NuevoProductoState();
}

class _NuevoProductoState extends State<NuevoProducto> {
  final ApiHandler api = ApiHandler();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  void addProducto() async {
    final String response = await api.addProducto(
      nombreController.text,
      descripcionController.text,
      double.parse(precioController.text),
    );
    if (response == 'OK') {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el producto'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nuevo Producto'),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            TextField(
              controller: precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: addProducto,
              child: const Text('Agregar Producto'),
            )
          ],
        ),
      ),
    );
  }
}
