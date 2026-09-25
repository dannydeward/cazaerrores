import gzip
import shutil
import os

# Ruta al archivo original
origen = 'static/data/banco_preguntas.json'
destino = 'static/data/banco_preguntas.json.gz'

if os.path.exists(origen):
    tamaño_original = os.path.getsize(origen)
    print(f"📦 Comprimiendo {origen} ({tamaño_original / 1024 / 1024:.1f} MB)...")
    
    with open(origen, 'rb') as f_in:
        with gzip.open(destino, 'wb') as f_out:
            shutil.copyfileobj(f_in, f_out)
    
    tamaño_comprimido = os.path.getsize(destino)
    print(f"✅ ¡Listo! Tamaño comprimido: {tamaño_comprimido / 1024 / 1024:.1f} MB")
    print(f"📉 Reducción: {((1 - tamaño_comprimido / tamaño_original) * 100):.0f}%")
else:
    print(f"❌ No se encontró el archivo en: {origen}")