import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StatsService {
  // Claves de Estadísticas Históricas
  static const String mejorPuntuacionKey = "mejor_puntuacion";
  static const String partidasJugadasKey = "partidas_jugadas";
  static const String respuestasCorrectasKey = "respuestas_correctas";
  static const String respuestasIncorrectasKey = "respuestas_incorrectas";

  // Claves de Progreso Actual
  static const String estacionActualKey = "estacion_actual";
  static const String monedasKey = "monedas";
  static const String vidasKey = "vidas";
  static const String rachaKey = "racha";
  static const String puntosKey = "puntos";
  
  // Clave para Sistema de Vidas Temporizado
  static const String timestampPerdidaVidaKey = "timestamp_perdida_vida";

  // GUARDAR PARTIDA (Estadísticas acumulativas)
  static Future<void> guardarPartida({
    required int puntuacion,
    required int correctas,
    required int incorrectas,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    final mejor = prefs.getInt(mejorPuntuacionKey) ?? 0;
    if (puntuacion > mejor) {
      await prefs.setInt(mejorPuntuacionKey, puntuacion);
    }

    await prefs.setInt(partidasJugadasKey, (prefs.getInt(partidasJugadasKey) ?? 0) + 1);
    await prefs.setInt(respuestasCorrectasKey, (prefs.getInt(respuestasCorrectasKey) ?? 0) + correctas);
    await prefs.setInt(respuestasIncorrectasKey, (prefs.getInt(respuestasIncorrectasKey) ?? 0) + incorrectas);
  }

  // GUARDAR PROGRESO ACTUAL (Sesión)
  static Future<void> guardarProgreso({
    required int estacion,
    required int monedas,
    required int vidas,
    required int racha,
    required int puntos,
    bool registrarPerdidaVida = false,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setInt(estacionActualKey, estacion);
    await prefs.setInt(monedasKey, monedas);
    await prefs.setInt(vidasKey, vidas);
    await prefs.setInt(rachaKey, racha);
    await prefs.setInt(puntosKey, puntos);

    if (registrarPerdidaVida && vidas < 3) {
      await prefs.setInt(timestampPerdidaVidaKey, DateTime.now().millisecondsSinceEpoch);
    } else if (vidas >= 3) {
      await prefs.remove(timestampPerdidaVidaKey);
    }
  }

  // OBTENER PROGRESO (Con cálculo automático de vidas recuperadas)
  static Future<Map<String, int>> obtenerProgreso() async {
    final prefs = await SharedPreferences.getInstance();
    
    int vidas = prefs.getInt(vidasKey) ?? 3;
    final timestampPerdida = prefs.getInt(timestampPerdidaVidaKey);

    if (timestampPerdida != null && vidas < 3) {
      final ahora = DateTime.now().millisecondsSinceEpoch;
      final milisegundosPasados = ahora - timestampPerdida;
      final vidasRecuperadas = (milisegundosPasados ~/ 900000).clamp(0, 3 - vidas);
      
      if (vidasRecuperadas > 0) {
        vidas += vidasRecuperadas;
        final nuevoTimestamp = timestampPerdida + (vidasRecuperadas * 900000);
        await prefs.setInt(timestampPerdidaVidaKey, nuevoTimestamp);
        if (vidas >= 3) await prefs.remove(timestampPerdidaVidaKey);
      }
    }

    return {
      "estacion": prefs.getInt(estacionActualKey) ?? 1,
      "monedas": prefs.getInt(monedasKey) ?? 0,
      "vidas": vidas,
      "racha": prefs.getInt(rachaKey) ?? 0,
      "puntos": prefs.getInt(puntosKey) ?? 0,
    };
  }

  // AVANZAR ESTACION
  static Future<void> avanzaEstacion() async {
    final prefs = await SharedPreferences.getInstance();
    int estacion = prefs.getInt(estacionActualKey) ?? 1;
    await prefs.setInt(estacionActualKey, estacion + 1);
  }

  // OBTENER ESTADISTICAS HISTÓRICAS
  static Future<Map<String, int>> obtenerEstadisticas() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "mejorPuntuacion": prefs.getInt(mejorPuntuacionKey) ?? 0,
      "partidasJugadas": prefs.getInt(partidasJugadasKey) ?? 0,
      "correctas": prefs.getInt(respuestasCorrectasKey) ?? 0,
      "incorrectas": prefs.getInt(respuestasIncorrectasKey) ?? 0,
    };
  }

  // ============================================================
  // ENVIAR EVENTO AL SERVIDOR FLASK (NUEVO)
  // ============================================================
  static Future<void> enviarEvento({
    required String tester,
    required String evento,
    Map<String, dynamic>? datos,
  }) async {
    final url = Uri.parse('http://127.0.0.1:5000/api/log');
    
    final payload = {
      'tester': tester,
      'evento': evento,
      'datos': datos ?? {},
    };

    try {
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );
      print("✅ Evento enviado: $evento");
    } catch (e) {
      print("⚠️ Error enviando evento: $e");
    }
  }
}