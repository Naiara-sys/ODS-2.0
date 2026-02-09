-- =====================================================
-- INSERTS CON TODOS LOS CAMPOS
-- =====================================================

-- ODS_ORIGINAL
INSERT INTO ods_original (id_ods_original, numero_ods, nombre, descripcion, fecha_registro)
VALUES (1, 4, 'ODS 4 - Educación de calidad', 'Garantizar una educación inclusiva, equitativa y de calidad.', CURRENT_TIMESTAMP);

INSERT INTO ods_original (id_ods_original, numero_ods, nombre, descripcion, fecha_registro)
VALUES (2, 12, 'ODS 12 - Producción y consumo responsables', 'Garantizar modalidades de consumo y producción sostenibles.', CURRENT_TIMESTAMP);

-- ODS_2
INSERT INTO ods_2 (id_ods2, id_ods_original, nombre, descripcion, estado, fecha_creacion, fecha_modificacion, usuario_creador)
VALUES (101, 1, 'Acceso digital educativo medible', 'Mejorar el acceso real a recursos digitales en centros educativos.', 'BORRADOR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'sistema');

INSERT INTO ods_2 (id_ods2, id_ods_original, nombre, descripcion, estado, fecha_creacion, fecha_modificacion, usuario_creador)
VALUES (102, 2, 'Reducción medible de residuos tecnológicos', 'Reducir el impacto ambiental del residuo electrónico.', 'BORRADOR', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, 'sistema');

-- METRICA
INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (1, 101, 'Aulas con internet funcional', '%', 95, 0, NULL);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (2, 101, 'Dispositivos por alumno', 'ratio', 1, 0, NULL);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (3, 101, 'Profesorado con formación digital certificada', '%', 80, 0, NULL);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (4, 102, 'Residuos electrónicos reciclados', 'kg/año', 500, 0, NULL);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (5, 102, 'Dispositivos reutilizados', '%', 40, 0, NULL);

INSERT INTO metrica (id_metrica, id_ods2, nombre, unidad, valor_objetivo, valor_actual, fecha_objetivo)
VALUES (6, 102, 'Vida media de dispositivos', 'años', 5, 0, NULL);

-- EVIDENCIA
INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad, tipo_fuente, fecha_publicacion, url)
VALUES (1, 101, 'Informe de conectividad educativa', 'Ministerio de Educación', 4, 'Informe oficial', NULL, NULL);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad, tipo_fuente, fecha_publicacion, url)
VALUES (2, 101, 'Auditoría TIC de centros públicos', 'Consejería autonómica', 3, 'Informe oficial', NULL, NULL);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad, tipo_fuente, fecha_publicacion, url)
VALUES (3, 102, 'Certificado oficial de reciclaje electrónico', 'Empresa gestora autorizada', 5, 'Informe oficial', NULL, NULL);

INSERT INTO evidencia (id_evidencia, id_ods2, descripcion, fuente, fiabilidad, tipo_fuente, fecha_publicacion, url)
VALUES (4, 102, 'Informe interno de inventario tecnológico', 'Departamento TIC', 3, 'Estudio', NULL, NULL);

-- VIABILIDAD
INSERT INTO viabilidad (id_viabilidad, id_ods2, impacto, coste, tiempo, riesgo, puntuacion_final, fecha_evaluacion, evaluador, observaciones)
VALUES (1, 101, 8, 5, 6, 4, NULL, CURRENT_TIMESTAMP, NULL, NULL);

INSERT INTO viabilidad (id_viabilidad, id_ods2, impacto, coste, tiempo, riesgo, puntuacion_final, fecha_evaluacion, evaluador, observaciones)
VALUES (2, 102, 7, 4, 5, 3, NULL, CURRENT_TIMESTAMP, NULL, NULL);

COMMIT;
