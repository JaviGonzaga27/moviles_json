class Producto {
  final int codigo;
  final String descripcion;
  final double precio;

  Producto({
    required this.codigo,
    required this.descripcion,
    required this.precio,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codigo: json['codigo'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo': codigo,
      'descripcion': descripcion,
      'precio': precio,
    };
  }
}
