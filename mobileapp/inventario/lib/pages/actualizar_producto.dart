import 'package:flutter/material.dart';
import 'package:inventario/models/productos.dart';
import 'package:inventario/utils/api_handler.dart';

class ActualizarProducto extends StatelessWidget {
  final Productos producto;
  final ApiHandler api = ApiHandler();
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  final TextEditingController precioController = TextEditingController();

  ActualizarProducto({super.key, required this.producto});

  @override
  Widget build(BuildContext context) {
    // populate the text fields with the product data
    nombreController.text = producto.nombre;
    descripcionController.text = producto.descripcion;
    precioController.text = producto.precio.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar Producto'),
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
              onPressed: () async {
                final String response = await api.putProducto(
                  producto.id,
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
              },
              child: const Text('Actualizar Producto'),
            )
          ],
        ),
      ),
    );
  }
}
