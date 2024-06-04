import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:inventario/pages/entrada.dart';
import 'package:inventario/pages/inventario.dart';
import 'package:inventario/pages/login.dart';
import 'package:inventario/pages/productos.dart';
import 'package:inventario/pages/salidas.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var appBarTitle = 'Inventario';
  dynamic currentPage = const InventarioPage();

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;
    // Check if the user is authenticated
    // If not, redirect to the login page
    _checkAuthentication();

    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        centerTitle: true,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  const DrawerHeader(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                    ),
                    child: Text(
                      'Menú',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text("Inventario"),
                    onTap: () {
                      setState(() {
                        if (appBarTitle != 'Inventario') {
                          appBarTitle = 'Inventario';
                          currentPage = const InventarioPage();
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text("Entradas"),
                    onTap: () {
                      setState(() {
                        if (appBarTitle != 'Entradas') {
                          appBarTitle = 'Entradas';
                          currentPage = const EntradasPage();
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text("Salidas"),
                    onTap: () {
                      setState(() {
                        if (appBarTitle != 'Salidas') {
                          appBarTitle = 'Salidas';
                          currentPage = const SalidasPage();
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text("Productos"),
                    onTap: () {
                      setState(() {
                        if (appBarTitle != 'Productos') {
                          appBarTitle = 'Productos';
                          currentPage = const ProductosPage();
                        }
                      });
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: Colors.red,
              textColor: Colors.white,
              title: const Text("Cerrar Sesión"),
              onTap: () {
                _logout();
              },
            ),
          ],
        ),
      ),
      drawerEdgeDragWidth: currentWidth / 2,
      body: currentPage,
    );
  }

  _checkAuthentication() async {
    // Check if the user is authenticated
    // If not, redirect to the login page
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  _logout() async {
    // Remove the token from shared preferences
    // Redirect to the login page
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}
