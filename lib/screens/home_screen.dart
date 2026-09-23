import 'package:flutter/material.dart';

import '../services/stats_service.dart';
import 'game_screen.dart';
import 'stats_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int vidas = 3;
  int monedas = 0;
  int racha = 0;
  int EstacionActual = 1;

  @override
  void initState() {
    super.initState();
    cargarProgreso();
  }

  Future<void> cargarProgreso() async {
    final progreso = await StatsService.obtenerProgreso();

    if (!mounted) return;

    setState(() {
      vidas = progreso["vidas"]!;
      monedas = progreso["monedas"]!;
      racha = progreso["racha"]!;
      EstacionActual = progreso["estacion"]!;
    });

    debugPrint("HomeScreen - Estacion actual: $EstacionActual");
  }

  // ============================================================
  // POSICIONES DE LAS 10 ESTACIONES
  // ============================================================
  final List<Offset> posiciones = [
    const Offset(100, 100),   // Estación 1 - Cabaña
    const Offset(155, 230),   // Estación 2
    const Offset(95, 350),    // Estación 3
    const Offset(145, 450),   // Estación 4
    const Offset(110, 550),   // Estación 5 - Chamán
    const Offset(175, 680),   // Estación 6
    const Offset(100, 800),   // Estación 7 - Duende
    const Offset(155, 950),   // Estación 8
    const Offset(100, 1100),  // Estación 9
    const Offset(150, 1250),  // Estación 10
  ];

  @override
  Widget build(BuildContext context) {
    final int indiceEstacion =
        (EstacionActual - 1).clamp(0, posiciones.length - 1);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ==================================================
            // BARRA SUPERIOR
            // ==================================================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Row(
                children: [
                  Image.asset(
                    "assets/avatar/bienvenido.png",
                    width: 45,
                  ),

                  const SizedBox(width: 10),

                  const Expanded(
                    child: Text(
                      "Gramaticador",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.bar_chart),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const StatsScreen(),
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

            // ==================================================
            // ESTADÍSTICAS
            // ==================================================
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("❤️ $vidas"),
                  Text("🪙 $monedas"),
                  Text("🔥 $racha"),
                ],
              ),
            ),

            // ==================================================
            // MAPA
            // ==================================================
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Stack(
                        children: [
                          // MAPA
                          Image.asset(
                            "assets/backgrounds/etapa_3.jpg",
                            fit: BoxFit.fitWidth,
                            width: double.infinity,
                          ),

                          // ==================================================
                          // GRAMATICADOR
                          // ==================================================
                          AnimatedPositioned(
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeInOut,
                            top: posiciones[indiceEstacion].dy,
                            left: posiciones[indiceEstacion].dx,
                            child: Image.asset(
                              "assets/avatar/bienvenido.png",
                              width: 50,
                            ),
                          ),

                          // ==================================================
                          // CABAÑA
                          // ==================================================
                          Positioned(
                            top: 100,
                            right: 100,
                            child: Image.asset(
                              "assets/avatar/cabana.png",
                              width: 80,
                            ),
                          ),

                          // ==================================================
                          // LIBRO 1
                          // ==================================================
                          Positioned(
                            top: 197,
                            right: 125,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const GameScreen(),
                                    ),
                                  ).then((_) {
                                    cargarProgreso();
                                  });
                                },
                                child: Image.asset(
                                  "assets/avatar/libros_pila.png",
                                  width: 70,
                                ),
                              ),
                            ),
                          ),

                          // ==================================================
                          // LIBRO 2
                          // ==================================================
                          Positioned(
                            top: 300,
                            right: 125,
                            child: MouseRegion(
                              cursor: EstacionActual >= 2
                                  ? SystemMouseCursors.click
                                  : SystemMouseCursors.basic,
                              child: GestureDetector(
                                onTap: EstacionActual >= 2
                                    ? () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const GameScreen(),
                                          ),
                                        ).then((_) {
                                          cargarProgreso();
                                        });
                                      }
                                    : null,
                                child: Opacity(
                                  opacity:
                                      EstacionActual >= 2 ? 1.0 : 0.5,
                                  child: Image.asset(
                                    "assets/avatar/libro_abierto.png",
                                    width: 70,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // ==================================================
                          // CHAMÁN
                          // ==================================================
                          Positioned(
                            top: 500,
                            right: 100,
                            child: Image.asset(
                              "assets/avatar/Chaman.png",
                              width: 100,
                            ),
                          ),

                          // ==================================================
                          // DUENDE
                          // ==================================================
                          Positioned(
                            top: 650,
                            left: 100,
                            child: Image.asset(
                              "assets/avatar/duende.png",
                              width: 100,
                            ),
                          ),

                          // ==================================================
                          // MARIAN
                          // ==================================================
                          Positioned(
                            top: 900,
                            left: 100,
                            child: Image.asset(
                              "assets/avatar/marian.png",
                              width: 100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}