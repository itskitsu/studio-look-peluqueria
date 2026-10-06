# Workflows de n8n

Aquí van los flujos exportados desde n8n (un `.json` por flujo):

| Archivo | Flujo |
|---|---|
| `agente-principal.json` | Agente principal (WhatsApp) — "Agente Studio Look" |
| `consultar-disponibilidad.json` | Sub-workflow "peluquería - Consultar Disponibilidad" (4 estilistas) |
| `recordatorios.json` | "peluquería - Recordatorios de citas" (24h y 2h) |
| `completar-citas-fidelidad.json` | "Completar citas y fidelidad" |
| `cargar-base-de-conocimiento.json` | Carga de `docs/base-de-conocimiento.md` al Vector Store (Postgres + pgvector) |
| `setup-sql.json` | Ejecuta los scripts de [`sql/`](../sql/) (opcional: también puedes usar `psql`) |

## Cómo exportar un flujo

1. Abre el flujo en n8n.
2. Menú **⋯** (arriba a la derecha) → **Download**.
3. Renombra el archivo y guárdalo en esta carpeta.

## Antes de subirlos a GitHub

- Los `.json` **no** guardan el contenido de las credenciales (solo su nombre e id), pero revísalos igualmente: busca con el buscador de tu editor `token`, `apiKey`, `password`, el Access Token de WhatsApp y el Business Account ID reales.
- Reemplaza cualquier **número de teléfono real de clientes de prueba** que haya quedado pineado en algún nodo por un marcador como `TU_NUMERO_DE_PRUEBA`.
- Si algún nodo tiene datos de clientes reales (nombre, teléfono, cédula) guardados como datos fijos/pinned, quítalos.

## Cómo importarlos

1. En n8n: **Workflows → Import from File**.
2. Asigna tus propias credenciales (WhatsApp Business API, Anthropic, Google Calendar, Google Gemini, Postgres) en los nodos que lo pidan.
3. En *Settings* de cada flujo, zona horaria `America/Bogota` (o la de tu negocio).
4. Configura también las variables de entorno `GENERIC_TIMEZONE` y `TZ` en el propio servicio de n8n.
5. En el sub-workflow de disponibilidad, revisa que la lista `ESTILISTAS` en el nodo de código coincida con tu propio equipo.
6. Publica el workflow principal y registra la URL de producción del webhook en el panel de Meta (WhatsApp → Configuration → Callback URL).
7. Si vas a probar el webhook con una petición simulada antes de tener mensajes reales de WhatsApp, usa "Listen for test event" + una petición POST real (con el cuerpo tal cual lo manda Meta, **sin** envolverlo en `"body"`) en vez del "set mock data" del nodo — el mock data no distingue la rama GET de la POST.
