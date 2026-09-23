import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  // Estadísticas
  static const String mejorPuntuacionKey = "mejor_puntuacion";
  static const String partidasJugadasKey = "partidas_jugadas";
  static const String respuestasCorrectasKey = "respuestas_correctas";
  static const String respuestasIncorrectasKey = "respuestas_incorrectas";

  // Progreso
  static const String EstacionActualKey = "Estacion_actual";
  static const String monedasKey = "monedas";
  static const String vidasKey = "vidas";
  static const String rachaKey = "racha";
  static const String puntosKey = "puntos";

  // ==========================
  // GUARDAR PARTIDA
  // ==========================

  static Future<void> guardarPartida({
    required int puntuacion,
    required int correctas,
    required int incorrectas,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    final mejor = prefs.getInt(mejorPuntuacionKey) ?? 0;

    if (puntuacion > mejor) {
      await prefs.setInt(
        mejorPuntuacionKey,
        puntuacion,
      );
    }

    await prefs.setInt(
      partidasJugadasKey,
      (prefs.getInt(partidasJugadasKey) ?? 0) + 1,
    );

    await prefs.setInt(
      respuestasCorrectasKey,
      (prefs.getInt(respuestasCorrectasKey) ?? 0) + correctas,
    );

    await prefs.setInt(
      respuestasIncorrectasKey,
      (prefs.getInt(respuestasIncorrectasKey) ?? 0) + incorrectas,
    );
  }

  // ==========================
  // GUARDAR PROGRESO
  // ==========================

  static Future<void> guardarProgreso({
    required int estacion,
    required int monedas,
    required int vidas,
    required int racha,
    required int puntos,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(EstacionActualKey, estacion);
    await prefs.setInt(monedasKey, monedas);
    await prefs.setInt(vidasKey, vidas);
    await prefs.setInt(rachaKey, racha);
    await prefs.setInt(puntosKey, puntos);
  }

  // ==========================
  // LEER PROGRESO
  // ==========================

  static Future<Map<String, int>> obtenerProgreso() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "estacion": prefs.getInt(EstacionActualKey) ?? 1,
      "monedas": prefs.getInt(monedasKey) ?? 0,
      "vidas": prefs.getInt(vidasKey) ?? 3,
      "racha": prefs.getInt(rachaKey) ?? 0,
      "puntos": prefs.getInt(puntosKey) ?? 0,
    };
  }

  // ==========================
  // AVANZAR ESTACION
  // ==========================

  static Future<void> avanzaEstacion() async {
    final prefs = await SharedPreferences.getInstance();

    int estacion= prefs.getInt(EstacionActualKey) ?? 1;

    await prefs.setInt(
      EstacionActualKey,
      estacion + 1,
    );
  }

  // ==========================
  // ESTADÍSTICAS
  // ==========================

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