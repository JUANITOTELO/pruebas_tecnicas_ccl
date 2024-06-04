import 'package:flutter/material.dart';
import 'package:inventario/models/entradas.dart';
import 'package:inventario/utils/api_handler.dart';

class EntradasPage extends StatefulWidget {
  const EntradasPage({super.key});

  @override
  State<EntradasPage> createState() => _EntradasPageState();
}

class _EntradasPageState extends State<EntradasPage> {
  final ApiHandler api = ApiHandler();
  List<IngresoProductos> entradas = [];

  getEntradasInventario() async {
    List<IngresoProductos> data = await api.getEntradas();
    setState(() {
      entradas = data;
    });
  }

  @override
  void initState() {
    super.initState();
    getEntradasInventario();
  }

  @override
  Widget build(BuildContext context) {
    // Just a table with the data
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: getEntradasInventario,
        child: const Text('Cargar entradas'),
      ),
      body: Column(
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text('Producto')),
              DataColumn(label: Text('Cantidad')),
              DataColumn(label: Text('Ingreso')),
            ],
            rows: entradas
                .map(
                  (e) => DataRow(
                    cells: [
                      DataCell(Text(e.idProducto.toString())),
                      DataCell(Text(e.cantidad.toString())),
                      DataCell(Text(e.fechaIngreso.toString())),
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
