import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/videojuego_model.dart';
import '../../core/providers/videojuego_provider.dart';

class VideojuegoDetailScreen extends StatelessWidget {
  final Videojuego game;
  const VideojuegoDetailScreen({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    final prov = context.read<VideojuegoProvider>();
    return Scaffold(
      appBar: AppBar(title: Text(game.titulo), actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () => Navigator.pushNamed(context, '/addEdit', arguments: game),
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async { await prov.delete(game.id); if (context.mounted) Navigator.pop(context); },
        ),
      ]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${game.tipo.label} • ${game.edad.label}', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text('Stock: ${game.stock}'),
          Text('Precio: ${game.precio.toStringAsFixed(2)} €'),
          const SizedBox(height: 12),
          Text('Creado: ${game.creado}'),
        ]),
      ),
    );
  }
}
