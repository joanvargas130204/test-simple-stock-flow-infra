# Simple Stock Flow — Infraestructura Docker

Orquestación de contenedores para **Simple Stock Flow** mediante Docker Compose.

---

## 📦 Servicios Orquestados

1. **`db`** — MySQL 8.4 LTS
   - Base de datos: `stockflow`
   - Usuario: `stockflow`
   - Colación: `utf8mb4_0900_ai_ci`
   - Zona horaria: `+00:00` (UTC)
   - Volumen persistente: `db_data`

2. **`api`** — Backend Laravel 11 en Onion Architecture
   - Expuesto internamente en el puerto `8000`
   - Espera a que `db` esté en estado *healthy* antes de iniciar
   - Aplica migraciones automáticamente al arrancar
   - Volumen compartido de medios: `media_data`

3. **`app`** — Frontend React 19 + Nginx
   - Publicado en el puerto host `8080:80`
   - Reverse proxy para `/api/` y `^~ /media/` hacia `api:8000`
   - `client_max_body_size 6m`

---

## 🚀 Puesta en Marcha

```bash
# 1. Clonar los repositorios hermanos en el mismo directorio raíz
# 2. Levantar los 3 servicios con build
docker compose up --build -d

# 3. Comprobar el estado de los contenedores
docker compose ps

# 4. Ejecutar el script de verificación
bash verify.sh
```

Para desarrollo local exponiendo los puertos `3306` (MySQL) y `8000` (API):
```bash
docker compose -f docker-compose.yml -f docker-compose.dev.yml up -d
```
