class Pregunta {
  final String pregunta;
  final List<String> opciones;
  final int correcta;

  Pregunta({required this.pregunta, required this.opciones, required this.correcta});

  factory Pregunta.fromMap(Map<String, dynamic> data) {
    return Pregunta(
      pregunta: data['pregunta'],
      opciones: List<String>.from(data['opciones']),
      correcta: data['correcta'],
    );
  }
}

class TestModel {
  final String id;
  final String nombre;
  final List<Pregunta> preguntas;

  TestModel({required this.id, required this.nombre, required this.preguntas});

  factory TestModel.fromFirestore(String id, Map<String, dynamic> data) {
    return TestModel(
      id: id,
      nombre: data['nombre'],
      preguntas: List<Map<String, dynamic>>.from(data['preguntas'])
          .map((q) => Pregunta.fromMap(q))
          .toList(),
    );
  }
}
