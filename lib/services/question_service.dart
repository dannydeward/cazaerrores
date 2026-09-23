import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

import '../models/pregunta.dart';

class QuestionService {
  static List<Pregunta> _banco = [];

  /// Carga el banco de preguntas una sola vez
  static Future<void> inicializar() async {
    if (_banco.isNotEmpty) return;

    final jsonString =
        await rootBundle.loadString('assets/preguntas.json');

    final List<dynamic> jsonData = json.decode(jsonString);

    _banco = jsonData
        .map((e) => Pregunta.fromJson(e))
        .toList();
  }

  /// Devuelve una lección completa
  static Future<List<Pregunta>> obtenerLeccion({
    int cantidad = 14,
    int nivel = 1,
  }) async {
    await inicializar();

    final random = Random();

    List<Pregunta> disponibles = _banco
        .where((p) => p.nivel == nivel)
        .toList();

    disponibles.shuffle(random);

    if (disponibles.length <= cantidad) {
      return disponibles;
    }

    return disponibles.take(cantidad).toList();
  }
}