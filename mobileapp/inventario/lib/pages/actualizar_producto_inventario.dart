import 'package:flutter/material.dart';
import 'package:inventario/models/inventario.dart';
import 'package:inventario/utils/api_handler.dart';

class ActualizarProductoInventarioPage extends StatelessWidget {
  final Inventario inventario;
  final TextEditingController cantidadController = TextEditingController();
  final ApiHandler api = ApiHandler();

  ActualizarProductoInventarioPage({super.key, required this.inventario});

  @override
  Widget build(BuildContext context) {
    cantidadController.text = inventario.cantidad.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Actualizar producto en inventario'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Id de producto: ${inventario.idProducto}'),
            TextField(
              controller: cantidadController,
              decoration: const InputDecoration(labelText: 'Cantidad'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: () async {
                final String response = await api.updateProductoInventario(
                  inventario.idProducto,
                  int.parse(cantidadController.text),
                );
                if (response == 'OK') {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                          'Error al actualizar el producto en el inventario'),
                    ),
                  );
                }
              },
              child: const Text('Actualizar producto en inventario'),
            )
          ],
        ),
      ),
    );
  }
}
