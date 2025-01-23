import 'package:flutter/material.dart';
import '../controlador/verdura_controlador.dart';
import '../modelo/verdura_modelo.dart';

class ProductosVista extends StatefulWidget {
  @override
  _ProductosVistaState createState() => _ProductosVistaState();
}

class _ProductosVistaState extends State<ProductosVista> {
  late Future<List<Producto>> productos;

  @override
  void initState() {
    super.initState();
    productos = ProductoService().obtenerProductos(); // Cargar productos al iniciar
  }

  // Método para actualizar la UI
  void actualizarProductos() {
    setState(() {
      productos = ProductoService().obtenerProductos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos'),
      ),
      body: FutureBuilder<List<Producto>>(
        future: productos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay productos'));
          } else {
            final productos = snapshot.data!;
            return ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final producto = productos[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10),
                    title: Text(producto.descripcion),
                    subtitle: Text('Precio: \$${producto.precio}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editarProducto(producto); // Abrir formulario de edición
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _eliminarProducto(producto.codigo); // Eliminar producto
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProducto, // Función para agregar un producto
        child: Icon(Icons.add),
      ),
    );
  }

  // Función para editar un producto
  void _editarProducto(Producto producto) {
    final descripcionController = TextEditingController(text: producto.descripcion);
    final precioController = TextEditingController(text: producto.precio.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Producto'),
          content: Column(
            children: [
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final updatedProducto = Producto(
                  codigo: producto.codigo,
                  descripcion: descripcionController.text,
                  precio: double.parse(precioController.text),
                );
                await ProductoService().actualizarProducto(producto.codigo, updatedProducto);
                actualizarProductos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto actualizado correctamente')));
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Función para agregar un nuevo producto
  void _agregarProducto() {
    final descripcionController = TextEditingController();
    final precioController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Agregar Producto'),
          content: Column(
            children: [
              TextField(
                controller: descripcionController,
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: precioController,
                decoration: InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final newProducto = Producto(
                  codigo: 0,  // Manejar un ID incremental o automático
                  descripcion: descripcionController.text,
                  precio: double.parse(precioController.text),
                );
                await ProductoService().agregarProducto(newProducto);
                actualizarProductos();
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto agregado correctamente')));
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  // Función para eliminar un producto
  void _eliminarProducto(int codigo) async {
    await ProductoService().eliminarProducto(codigo);
    actualizarProductos();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto eliminado correctamente')));
  }
}
