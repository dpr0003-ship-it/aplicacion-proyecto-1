import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/validators.dart';
import '../../core/models/videojuego_model.dart';
import '../../core/providers/videojuego_provider.dart';


class AddEditVideojuegoScreen extends StatefulWidget {
  final Videojuego? initial;
  const AddEditVideojuegoScreen({super.key, this.initial});

  @override
  State<AddEditVideojuegoScreen> createState() => _AddEditVideojuegoScreenState();
}

class _AddEditVideojuegoScreenState extends State<AddEditVideojuegoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titulo = TextEditingController();
  final _stock = TextEditingController(text: '0');
  final _precio = TextEditingController(text: '0');
  GameType _tipo = GameType.action;
  AgeRating _edad = AgeRating.plus14;

  @override
  void initState() {
    super.initState();
    final g = widget.initial;
    if (g != null) {
      _titulo.text = g.titulo;
      _stock.text = g.stock.toString();
      _precio.text = g.precio.toString();
      _tipo = g.tipo;
      _edad = g.edad;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.read<VideojuegoProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(widget.initial == null ? 'Nuevo juego' : 'Editar juego')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(children: [
            TextFormField(
              controller: _titulo,
              decoration: const InputDecoration(labelText: 'Título'),
              validator: (v) => Validators.requiredField(v, name: 'Título'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<GameType>(
  initialValue: _tipo, // ✅
  items: GameType.values
      .map((t) => DropdownMenuItem<GameType>(value: t, child: Text(t.label)))
      .toList(),
  onChanged: (v) => setState(() => _tipo = v ?? _tipo), // <- aquí estaba el typo
),


            DropdownButtonFormField<AgeRating>(
  initialValue: _edad, // ✅
  items: AgeRating.values
      .map((r) => DropdownMenuItem<AgeRating>(value: r, child: Text(r.label)))
      .toList(),
  onChanged: (v) => setState(() => _edad = v ?? _edad),
),


            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
              validator: (v) => Validators.positiveInt(v, name: 'Stock'),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _precio,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Precio (€)'),
              validator: (v) => Validators.positiveDouble(v, name: 'Precio'),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                final game = Videojuego(
                  id: widget.initial?.id ?? '',
                  titulo: _titulo.text.trim(),
                  tipo: _tipo,
                  edad: _edad,
                  stock: int.parse(_stock.text),
                  precio: double.parse(_precio.text.replaceAll(',', '.')),
                  creado: DateTime.now(),
                );
                if (widget.initial == null) {
                  await prov.add(game);
                } else {
                  await prov.update(game);
                }
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Guardar'),
            )
          ]),
        ),
      ),
    );
  }
}
