import 'dart:convert';
import 'package:http/http.dart' as http;
import '../modelo/verdura_modelo.dart';

class ProductoService {
  static const String apiUrl = 'http://127.0.0.1:5000/productos'; // URL del servidor Flask

  // Método para obtener productos del servidor Flask
  Future<List<Producto>> obtenerProductos() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> productosJson = json.decode(response.body);
        return productosJson.map((json) => Producto.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar productos desde el servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // Método para agregar un nuevo producto
  Future<void> agregarProducto(Producto producto) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producto.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al agregar el producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // Método para actualizar un producto
  Future<void> actualizarProducto(int codigo, Producto producto) async {
    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$codigo'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(producto.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar el producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }

  // Método para eliminar un producto
  Future<void> eliminarProducto(int codigo) async {
    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$codigo'),
      );

      if (response.statusCode != 200) {
        throw Exception('Error al eliminar el producto: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error al conectar con el servidor: $e');
    }
  }
}
