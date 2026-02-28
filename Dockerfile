# 1. Usamos Python 3.11 (Más moderno, Google ya no se queja)
FROM python:3.11-slim

# 2. Directorio de trabajo
WORKDIR /app

# 3. Copiamos e instalamos dependencias
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# 4. Copiamos el código
COPY . .

# 5. Creamos el usuario y... ¡LA MAGIA!
# Le damos permisos al usuario para escribir en la carpeta /app
RUN useradd -m -u 1000 user && \
    chown -R user:user /app && \
    chmod -R 777 /app

# 6. Cambiamos al usuario seguro
USER user

# 7. Variables de entorno
ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH

# 8. Puerto
EXPOSE 7860

# 9. Arrancamos
CMD ["gunicorn", "-b", "0.0.0.0:7860", "app:app"]