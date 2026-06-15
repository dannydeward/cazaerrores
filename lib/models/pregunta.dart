class Pregunta {
  final String correcta;
  final List<dynamic> incorrectas;
  final int nivel;

  Pregunta({
    required this.correcta,
    required this.incorrectas,
    required this.nivel,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      correcta: json['correcta'],
      incorrectas: json['incorrectas'],
      nivel: json['nivel'],
    );
  }
}

