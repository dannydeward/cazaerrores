class Jugador {
  int vidas;
  int monedas;
  int puntos;
  int racha;
  int correctas;
  int incorrectas;
  int estacion;
  
  // Propiedades adicionales requeridas por GameService
  int expedicion; 
  int rastro;     

  Jugador({
    this.vidas = 3,
    this.monedas = 0,
    this.puntos = 0,
    this.racha = 0,
    this.correctas = 0,
    this.incorrectas = 0,
    this.estacion = 1,
    this.expedicion = 0,
    this.rastro = 0,
  });

  // Getter requerido por GameService.gameOver
  bool get sinVidas => vidas <= 0;

  void respuestaCorrecta() {
    puntos += 10;
    monedas++;
    correctas++;
    racha++;
  }

  void respuestaIncorrecta() {
    if (vidas > 0) vidas--;
    incorrectas++;
    racha = 0;
  }

  // Método requerido por GameService
  void reiniciarLeccion() {
    racha = 0;
    // Nota: Según punto 6 del resumen, NO borra puntos ni estadísticas acumuladas
  }
}