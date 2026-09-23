class Pregunta {
  /// Texto correcto (palabra o frase)
  final String correcta;

  /// Opciones incorrectas
  final List<String> incorrectas;

  /// Nivel interno de dificultad
  final int nivel;

  /// Regla ortográfica que mostrará Gramaticador
  final String regla;

  /// false = palabra | true = frase
  final bool esFrase;

  Pregunta({
    required this.correcta,
    required this.incorrectas,
    required this.nivel,
    this.regla = "",
    this.esFrase = false,
  });

  factory Pregunta.fromJson(Map<String, dynamic> json) {
    return Pregunta(
      correcta: json['correcta'] ?? "",
      incorrectas: List<String>.from(json['incorrectas'] ?? []),
      nivel: json['nivel'] ?? 1,
      regla: json['regla'] ?? "",
      esFrase: json['esFrase'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "correcta": correcta,
      "incorrectas": incorrectas,
      "nivel": nivel,
      "regla": regla,
      "esFrase": esFrase,
    };
  }
}