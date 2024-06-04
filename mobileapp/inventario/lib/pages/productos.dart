import 'package:flutter/material.dart';
import 'package:inventario/models/productos.dart';
import 'package:inventario/pages/actualizar_producto.dart';
import 'package:inventario/pages/nuevo_producto.dart';
import 'package:inventario/utils/api_handler.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  ApiHandler api = ApiHandler();
  late List<Productos> productos = [];

  void getProductos() async {
    List<Productos> productos = await api.getProductos();
    setState(() {
      this.productos = productos;
    });
  }

  @override
  void initState() {
    getProductos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: productos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        isThreeLine: true,
                        title: Text(productos[index].nombre),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(productos[index].descripcion),
                            Text(
                              'Precio: ${productos[index].precio.toString()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ActualizarProducto(
                                              producto: productos[index],
                                            ))).then(
                                  (value) {
                                    getProductos();
                                  },
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await api.deleteProducto(productos[index].id);
                                getProductos();
                              },
                            ),
                          ],
                        ));
                  })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NuevoProducto())).then(
              (value) {
                getProductos();
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
