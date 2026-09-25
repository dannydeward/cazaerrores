import 'package:flutter/material.dart';
import '../services/stats_service.dart';
import 'game_screen.dart';
import 'stats_screen.dart';
import 'dart:html' as html; // Solo para Flutter Web

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

  // ============================================================
  // POSICIONES DE LAS ESTACIONES (LIBROS) - DEFINIDAS UNA SOLA VEZ
  // ============================================================
  final List<Offset> posiciones = [
    const Offset(100, 197),   // Estación 1
    const Offset(155, 300),   // Estación 2
    const Offset(95, 400),    // Estación 3
    const Offset(145, 500),   // Estación 4
    const Offset(110, 600),   // Estación 5 - Chamán
    const Offset(175, 700),   // Estación 6
    const Offset(100, 800),   // Estación 7 - Duende
    const Offset(155, 950),   // Estación 8
    const Offset(100, 1100),  // Estación 9
    const Offset(150, 1250),  // Estación 10
  ];

    @override
  void initState() {
    super.initState();
    cargarProgreso();

    // Leer el nombre guardado por la Landing Page, o usar "Tester" por defecto
    String nombreTester = html.window.localStorage['tester_nombre'] ?? 'Tester';
    
        print("🚀 Jugador identificado: $nombreTester");
    
    StatsService.enviarEvento(
      tester: nombreTester,
      evento: "inicio_app"
    );
  }

  Future<void> cargarProgreso() async {
    final progreso = await StatsService.obtenerProgreso();
    if (!mounted) return;

    setState(() {
      vidas = progreso["vidas"] ?? 3;
      monedas = progreso["monedas"] ?? 0;
      racha = progreso["racha"] ?? 0;
      EstacionActual = progreso["estacion"] ?? 1;
    });
    debugPrint("HomeScreen - Estacion actual: $EstacionActual");
  }

  // ============================================================
  // FUNCIÓN ÚNICA PARA CONSTRUIR LIBROS (SIN DUPLICADOS)
  // ============================================================
  Widget _construirLibro(int index, Offset posicion) {
    int numeroEstacion = index + 1;
    bool estaDesbloqueado = numeroEstacion <= EstacionActual;
    
    String rutaImagen = estaDesbloqueado 
        ? "assets/avatar/libros_pila.png" 
        : "assets/avatar/libro_abierto.png";

    return Positioned(
      top: posicion.dy,
      left: posicion.dx,
      child: MouseRegion(
        cursor: estaDesbloqueado 
            ? SystemMouseCursors.click 
            : SystemMouseCursors.basic,
        child: GestureDetector(
          onTap: estaDesbloqueado 
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  ).then((_) => cargarProgreso());
                }
              : null,
          child: Opacity(
            opacity: estaDesbloqueado ? 1.0 : 0.4,
            child: Stack(
              children: [
                Image.asset(rutaImagen, width: 70),
                if (!estaDesbloqueado)
                  const Center(
                    child: Icon(Icons.lock, color: Colors.white, size: 25),
                  ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      "$numeroEstacion",
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int indicePersonaje = (EstacionActual - 1).clamp(0, posiciones.length - 1);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // BARRA SUPERIOR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(color: Colors.teal.shade50),
              child: Row(
                children: [
                  Image.asset("assets/avatar/bienvenido.png", width: 45),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text("Gramaticador", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                  IconButton(icon: const Icon(Icons.bar_chart), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StatsScreen()))),
                  IconButton(icon: const Icon(Icons.menu_book), onPressed: () {}),
                ],
              ),
            ),

            // ESTADÍSTICAS
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("❤️ $vidas", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(" $monedas", style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text("🔥 $racha", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            // MAPA CON SCROLL Y GENERADOR AUTOMÁTICO
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: double.infinity,
                  height: 1600,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/backgrounds/etapa_3.jpg",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 1600,
                      ),

                      AnimatedPositioned(
                        duration: const Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        top: posiciones[indicePersonaje].dy - 20,
                        left: posiciones[indicePersonaje].dx + 10,
                        child: Image.asset("assets/avatar/bienvenido.png", width: 50),
                      ),

                      Positioned(top: 150, right: 100, child: Image.asset("assets/avatar/cabana.png", width: 80)),
                      Positioned(top: 500, right: 100, child: Image.asset("assets/avatar/Chaman.png", width: 100)),
                      Positioned(top: 800, left: 100, child: Image.asset("assets/avatar/duende.png", width: 100)),
                      Positioned(top: 1100, left: 100, child: Image.asset("assets/avatar/marian.png", width: 100)),

                      // ✅ GENERADOR AUTOMÁTICO DE LOS 10 LIBROS
                      ...List.generate(posiciones.length, (index) => _construirLibro(index, posiciones[index])),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}