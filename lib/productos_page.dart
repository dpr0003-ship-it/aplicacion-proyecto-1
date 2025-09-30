import 'package:flutter/material.dart';

class Producto {
  String nombre;
  String descripcion;
  String categoria;
  int cantidad;
  double precio;

  Producto({
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.cantidad,
    required this.precio,
  });
}

class ProductosPage extends StatefulWidget {
  const ProductosPage({Key? key}) : super(key: key);

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  final List<Producto> _productos = [];

  void _agregarProducto() async {
    final producto = await showDialog<Producto>(
      context: context,
      builder: (context) => ProductoDialog(),
    );
    if (producto != null) {
      setState(() {
        _productos.add(producto);
      });
    }
  }

  void _editarProducto(int index) async {
    final producto = await showDialog<Producto>(
      context: context,
      builder: (context) => ProductoDialog(producto: _productos[index]),
    );
    if (producto != null) {
      setState(() {
        _productos[index] = producto;
      });
    }
  }

  void _eliminarProducto(int index) {
    setState(() {
      _productos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestión de Productos')),
      body: ListView.builder(
        itemCount: _productos.length,
        itemBuilder: (context, index) {
          final p = _productos[index];
          return ListTile(
            title: Text(p.nombre),
            subtitle: Text(
              'Categoría: ${p.categoria}\nStock: ${p.cantidad} | Precio: S/ ${p.precio.toStringAsFixed(2)}',
            ),
            isThreeLine: true,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editarProducto(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _eliminarProducto(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProducto,
        child: const Icon(Icons.add),
        tooltip: 'Agregar producto',
      ),
    );
  }
}

class ProductoDialog extends StatefulWidget {
  final Producto? producto;
  const ProductoDialog({this.producto, Key? key}) : super(key: key);

  @override
  State<ProductoDialog> createState() => _ProductoDialogState();
}

class _ProductoDialogState extends State<ProductoDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _nombre;
  late String _descripcion;
  late String _categoria;
  late int _cantidad;
  late double _precio;

  @override
  void initState() {
    super.initState();
    _nombre = widget.producto?.nombre ?? '';
    _descripcion = widget.producto?.descripcion ?? '';
    _categoria = widget.producto?.categoria ?? '';
    _cantidad = widget.producto?.cantidad ?? 0;
    _precio = widget.producto?.precio ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.producto == null ? 'Agregar Producto' : 'Editar Producto',
      ),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese nombre' : null,
                onSaved: (v) => _nombre = v!,
              ),
              TextFormField(
                initialValue: _descripcion,
                decoration: const InputDecoration(labelText: 'Descripción'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese descripción' : null,
                onSaved: (v) => _descripcion = v!,
              ),
              TextFormField(
                initialValue: _categoria,
                decoration: const InputDecoration(labelText: 'Categoría'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Ingrese categoría' : null,
                onSaved: (v) => _categoria = v!,
              ),
              TextFormField(
                initialValue: _cantidad.toString(),
                decoration: const InputDecoration(
                  labelText: 'Cantidad en stock',
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese cantidad';
                  final n = int.tryParse(v);
                  if (n == null || n < 0) return 'Cantidad inválida';
                  return null;
                },
                onSaved: (v) => _cantidad = int.parse(v!),
              ),
              TextFormField(
                initialValue: _precio.toString(),
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingrese precio';
                  final n = double.tryParse(v);
                  if (n == null || n < 0) return 'Precio inválido';
                  return null;
                },
                onSaved: (v) => _precio = double.parse(v!),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              Navigator.of(context).pop(
                Producto(
                  nombre: _nombre,
                  descripcion: _descripcion,
                  categoria: _categoria,
                  cantidad: _cantidad,
                  precio: _precio,
                ),
              );
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
