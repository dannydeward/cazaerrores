import 'dart:math';

import 'package:flutter/material.dart';

import '../models/pregunta.dart';
import '../services/game_service.dart';
import '../services/question_service.dart';
import '../services/stats_service.dart';
import 'package:busca_error/screens/stats_screen.dart';
import '../models/jugador.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  //final GameService game = GameService();
  late final GameService game;

  List<Pregunta> leccion = [];
  int EstacionActual = 1;

Future<void> cargarEstacion() async {
  final progreso = await StatsService.obtenerProgreso();

 setState(() {
 EstacionActual = progreso["estacion"]!;

  game.jugador = Jugador(
    vidas: progreso["vidas"]!,
    monedas: progreso["monedas"]!,
    puntos: progreso["puntos"]!,
    racha: progreso["racha"]!,
  );
});
}
  int indicePregunta = 0;

  Pregunta? preguntaActual;

  List<String> opciones = [];

  bool cargando = true;
  bool respondido = false;

  String? respuestaSeleccionada;

  String mensaje = "";

  Color colorMensaje = Colors.transparent;

@override
void initState() {
  super.initState();
  game = GameService();
  cargarEstacion();
  cargarLeccion();
  
}

  Future<void> cargarLeccion() async {
    leccion = await QuestionService.obtenerLeccion(
      cantidad: 14,
      nivel: 1,
    );

    indicePregunta = 0;

    cargarPreguntaActual();

    setState(() {
      cargando = false;
    });
  }

  void cargarPreguntaActual() {
    if (indicePregunta >= leccion.length) {
      finalizarLeccion();
      return;
    }

    preguntaActual = leccion[indicePregunta];

    opciones = [
  preguntaActual!.correcta,
  ...preguntaActual!.incorrectas.take(3),
];

    opciones.shuffle();

    respondido = false;

    respuestaSeleccionada = null;

    mensaje = "";

    colorMensaje = Colors.transparent;
  }

  void responder(String respuesta) {
    if (respondido) return;

    setState(() {
      respondido = true;

      respuestaSeleccionada = respuesta;

      if (respuesta == preguntaActual!.correcta) {
        game.respuestaCorrecta();

        mensaje = "¡Correcto!";

        colorMensaje = Colors.green;
      } else {
        game.respuestaIncorrecta();

        mensaje =
            "La respuesta correcta era:\n${preguntaActual!.correcta}";

        colorMensaje = Colors.red;
      }
    });
  }

  void continuar() {

  if (game.gameOver) {
    Navigator.pop(context);
    return;
  }

  indicePregunta++;

  if (indicePregunta >= leccion.length) {
    finalizarLeccion();
    return;
  }

  setState(() {
    cargarPreguntaActual();
  });
}

  Future<void> finalizarLeccion() async {
  await StatsService.guardarPartida(
    puntuacion: game.puntos,
    correctas: game.correctas,
    incorrectas: game.incorrectas,
  );

  debugPrint("Estacion antes de guardar: $EstacionActual");

  await StatsService.avanzaEstacion();

  final progreso = await StatsService.obtenerProgreso();

  debugPrint("Estacion guardada: ${progreso["estacion"]}");

  await StatsService.guardarProgreso(
    estacion: progreso["estacion"]!,
    monedas: game.monedas,
    vidas: game.vidas,
    racha: game.racha,
    puntos:game.puntos,
  );

  if (!mounted) return;

  Navigator.pop(context);
}

  Color colorBoton(String opcion) {
    if (!respondido) {
      return const Color(0xFF466345); 
    }

    if (opcion == preguntaActual!.correcta) {
      return Colors.green;
    }

    if (opcion == respuestaSeleccionada) {
      return Colors.red;
    }

    return Colors.grey;
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

    return Scaffold(
      backgroundColor: const Color(0xFFF2EBD8),

     appBar: AppBar(
  automaticallyImplyLeading: false,
  toolbarHeight: 70,
  title: Row(
    children: [
      const CircleAvatar(
        radius: 18,
        child: Icon(Icons.person, size: 20),
      ),

      const SizedBox(width: 10),

      const Expanded(
        child: Text(
          "GRAMATICADOR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      IconButton(
        icon: const Icon(Icons.bar_chart),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StatsScreen(),
            ),
          );
        },
      ),

      IconButton(
        icon: const Icon(Icons.menu_book),
        onPressed: () {},
      ),

      IconButton(
        icon: const Icon(Icons.emoji_events),
        onPressed: () {},
      ),
    ],
  ),
),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
          padding: const EdgeInsets.all(20),

            child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,

            children: [

              /// VIDAS - MONEDAS - RACHA

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,

                children: [

                  Row(
                    children: [

                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${game.vidas}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.monetization_on,
                        color: Colors.amber,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${game.monedas}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                      const Icon(
                        Icons.local_fire_department,
                        color: Colors.orange,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        "${game.racha}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 25),

              Text(
                "Lección $EstacionActual",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              LinearProgressIndicator(
                value:
                    (indicePregunta + 1) /
                    leccion.length,

                minHeight: 10,

                borderRadius:
                    BorderRadius.circular(10),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  "${indicePregunta + 1} / ${leccion.length}",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              

              const SizedBox(height: 20),

              Card(
                elevation: 2,

                child: SingleChildScrollView(
                  child: Padding(
                  padding:
                      const EdgeInsets.all(16),

                  child: Text(
                    preguntaActual!.regla.isEmpty
                        ? "Encuentra el error ortográfico."
                        : preguntaActual!.regla,

                    textAlign: TextAlign.center,

                    style: const TextStyle(
                      fontSize: 18,
        
                    ),
                  ),
                ),
              ),
              ),

              const SizedBox(height: 25),

              Text(
                preguntaActual!.esFrase
                    ? "¿Cuál frase está escrita correctamente?"
                    : "¿Cuál palabra está escrita correctamente?",

                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),
              Center(
  child: SizedBox(
    width: 800,
                          child:  GridView.builder(
  shrinkWrap: true,
  physics: const NeverScrollableScrollPhysics(),
  itemCount: opciones.length,
  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 3.4,
  ),
  itemBuilder: (context, index) {
    return InkWell(
      onTap: respondido
          ? null
          : () => responder(opciones[index]),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: colorBoton(opciones[index]),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.brown.shade700,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            opciones[index],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
          
            ),
          ),
        ),
      ),
    );
  },
),
  ),
              ),
              const SizedBox(height: 25),

              AnimatedOpacity(
                opacity: respondido ? 1 : 0,
                duration: const Duration(
                  milliseconds: 250,
                ),

                child: Text(
                  mensaje,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 20,
                    color: colorMensaje,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

             const SizedBox(height: 5),

              if (respondido)
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: continuar,

                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                    ),

                    child: Text(
                      game.gameOver
                          ? "FINALIZAR"
                          : "CONTINUAR",

                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

             ], // children
          ), // Column
        ), // Padding
      ), // SingleChildScrollView
    ), // SafeArea
  ); // Scaffold
}
}