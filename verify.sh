#!/usr/bin/env bash
set -e

BASE_URL="http://localhost:8080"
echo "=========================================================="
echo "    Verificando Despliegue de Simple Stock Flow           "
echo "=========================================================="

echo "1. Probando Healthcheck de la API..."
HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health || curl -s -o /dev/null -w "%{http_code}" ${BASE_URL}/health || echo "000")
echo "   Status Healthcheck: $HEALTH"

echo "2. Probando inicio de sesión Admin..."
LOGIN_RESP=$(curl -s -X POST ${BASE_URL}/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin@stockflow.local","password":"AdminSecretPassword123!"}')

TOKEN=$(echo $LOGIN_RESP | grep -o '"accessToken":"[^"]*' | grep -o '[^"]*$')

if [ -z "$TOKEN" ]; then
  echo "   [ERROR] No se pudo obtener el token JWT."
  echo "   Respuesta: $LOGIN_RESP"
else
  echo "   [OK] Token JWT obtenido exitosamente."
  
  echo "3. Consultando categorías sembradas..."
  CATEGORIES=$(curl -s -H "Authorization: Bearer $TOKEN" ${BASE_URL}/api/categories)
  echo "   Categorías: $CATEGORIES"

  echo "4. Consultando catálogo de productos..."
  PRODUCTS=$(curl -s -H "Authorization: Bearer $TOKEN" "${BASE_URL}/api/products?page=1&size=20")
  echo "   Productos: $PRODUCTS"

  echo "5. Verificando respuesta 404 de recurso inexistente con 0 bytes..."
  MEDIA_404_BYTES=$(curl -s -w "%{size_download}" -o /dev/null ${BASE_URL}/media/non-existent-image.jpg)
  echo "   Bytes recibidos en 404: $MEDIA_404_BYTES (Debe ser 0)"
fi

echo "=========================================================="
echo "    Verificación completada.                              "
echo "=========================================================="
