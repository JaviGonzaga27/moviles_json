
import 'package:flutter/material.dart';
import 'package:pruebaconjunta2/vista/verdura_vista.dart';
import 'controlador/verdura_controlador.dart'; // Asegúrate de que esta ruta sea correcta

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestión de Verduras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ProductosVista(), // Llamamos a la vista ProductosVista aquí
    );
  }
}
