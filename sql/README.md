# Scripts SQL

Ejecútalos **en orden**. Todos son repetibles (se pueden volver a correr sin romper nada).

| Orden | Archivo | Contenido |
|---|---|---|
| 0 | `00_extensiones.sql` | Extensión `pgvector` (solo para el RAG) |
| 1 | `01_tablas.sql` | Tablas `clientes`, `citas` y `peluqueria_documentos` (RAG) |
| 2 | `02_recordatorios.sql` | Columnas de control de recordatorios + consultas de referencia documentadas (comentadas) |

## Desde `psql`

```bash
psql -U postgres -d portafolio_peluqueria -f sql/00_extensiones.sql
psql -U postgres -d portafolio_peluqueria -f sql/01_tablas.sql
psql -U postgres -d portafolio_peluqueria -f sql/02_recordatorios.sql
```

## Desde n8n

Crea un flujo manual con un nodo **Postgres → Execute Query** y pega el contenido de cada script.

## Notas

- Las comparaciones de fecha/hora usan explícitamente `now() AT TIME ZONE 'America/Bogota'` en las consultas de los workflows de recordatorios y fidelidad, para no depender de la zona horaria del servidor.
- El contador de fidelidad (`contador_visitas`) solo sube cuando una cita se marca **completada** (workflow programado), nunca al agendar.
- **Esquema de columnas distinto al proyecto de barbería**: aquí es `estilista` (no `barbero`) y `hora_inicio`/`hora_fin` (no `fecha_hora_inicio`/`fecha_hora_fin`). Si clonas nodos Postgres Tool desde el proyecto de Mostacho Barbería, revisa cada Query una por una — un nombre de columna heredado del otro proyecto falla en el `INSERT`/`UPDATE` de forma silenciosa (sin que se vea en la conversación de WhatsApp), solo visible abriendo el nodo manualmente y usando "Execute step".
- La tabla `peluqueria_documentos` debe coincidir en nombre con la configurada en el nodo "Postgres PGVector Store" del workflow de carga del RAG, y la dimensión de `embedding` con la del modelo de embeddings usado (ajusta `VECTOR(768)` si usas otro modelo).
