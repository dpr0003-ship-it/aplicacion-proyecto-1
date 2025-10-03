import 'package:cloud_firestore/cloud_firestore.dart';

enum GameType { action, adventure, rpg, sports, racing, strategy, simulation, puzzle, horror, indie }
extension GameTypeX on GameType {
  String get label => switch (this) {
    GameType.action => 'Acción',
    GameType.adventure => 'Aventura',
    GameType.rpg => 'RPG',
    GameType.sports => 'Deportes',
    GameType.racing => 'Carreras',
    GameType.strategy => 'Estrategia',
    GameType.simulation => 'Simulación',
    GameType.puzzle => 'Puzle',
    GameType.horror => 'Terror',
    GameType.indie => 'Indie',
  };
}

enum AgeRating { plus14, plus16, plus18, under18 }
extension AgeRatingX on AgeRating {
  String get label => switch (this) {
    AgeRating.plus14 => '+14',
    AgeRating.plus16 => '+16',
    AgeRating.plus18 => '+18',
    AgeRating.under18 => '-18',
  };
  bool get isAdultOnly => this == AgeRating.plus18;
  bool get isUnder18 => this == AgeRating.under18 || this == AgeRating.plus14 || this == AgeRating.plus16;
}

class Videojuego {
  final String id;
  final String titulo;
  final GameType tipo;
  final AgeRating edad;
  final int stock;
  final double precio;
  final DateTime creado;

  Videojuego({
    required this.id,
    required this.titulo,
    required this.tipo,
    required this.edad,
    required this.stock,
    required this.precio,
    required this.creado,
  });

  Map<String, dynamic> toMap() => {
        'titulo': titulo,
        'tipo': tipo.name,
        'edad': edad.name,
        'stock': stock,
        'precio': precio,
        'creado': Timestamp.fromDate(creado),
      };

  factory Videojuego.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return Videojuego(
      id: doc.id,
      titulo: d['titulo'] ?? '',
      tipo: GameType.values.firstWhere((e) => e.name == d['tipo'], orElse: () => GameType.action),
      edad: AgeRating.values.firstWhere((e) => e.name == d['edad'], orElse: () => AgeRating.plus14),
      stock: (d['stock'] ?? 0) as int,
      precio: (d['precio'] ?? 0).toDouble(),
      creado: (d['creado'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Videojuego copyWith({
    String? id,
    String? titulo,
    GameType? tipo,
    AgeRating? edad,
    int? stock,
    double? precio,
    DateTime? creado,
  }) => Videojuego(
        id: id ?? this.id,
        titulo: titulo ?? this.titulo,
        tipo: tipo ?? this.tipo,
        edad: edad ?? this.edad,
        stock: stock ?? this.stock,
        precio: precio ?? this.precio,
        creado: creado ?? this.creado,
      );
}
