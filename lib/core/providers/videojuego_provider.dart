import 'package:flutter/foundation.dart';
import '../models/videojuego_model.dart';
import '../services/firestore_service.dart';

class VideojuegoProvider extends ChangeNotifier {
  final FirestoreService _repo = FirestoreService();

  // Estado principal
  List<Videojuego> items = [];
  bool loading = false;
  String? error;

  // Filtros
  GameType? tipo;
  AgeRating? edad;
  bool soloAdultos = false;    // +18
  bool soloMenores18 = false;  // -18 (incluye +14 y +16)

  /// Carga todo el inventario (o la vista filtrada si hay filtros activos)
  Future<void> load() async {
    loading = true; error = null; notifyListeners();
    try {
      if (_hayFiltros) {
        items = await _repo.filter(
          tipo: tipo,
          edad: edad,
          soloAdultos: soloAdultos,
          soloMenores18: soloMenores18,
        );
      } else {
        items = await _repo.getAll();
      }
    } catch (e) {
      error = e.toString();
    } finally {
      loading = false; notifyListeners();
    }
  }

  /// Aplica filtros por tipo / edad / chips +18 y -18
  Future<void> applyFilters({
    GameType? tipo,
    AgeRating? edad,
    bool? soloAdultos,
    bool? soloMenores18,
  }) async {
    this.tipo = tipo;
    this.edad = edad;
    this.soloAdultos = soloAdultos ?? this.soloAdultos;
    this.soloMenores18 = soloMenores18 ?? this.soloMenores18;
    await load();
  }

  void clearFilters() {
    tipo = null; edad = null; soloAdultos = false; soloMenores18 = false;
    load();
  }

  // ------------------ CRUD ------------------

  Future<void> add(Videojuego v) async {
    await _repo.add(v);
    await load();
  }

  Future<void> update(Videojuego v) async {
    await _repo.update(v);
    await load();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  // --------------- Gestión de stock ----------------

  /// Establece el stock exacto de un juego.
  Future<void> setStock(String id, int newStock) async {
    assert(newStock >= 0, 'El stock no puede ser negativo');
    final game = _byId(id);
    if (game == null) return;
    await _repo.update(game.copyWith(stock: newStock));
    await load();
  }

  /// Incrementa stock (por defecto en 1).
  Future<void> increaseStock(String id, {int by = 1}) async {
    final game = _byId(id);
    if (game == null) return;
    final next = game.stock + (by < 0 ? 0 : by);
    await _repo.update(game.copyWith(stock: next));
    await load();
  }

  /// Reduce stock. Si [allowNegative] es false (por defecto), no baja de 0.
  Future<void> decreaseStock(String id, {int by = 1, bool allowNegative = false}) async {
    final game = _byId(id);
    if (game == null) return;
    int next = game.stock - (by < 0 ? 0 : by);
    if (!allowNegative && next < 0) next = 0;
    await _repo.update(game.copyWith(stock: next));
    await load();
  }

  /// Ajuste en lote: map de {id: delta}. (delta positivo suma, negativo resta).
  Future<void> bulkAdjust(Map<String, int> deltas, {bool allowNegative = false}) async {
    loading = true; notifyListeners();
    try {
      for (final entry in deltas.entries) {
        final game = _byId(entry.key);
        if (game == null) continue;
        int next = game.stock + entry.value;
        if (!allowNegative && next < 0) next = 0;
        await _repo.update(game.copyWith(stock: next));
      }
      await load();
    } finally {
      loading = false; notifyListeners();
    }
  }

  /// Devuelve la lista de juegos con stock por debajo del umbral.
  List<Videojuego> lowStock({int threshold = 3}) {
    return items.where((g) => g.stock <= threshold).toList(growable: false);
  }

  // ------------------ Helpers ------------------

  bool get _hayFiltros =>
      tipo != null || edad != null || soloAdultos || soloMenores18;

  Videojuego? _byId(String id) {
    try {
      return items.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}
