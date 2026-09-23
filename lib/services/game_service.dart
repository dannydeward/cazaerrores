import '../models/jugador.dart';

class GameService {
    Jugador jugador = Jugador();

  void respuestaCorrecta() {
    jugador.respuestaCorrecta();
  }

  void respuestaIncorrecta() {
    jugador.respuestaIncorrecta();
  }

  ///void siguienteEstacion() {
//    jugador.avanzaEstacion();
 // }

  void reiniciarLeccion() {
    jugador.reiniciarLeccion();
  }

  bool get gameOver => jugador.sinVidas;

  int get vidas => jugador.vidas;
  int get monedas => jugador.monedas;
  int get puntos => jugador.puntos;
  int get racha => jugador.racha;

  int get correctas => jugador.respuestasCorrectas;
  int get incorrectas => jugador.respuestasIncorrectas;

  int get expedicion => jugador.expedicion;
  int get rastro => jugador.rastro;
  //int get Estacion => jugador.Estacion;
}