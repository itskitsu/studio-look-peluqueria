-- Tablas principales del proyecto Studio Look.
-- Repetible: usa IF NOT EXISTS, se puede volver a correr sin romper nada.

CREATE TABLE IF NOT EXISTS clientes (
    telefono                   TEXT PRIMARY KEY,
    nombre                     TEXT,
    cedula                     TEXT,
    fecha_nacimiento           DATE,
    membresia_premium          BOOLEAN NOT NULL DEFAULT false,
    contador_visitas           INTEGER NOT NULL DEFAULT 0,
    servicio_gratis_disponible BOOLEAN NOT NULL DEFAULT false,
    created_at                 TIMESTAMP NOT NULL DEFAULT now(),
    updated_at                 TIMESTAMP NOT NULL DEFAULT now()
);

-- Nota: a diferencia del proyecto de barbería, aquí la columna se llama
-- `estilista` (no `barbero`), y las horas se llaman `hora_inicio`/`hora_fin`
-- (no `fecha_hora_inicio`/`fecha_hora_fin`) — revisa que las Queries de los
-- nodos Postgres Tool usen exactamente estos nombres tras clonar o migrar
-- el proyecto desde otro negocio (ver README, sección de lecciones).
CREATE TABLE IF NOT EXISTS citas (
    id                          SERIAL PRIMARY KEY,
    telefono                    TEXT NOT NULL REFERENCES clientes(telefono),
    servicio                    TEXT NOT NULL,
    estilista                   TEXT NOT NULL,
    hora_inicio                 TIMESTAMP NOT NULL,
    hora_fin                    TIMESTAMP NOT NULL,
    es_gratis                   BOOLEAN NOT NULL DEFAULT false,
    estado                      TEXT NOT NULL DEFAULT 'agendada', -- agendada | completada | cancelada
    calendar_event_id           TEXT,
    recordatorio_24h_enviado    BOOLEAN NOT NULL DEFAULT false,
    recordatorio_2h_enviado     BOOLEAN NOT NULL DEFAULT false,
    created_at                  TIMESTAMP NOT NULL DEFAULT now()
);

-- Documentos del RAG (cargados por el workflow de carga de base de conocimiento).
-- El nombre de tabla debe coincidir con el configurado en el nodo "Postgres PGVector Store".
CREATE TABLE IF NOT EXISTS peluqueria_documentos (
    id         SERIAL PRIMARY KEY,
    content    TEXT,
    metadata   JSONB,
    embedding  VECTOR(768) -- ajusta la dimensión a la del modelo de embeddings que uses
);

CREATE INDEX IF NOT EXISTS idx_citas_telefono ON citas(telefono);
CREATE INDEX IF NOT EXISTS idx_citas_estado ON citas(estado);
