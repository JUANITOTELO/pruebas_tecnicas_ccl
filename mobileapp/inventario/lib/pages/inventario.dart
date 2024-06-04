import 'package:flutter/material.dart';
import 'package:inventario/models/inventario.dart';
import 'package:inventario/models/productos.dart';
import 'package:inventario/pages/actualizar_producto_inventario.dart';
import 'package:inventario/pages/agregar_producto_inventario.dart';
import 'package:inventario/utils/api_handler.dart';

class InventarioPage extends StatefulWidget {
  const InventarioPage({super.key});

  @override
  State<InventarioPage> createState() => _InventarioPageState();
}

class _InventarioPageState extends State<InventarioPage> {
  ApiHandler api = ApiHandler();
  late List<Inventario> inventario = [];
  late List<Productos> productos = [];
  late List<Productos> productosInventario = [];
  late Map<Inventario, Productos> inventarioProductos = {};

  Future<List<Inventario>> getInventario() async {
    List<Inventario> inventario = await api.getInventario();
    return inventario;
  }

  Future<List<Productos>> getProductos() async {
    List<Productos> productos = await api.getProductos();
    return productos;
  }

  getProductosInventario() async {
    List<Productos> tmpProductos = await getProductos();
    List<Inventario> tmpInventario = await getInventario();
    List<Productos> tmpProductosInventario = [];
    Map<Inventario, Productos> tmpInventarioProductos = {};
    for (Inventario inventario in tmpInventario) {
      for (Productos producto in tmpProductos) {
        if (inventario.idProducto == producto.id) {
          tmpProductosInventario.add(producto);
          tmpInventarioProductos[inventario] = producto;
        }
      }
    }
    setState(() {
      inventario = tmpInventario;
      productosInventario = tmpProductosInventario;
      inventarioProductos = tmpInventarioProductos;
    });
  }

  @override
  void initState() {
    super.initState();
    getProductosInventario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ListView.builder(
                shrinkWrap: true,
                itemCount: inventario.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                      isThreeLine: true,
                      title:
                          Text(inventarioProductos[inventario[index]]!.nombre),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(inventarioProductos[inventario[index]]!
                              .descripcion),
                          Text(
                            'Cantidad: ${inventario[index].cantidad.toString()}',
                          ),
                          Text(
                            'Precio Unitario: ${inventarioProductos[inventario[index]]!.precio.toString()}',
                          ),
                          Text(
                            'Precio Total: ${(inventario[index].cantidad * inventarioProductos[inventario[index]]!.precio).toString()}',
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
                                          ActualizarProductoInventarioPage(
                                              inventario:
                                                  inventario[index]))).then(
                                (value) {
                                  getProductosInventario();
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await api.deleteInventario(
                                  inventario[index].idProducto);
                              getProductosInventario();
                            },
                          )
                        ],
                      ));
                })
          ],
        )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const AddProductoInventarioPage())).then(
              (value) {
                getProductosInventario();
              },
            );
          },
          child: const Icon(Icons.add),
        ));
  }
}
