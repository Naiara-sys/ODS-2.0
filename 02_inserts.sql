-- =====================================================
-- INSERTS DE DATOS
-- =====================================================

-- ODS_ORIGINAL
INSERT INTO ods_original (id_ods_original, numero_ods, nombre, descripcion)
VALUES (1, 4, 'ODS 4 - Educación de calidad', 'Garantizar una educación inclusiva, equitativa y de calidad.');

INSERT INTO ods_original (id_ods_original, numero_ods, nombre, descripcion)
VALUES (2, 12, 'ODS 12 - Producción y consumo responsables', 'Garantizar modalidades de consumo y producción sostenibles.');

-- ODS_2
INSERT INTO ods_2 (id_ods2, id_ods_original, nombre, descripcion, estado)
VALUES (101, 1, 'Acceso digital educativo medible', 'Mejorar el acceso real a recursos digitales en centros educativos.', 'BORRADOR');

INSERT INTO ods_2 (id_ods2, id_ods_original, nombre, descripcion, estado)
VALUES (102, 2, 'Reducción medible de residuos tecnológicos', 'Reducir el impacto ambiental del residuo electrónico.', 'BORRADOR');

-- METRICA
INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (1, 101, 'Aulas con internet funcional', '%', 95);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (2, 101, 'Dispositivos por alumno', 'ratio', 1);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (3, 101, 'Profesorado con formación digital certificada', '%', 80);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (4, 102, 'Residuos electrónicos reciclados', 'kg/año', 500);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (5, 102, 'Dispositivos reutilizados', '%', 40);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo)
VALUES (6, 102, 'Vida media de dispositivos', 'años', 5);

-- EVIDENCIA
INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad)
VALUES (1, 101, 'Informe de conectividad educativa', 'Ministerio de Educación', 4);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad)
VALUES (2, 101, 'Auditoría TIC de centros públicos', 'Consejería autonómica', 3);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad)
VALUES (3, 102, 'Certificado oficial de reciclaje electrónico', 'Empresa gestora autorizada', 5);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad)
VALUES (4, 102, 'Informe interno de inventario tecnológico', 'Departamento TIC', 3);

-- VIABILIDAD
INSERT INTO viabilidad (id_viabilidad, id_ods2, impacto, coste, tiempo, riesgo, puntuacion_final)
VALUES (1, 101, 8, 5, 6, 4, NULL);

INSERT INTO viabilidad (id_viabilidad, id_ods2, impacto, coste, tiempo, riesgo, puntuacion_final)
VALUES (2, 102, 7, 4, 5, 3, NULL);

COMMIT;
