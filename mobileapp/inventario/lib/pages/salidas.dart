import 'package:flutter/material.dart';
import 'package:inventario/models/salidas.dart';
import 'package:inventario/utils/api_handler.dart';

class SalidasPage extends StatefulWidget {
  const SalidasPage({super.key});

  @override
  State<SalidasPage> createState() => _SalidasPageState();
}

class _SalidasPageState extends State<SalidasPage> {
  final ApiHandler api = ApiHandler();
  List<SalidaProductos> salidas = [];

  getSalidasInventario() async {
    List<SalidaProductos> data = await api.getSalidas();
    setState(() {
      salidas = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getSalidasInventario();
  }

  @override
  Widget build(BuildContext context) {
    // Just a table with the data
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: getSalidasInventario,
        child: const Text('Cargar salidas'),
      ),
      body: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Salida')),
            ],
            rows: salidas
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.idProducto.toString())),
                      DataCell(Text(e.cantidad.toString())),
                      DataCell(Text(e.fechaSalida.toString())),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
