from flask import Flask, request, jsonify, render_template, send_from_directory
from flask_cors import CORS
import json
from datetime import datetime
import os

app = Flask(__name__)
CORS(app)

ARCHIVO_LOG = 'estadisticas.jsonl'

# Ruta 1: Landing Page
@app.route('/')
def home():
    return render_template('index.html')

# Ruta 2: API para recibir estadísticas
@app.route('/api/log', methods=['POST'])
def registrar_evento():
    try:
        datos = request.json
        datos['timestamp_servidor'] = datetime.now().isoformat()
        
        with open(ARCHIVO_LOG, 'a', encoding='utf-8') as f:
            f.write(json.dumps(datos, ensure_ascii=False) + '\n')
            
        return jsonify({"status": "ok"}), 200
    except Exception as e:
        return jsonify({"status": "error", "mensaje": str(e)}), 500

# Ruta 3: Servir el banco de preguntas (archivo pesado)
@app.route('/data/banco_preguntas.json')
def servir_banco():
    ruta_carpeta = os.path.join(app.root_path, 'static', 'data')
    # Servimos el archivo comprimido
    return send_from_directory(ruta_carpeta, 'banco_preguntas.json.gz', mimetype='application/gzip')

# Ruta 4: Servir el video
@app.route('/video/cham_intro.mp4')
def servir_video():
    return send_from_directory('static/videos', 'cham_intro.mp4')

# Ruta 5: Servir el build de Flutter Web
@app.route('/juego/')
@app.route('/juego/<path:filename>')
def servir_flutter(filename='index.html'):
    return send_from_directory('flutter_build', filename)

if __name__ == '__main__':
    app.run(debug=True, port=5000)