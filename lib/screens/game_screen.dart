import 'dart:math';
import 'package:flutter/material.dart';

import '../models/pregunta.dart';
import '../services/question_service.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int vidas = 5;
  int puntos = 0;

  String mensaje = "";
  Color colorMensaje = Colors.black;

  List<Pregunta> preguntas = [];
  Pregunta? preguntaActual;

  bool cargando = true;
  bool respondido = false;

  List<String> opciones = [];

  String? respuestaSeleccionada;

  @override
  void initState() {
    super.initState();
    cargarPreguntas();
  }

  Future<void> cargarPreguntas() async {
    try {
      preguntas = await QuestionService.cargarPreguntas();

      if (preguntas.isNotEmpty) {
        seleccionarPregunta();
      }

      setState(() {
        cargando = false;
      });
    } catch (e) {
      setState(() {
        cargando = false;
        mensaje = "Error cargando preguntas";
        colorMensaje = Colors.red;
      });
    }
  }

  void seleccionarPregunta() {
    if (preguntas.isEmpty) return;

    final random = Random();

    final pregunta = preguntas[random.nextInt(preguntas.length)];

    final incorrecta = pregunta
        .incorrectas[random.nextInt(pregunta.incorrectas.length)]
        .toString();

    final nuevasOpciones = [
      pregunta.correcta,
      incorrecta,
    ];

    nuevasOpciones.shuffle();

    setState(() {
      preguntaActual = pregunta;
      opciones = nuevasOpciones;

      respondido = false;
      respuestaSeleccionada = null;

      mensaje = "";
      colorMensaje = Colors.black;
    });
  }

  void responder(String respuesta) {
    if (respondido || preguntaActual == null) return;

    setState(() {
      respondido = true;
      respuestaSeleccionada = respuesta;

      if (respuesta == preguntaActual!.correcta) {
        puntos += 10;

        mensaje = "✅ ¡Correcto!";
        colorMensaje = Colors.green;
      } else {
        vidas--;

        mensaje =
            "❌ Incorrecto. La correcta era: ${preguntaActual!.correcta}";
        colorMensaje = Colors.red;
      }
    });
  }

  Color obtenerColorBoton(String opcion) {
    if (!respondido) {
      return Colors.blue;
    }

    if (opcion == preguntaActual!.correcta) {
      return Colors.green;
    }

    if (opcion == respuestaSeleccionada &&
        opcion != preguntaActual!.correcta) {
      return Colors.red;
    }

    return Colors.grey;
  }

  void continuar() {
    if (vidas <= 0) return;

    seleccionarPregunta();
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (preguntaActual == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("CazaErrores"),
        ),
        body: const Center(
          child: Text(
            "No se pudieron cargar las preguntas",
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("CazaErrores"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              "❤️" * vidas,
              style: const TextStyle(fontSize: 28),
            ),

            const SizedBox(height: 10),

            Text(
              "Puntos: $puntos",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              "Nivel ${preguntaActual!.nivel}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "¿Cuál palabra está escrita correctamente?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    respondido ? null : () => responder(opciones[0]),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      obtenerColorBoton(opciones[0]),
                ),
                child: Text(
                  opciones[0],
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    respondido ? null : () => responder(opciones[1]),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      obtenerColorBoton(opciones[1]),
                ),
                child: Text(
                  opciones[1],
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: colorMensaje,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            if (respondido && vidas > 0)
              ElevatedButton(
                onPressed: continuar,
                child: const Text("Continuar"),
              ),

            const SizedBox(height: 20),

            if (vidas <= 0)
              Column(
                children: [
                  const Text(
                    "💀 GAME OVER",
                    style: TextStyle(
                      fontSize: 32,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    "Puntuación final: $puntos",
                    style: const TextStyle(fontSize: 22),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}