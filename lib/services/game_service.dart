import '../models/jugador.dart'; // ✅ IMPORTACIÓN OBLIGATORIA

class GameService {
  late Jugador jugador;

  // Getters para acceso centralizado (Punto 6 del Resumen)
  int get vidas => jugador.vidas;
  int get monedas => jugador.monedas;
  int get puntos => jugador.puntos;
  int get racha => jugador.racha;
  int get correctas => jugador.correctas;
  int get incorrectas => jugador.incorrectas;
  
  // Getter especial para estado de juego
  bool get gameOver => jugador.sinVidas;
  
  // Propiedades adicionales requeridas por el flujo de aventura
  int get expedicion => jugador.expedicion;
  int get rastro => jugador.rastro;

  // Métodos delegados al modelo Jugador
  void respuestaCorrecta() {
    jugador.respuestaCorrecta();
  }

  void respuestaIncorrecta() {
    jugador.respuestaIncorrecta();
  }

  void reiniciarLeccion() {
    jugador.reiniciarLeccion();
  }
}