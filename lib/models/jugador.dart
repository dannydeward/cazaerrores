class Jugador {
  int vidas;
  int monedas;
  int puntos;
  int racha;

  int respuestasCorrectas;
  int respuestasIncorrectas;

  int expedicion;
  int rastro;
  //int estacion;

  Jugador({
    this.vidas = 3,
    this.monedas = 0,
    this.puntos = 0,
    this.racha = 0,
    this.respuestasCorrectas = 0,
    this.respuestasIncorrectas = 0,
    this.expedicion = 1,
    this.rastro = 1,
    //this.estacion = 1,
  });

  bool get sinVidas => vidas <= 0;

  void respuestaCorrecta() {
    puntos += 10;
    monedas += 1;
    respuestasCorrectas++;
    racha++;
  }

  void respuestaIncorrecta() {
    vidas--;
    respuestasIncorrectas++;
    racha = 0;
  }

  ///void avanzaEstacion() {
 //   estacion++;
  //}

void reiniciarLeccion() {
  vidas = 3;

  // NO borrar el progreso acumulado
  // puntos = 0;
  // respuestasCorrectas = 0;
  // respuestasIncorrectas = 0;
  // racha = 0;
}
}