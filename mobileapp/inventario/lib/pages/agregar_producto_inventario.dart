import 'package:flutter/material.dart';
import 'package:inventario/models/productos.dart';
import 'package:inventario/utils/api_handler.dart';

class AddProductoInventarioPage extends StatefulWidget {
  const AddProductoInventarioPage({super.key});

  @override
  State<AddProductoInventarioPage> createState() =>
      _AddProductoInventarioPageState();
}

class _AddProductoInventarioPageState extends State<AddProductoInventarioPage> {
  ApiHandler api = ApiHandler();
  int? _selectedProduct;
  final TextEditingController cantidadController = TextEditingController();
  Future<List<Productos>>? _productos;

  Future<List<Productos>> getProductos() async {
    List<Productos> productos = await api.getProductos();
    return productos;
  }

  void addProductoInventario() async {
    if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Seleccione un producto'),
        ),
      );
      return;
    }
    if (cantidadController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ingrese la cantidad'),
        ),
      );
      return;
    }
    final String response = await api.addProductoInventario(
      _selectedProduct!,
      int.parse(cantidadController.text),
    );
    if (response == 'OK') {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al agregar el producto al inventario'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _productos = getProductos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar producto al inventario'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Select product
            FutureBuilder<List<Productos>>(
              future: _productos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<int>(
                    value: _selectedProduct,
                    items: snapshot.data!
                        .map((Productos producto) => DropdownMenuItem<int>(
                              value: producto.id,
                              child: Text(producto.nombre),
                            ))
                        .toList(),
                    onChanged: (int? value) {
                      setState(() {
                        _selectedProduct = value;
                      });
                    },
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            // Quantity
            TextField(
                controller: cantidadController,
                decoration: const InputDecoration(
                  labelText: 'Cantidad',
                ),
                keyboardType: TextInputType.number),
            ElevatedButton(
              onPressed: addProductoInventario,
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }
}
