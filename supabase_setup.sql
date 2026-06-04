-- =====================================================
-- FYD CONTROL DE EQUIPOS - Schema para Supabase
-- Ejecutar en: Supabase Dashboard → SQL Editor
-- =====================================================

-- 1. TABLA ASESORES
CREATE TABLE IF NOT EXISTS asesores (
    id          BIGSERIAL PRIMARY KEY,
    cedula      VARCHAR(12)  UNIQUE NOT NULL,
    nombre      VARCHAR(200) NOT NULL,
    serial      VARCHAR(50)  UNIQUE NOT NULL,
    modelo      VARCHAR(100),
    activo      BOOLEAN      DEFAULT TRUE,
    created_at  TIMESTAMPTZ  DEFAULT NOW()
);

-- 2. TABLA MOVIMIENTOS
CREATE TABLE IF NOT EXISTS movimientos (
    id               BIGSERIAL PRIMARY KEY,
    id_asesor        BIGINT REFERENCES asesores(id) ON DELETE CASCADE,
    fecha            DATE        NOT NULL,
    hora_salida      TEXT,
    fecha_devolucion DATE,
    hora_devolucion  TEXT,
    estado           VARCHAR(50) DEFAULT 'Autorizado',
    notas            TEXT,
    incidencia       JSONB,
    created_at       TIMESTAMPTZ DEFAULT NOW()
);

-- 3. ÍNDICES para rendimiento
CREATE INDEX IF NOT EXISTS idx_mov_fecha      ON movimientos(fecha);
CREATE INDEX IF NOT EXISTS idx_mov_id_asesor  ON movimientos(id_asesor);
CREATE INDEX IF NOT EXISTS idx_mov_estado     ON movimientos(estado);

-- 4. ROW LEVEL SECURITY (RLS) — habilitado pero permisivo para la anon key
ALTER TABLE asesores    ENABLE ROW LEVEL SECURITY;
ALTER TABLE movimientos ENABLE ROW LEVEL SECURITY;

-- Políticas: permitir todas las operaciones con la anon key
-- (la seguridad de roles se controla en el frontend)
CREATE POLICY "Acceso total anon - asesores"
    ON asesores FOR ALL
    TO anon, authenticated
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Acceso total anon - movimientos"
    ON movimientos FOR ALL
    TO anon, authenticated
    USING (true)
    WITH CHECK (true);

-- 5. DATOS DE MUESTRA (opcional — borra este bloque si no lo necesitas)
INSERT INTO asesores (cedula, nombre, serial, modelo) VALUES
    ('1720478342', 'NICOLE ANDREA VÁSQUEZ LÓPEZ',    'C9D32ADQ',  'HP 240 G8'),
    ('1723776475', 'SANDRA MAYBEL ROSAS GARCÍA',     'F60K3J',    'Dell Latitude'),
    ('1712232233', 'ISMAEL JARA AGUILAR',            'C5M4C7DF',  'Lenovo IdeaPad'),
    ('1719300556', 'MATEO ANDRÉS PONCE HERRERA',     'DCY5M43D',  'HP Pavilion 15'),
    ('1725283344', 'CARLOS MARIO BANCO SOLANO',      'C5M57FD',   'Asus VivoBook'),
    ('1729008822', 'LUIS FERNANDO ORTIZ MEDINA',     'XW54881',   'Lenovo ThinkPad'),
    ('1765089221', 'MARÍA ISABEL FLORES REYES',      'H58QLMN',   'Dell Inspiron 15'),
    ('1702340122', 'DIANA CAROLINA RUEDA MORA',      'T9JK2PL',   'HP 250 G9'),
    ('1714566789', 'ROBERTO SEBASTIÁN MORA ÁVILA',   'GH44KNM',   'Acer Aspire 5'),
    ('1798123456', 'VALERIA SOFÍA CASTRO BENAVIDES', 'ZX77BRP',   'HP ProBook')
ON CONFLICT (cedula) DO NOTHING;

-- ✅ Verificar que las tablas se crearon correctamente
SELECT 'asesores' as tabla, count(*) as registros FROM asesores
UNION ALL
SELECT 'movimientos', count(*) FROM movimientos;
