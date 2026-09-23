import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/pregunta.dart';

class QuestionBankService {
  static final Random _random = Random();
  static Set<String> _palabrasUsadas = {};
  static List<Map<String, dynamic>> _bancoCompleto = [];
  static bool _cargado = false;

  static Future<void> cargarBanco() async {
    if (_cargado) return;
    try {
      // ️ VERIFICA QUE ESTA RUTA COINCIDA EXACTAMENTE CON TU pubspec.yaml
      final jsonString = await rootBundle.loadString('assets/banco_preguntas.json');
      final data = json.decode(jsonString) as List<dynamic>;
      _bancoCompleto = data.map((e) => e as Map<String, dynamic>).toList();
      _cargado = true;
      print("✅ Banco cargado: ${_bancoCompleto.length} preguntas");
    } catch (e) {
      print("️ Error cargando banco: $e");
    }
  }

  static void resetearMemoria() {
    _palabrasUsadas.clear();
  }

  static Future<List<Pregunta>> generarLeccionUnica({required int cantidad}) async {
    await cargarBanco();
    List<Pregunta> leccion = [];
    int intentos = 0;

    while (leccion.length < cantidad && intentos < 5000) {
      if (_palabrasUsadas.length >= _bancoCompleto.length) resetearMemoria();
      
      final raw = _bancoCompleto[_random.nextInt(_bancoCompleto.length)];
      if (!_palabrasUsadas.contains(raw['correcta'])) {
        _palabrasUsadas.add(raw['correcta']);
        
        // ✅ CORRECCIÓN: Se incluye 'nivel' usando factory fromJson o constructor directo
        leccion.add(Pregunta(
          correcta: raw['correcta'],
          incorrectas: List<String>.from(raw['incorrectas']),
          nivel: raw['nivel'] ?? 1, // Usa el nivel del JSON o 1 por defecto
          regla: "",
          esFrase: false,
        ));
      }
      intentos++;
    }
    return leccion;
  }
}