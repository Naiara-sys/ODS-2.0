CREATE TABLE ods_original (
    id_ods_original NUMBER PRIMARY KEY,
    nombre VARCHAR2(100) NOT NULL,
    descripcion VARCHAR2(500) NOT NULL
);

CREATE TABLE ods_2 (
    id_ods2 NUMBER PRIMARY KEY,
    id_ods_original NUMBER NOT NULL,
    nombre VARCHAR2(150) NOT NULL,
    descripcion VARCHAR2(600),
    estado VARCHAR2(20) DEFAULT 'BORRADOR',
CONSTRAINT fk_ods2_original FOREIGN KEY (id_ods_original) REFERENCES ods_original(id_ods_original),
CONSTRAINT chk_estado_ods2 CHECK (estado IN ('BORRADOR', 'REVISION', 'APROBADO'))
);

CREATE TABLE metrica (
    id_metrica NUMBER PRIMARY KEY,
    id_ods2 NUMBER NOT NULL,
    nombre VARCHAR2(100) NOT NULL,
    unidad VARCHAR2(50),
    valor_objetivo NUMBER NOT NULL,
CONSTRAINT fk_metrica_ods2 FOREIGN KEY (id_ods2) REFERENCES ods_2(id_ods2)
);

CREATE TABLE evidencia (
    id_evidencia NUMBER PRIMARY KEY,
    id_ods2 NUMBER NOT NULL,
    descripcion VARCHAR2(300),
    fuente VARCHAR2(200),
    fiabilidad NUMBER NOT NULL,
CONSTRAINT fk_evidencia_ods2 FOREIGN KEY (id_ods2) REFERENCES ods_2(id_ods2),
CONSTRAINT chk_fiabilidad CHECK (fiabilidad BETWEEN 0 AND 5)
);

CREATE TABLE viabilidad (
    id_viabilidad NUMBER PRIMARY KEY,
    id_ods2 NUMBER NOT NULL,
    impacto NUMBER NOT NULL,
    coste NUMBER NOT NULL,
    tiempo NUMBER NOT NULL,
    riesgo NUMBER NOT NULL,
    puntuacion_final NUMBER,
CONSTRAINT fk_viabilidad_ods2 FOREIGN KEY (id_ods2)REFERENCES ods_2(id_ods2),
CONSTRAINT chk_criterios
        CHECK (
            impacto BETWEEN 0 AND 10 AND
            coste   BETWEEN 0 AND 10 AND
            tiempo  BETWEEN 0 AND 10 AND
            riesgo  BETWEEN 0 AND 10
        )
);

CREATE TABLE historial_estados (
    id_historial NUMBER PRIMARY KEY,
    id_ods2 NUMBER NOT NULL,
    estado_anterior VARCHAR2(20),
    estado_nuevo VARCHAR2(20),
    fecha_cambio DATE DEFAULT SYSDATE,
CONSTRAINT fk_historial_ods2 FOREIGN KEY (id_ods2) REFERENCES ods_2(id_ods2)
);

SELECT table_name FROM user_tables;