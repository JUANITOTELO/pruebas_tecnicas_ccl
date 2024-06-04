// main
import 'package:flutter/material.dart';
import 'package:inventario/pages/home.dart';
import 'package:inventario/pages/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final Future<bool> _authenticated = _checkAuthentication();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inventario',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: FutureBuilder<bool>(
        future: _authenticated,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data == true) {
              return const HomePage();
            } else {
              return const LoginPage();
            }
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }

  static Future<bool> _checkAuthentication() async {
    // Check if the user is authenticated
    // If not, redirect to the login page
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      return false;
    }
    return true;
  }
}
// Path: lib/pages/login.dart
