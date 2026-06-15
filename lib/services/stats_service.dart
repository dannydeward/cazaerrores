import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  static const String mejorPuntuacionKey = "mejor_puntuacion";
  static const String partidasJugadasKey = "partidas_jugadas";
  static const String respuestasCorrectasKey = "respuestas_correctas";
  static const String respuestasIncorrectasKey = "respuestas_incorrectas";

  static Future<void> guardarPartida({
    required int puntuacion,
    required int correctas,
    required int incorrectas,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    int mejorPuntuacion =
        prefs.getInt(mejorPuntuacionKey) ?? 0;

    if (puntuacion > mejorPuntuacion) {
      await prefs.setInt(
        mejorPuntuacionKey,
        puntuacion,
      );
    }

    int partidas =
        prefs.getInt(partidasJugadasKey) ?? 0;

    await prefs.setInt(
      partidasJugadasKey,
      partidas + 1,
    );

    int totalCorrectas =
        prefs.getInt(respuestasCorrectasKey) ?? 0;

    await prefs.setInt(
      respuestasCorrectasKey,
      totalCorrectas + correctas,
    );

    int totalIncorrectas =
        prefs.getInt(respuestasIncorrectasKey) ?? 0;

    await prefs.setInt(
      respuestasIncorrectasKey,
      totalIncorrectas + incorrectas,
    );
  }

  static Future<Map<String, int>> obtenerEstadisticas() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "mejorPuntuacion":
          prefs.getInt(mejorPuntuacionKey) ?? 0,
      "partidasJugadas":
          prefs.getInt(partidasJugadasKey) ?? 0,
      "correctas":
          prefs.getInt(respuestasCorrectasKey) ?? 0,
      "incorrectas":
          prefs.getInt(respuestasIncorrectasKey) ?? 0,
    };
  }
}