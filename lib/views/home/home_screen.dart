import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/videojuego_model.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/videojuego_provider.dart';
import '../../routing/app_routes.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GameType? _tipo;
  AgeRating? _edad;
  bool _soloAdultos = false;
  bool _soloMenores18 = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<VideojuegoProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<VideojuegoProvider>();
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario de Videojuegos'),
        actions: [
          IconButton(onPressed: () => prov.clearFilters(), icon: const Icon(Icons.clear_all)),
          IconButton(onPressed: () { auth.logout(); Navigator.pushReplacementNamed(context, AppRoutes.login); },
            icon: const Icon(Icons.logout)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.addEdit),
        child: const Icon(Icons.add),
      ),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filtros
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Wrap(spacing: 8, crossAxisAlignment: WrapCrossAlignment.center, children: [
                    const Text('Tipo:'),
                    DropdownButton<GameType?>(
                      value: _tipo,
                      hint: const Text('Todos'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todos')),
                        ...GameType.values.map((t) => DropdownMenuItem(value: t, child: Text(t.label))),
                      ],
                      onChanged: (v) { setState(() => _tipo = v);
                        prov.applyFilters(tipo: _tipo, edad: _edad, soloAdultos: _soloAdultos, soloMenores18: _soloMenores18);
                      },
                    ),
                    const Text('Edad:'),
                    DropdownButton<AgeRating?>(
                      value: _edad,
                      hint: const Text('Todas'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('Todas')),
                        ...AgeRating.values.map((r) => DropdownMenuItem(value: r, child: Text(r.label))),
                      ],
                      onChanged: (v) { setState(() => _edad = v);
                        prov.applyFilters(tipo: _tipo, edad: _edad, soloAdultos: _soloAdultos, soloMenores18: _soloMenores18);
                      },
                    ),
                    FilterChip(
                      label: const Text('+18'),
                      selected: _soloAdultos,
                      onSelected: (v){ setState(() { _soloAdultos = v; if (v) _soloMenores18=false; });
                        prov.applyFilters(tipo: _tipo, edad: _edad, soloAdultos: _soloAdultos, soloMenores18: _soloMenores18);
                      },
                    ),
                    FilterChip(
                      label: const Text('-18'),
                      selected: _soloMenores18,
                      onSelected: (v){ setState(() { _soloMenores18 = v; if (v) _soloAdultos=false; });
                        prov.applyFilters(tipo: _tipo, edad: _edad, soloAdultos: _soloAdultos, soloMenores18: _soloMenores18);
                      },
                    ),
                  ]),
                ),
                const Divider(height: 0),
                Expanded(
                  child: prov.items.isEmpty
                      ? const Center(child: Text('No hay resultados'))
                      : ListView.builder(
                          itemCount: prov.items.length,
                          itemBuilder: (_, i) {
                            final g = prov.items[i];
                            return Card(
                              child: ListTile(
                                title: Text(g.titulo),
                                subtitle: Text('${g.tipo.label} • ${g.edad.label} • Stock: ${g.stock}'),
                                trailing: Text('${g.precio.toStringAsFixed(2)}€'),
                                onTap: () => Navigator.pushNamed(context, AppRoutes.detail, arguments: g),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
