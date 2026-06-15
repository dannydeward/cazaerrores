import 'dart:convert';
import 'package:flutter/services.dart';

import '../models/pregunta.dart';

class QuestionService {
  static Future<List<Pregunta>> cargarPreguntas() async {
    final String jsonString =
        await rootBundle.loadString('assets/preguntas.json');

    final List<dynamic> jsonData =
        json.decode(jsonString);

    return jsonData
        .map((item) => Pregunta.fromJson(item))
        .toList();
  }
}