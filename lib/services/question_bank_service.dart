import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import '../models/pregunta.dart';
import 'package:archive/archive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class QuestionBankService {
  static final Random _random = Random();
  static Set<String> _palabrasUsadas = {};
  static List<Map<String, dynamic>> _bancoCompleto = [];
  static bool _cargado = false;

    static Future<void> cargarBanco() async {
    if (_bancoCompleto.isNotEmpty) return; // Si ya está cargado, no hacer nada

    try {
      // 1. Descargar el archivo comprimido desde Flask
        final response = await http.get( Uri.parse('https://ramdanny1.pythonanywhere.com/data/banco_preguntas.json.gz'), );
      if (response.statusCode == 200) {
        // 2. Descomprimir los bytes GZIP en memoria
        final decodedBytes = GZipDecoder().decodeBytes(response.bodyBytes);
        
        // 3. Convertir los bytes descomprimidos a texto (UTF-8)
        final jsonString = utf8.decode(decodedBytes);
        
        // 4. Leer el JSON
        final data = json.decode(jsonString) as List<dynamic>;
        _bancoCompleto = data.map((e) => Map<String, dynamic>.from(e)).toList();
        
        print("✅ Banco cargado y descomprimido desde Flask: ${_bancoCompleto.length} preguntas");
      } else {
        throw Exception("Error al cargar banco: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error cargando banco: $e");
      rethrow;
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