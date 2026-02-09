-- ============================================================================
-- SPRINT 5: PRUEBAS DE PROCEDIMIENTOS Y FUNCIONES
-- Archivo: 06_pruebas.sql
-- Descripción: Casos de prueba para validar el correcto funcionamiento de los
--              3 procedimientos y funciones implementados en 05_proced_func.sql
-- ============================================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 100;

PROMPT ============================================================================
PROMPT              BATERÍA DE PRUEBAS DE PROCEDIMIENTOS Y FUNCIONES
PROMPT ============================================================================
PROMPT

-- ============================================================================
-- PRUEBA 1: PROCEDIMIENTO INSERTAR_ODS2 - CASO EXITOSO
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 1: INSERTAR_ODS2 - Insertar un nuevo ODS 2.0 válido
PROMPT ============================================================================
PROMPT Resultado esperado: Debe insertar correctamente y mostrar mensaje de éxito
PROMPT

DECLARE
    v_count_before NUMBER;
    v_count_after NUMBER;
    v_new_id NUMBER;
BEGIN
    -- Contar registros antes
    SELECT COUNT(*) INTO v_count_before FROM ods_2;

    -- Ejecutar procedimiento
    insertar_ods2(1, 'Nuevo ODS de prueba', 'Descripción de prueba para validación', 'usuario_test');

    -- Contar registros después
    SELECT COUNT(*) INTO v_count_after FROM ods_2;

    -- Verificar que se insertó
    IF v_count_after = v_count_before + 1 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Registro insertado correctamente');
        DBMS_OUTPUT.PUT_LINE('  - Registros antes: ' || v_count_before);
        DBMS_OUTPUT.PUT_LINE('  - Registros después: ' || v_count_after);

        -- Obtener el ID del nuevo registro
        SELECT MAX(id_ods2) INTO v_new_id FROM ods_2;
        DBMS_OUTPUT.PUT_LINE('  - Nuevo ID: ' || v_new_id);
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: No se insertó el registro');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 2: PROCEDIMIENTO INSERTAR_ODS2 - CASO DE ERROR
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 2: INSERTAR_ODS2 - Intentar insertar con ODS original inexistente
PROMPT ============================================================================
PROMPT Resultado esperado: Debe capturar error de foreign key
PROMPT

DECLARE
    v_count_before NUMBER;
    v_count_after NUMBER;
BEGIN
    -- Contar registros antes
    SELECT COUNT(*) INTO v_count_before FROM ods_2;

    -- Intentar insertar con ID inexistente
    insertar_ods2(999, 'ODS inválido', 'Descripción inválida', 'usuario_test');

    -- Si llega aquí, falló
    DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: No se capturó el error esperado');

EXCEPTION
    WHEN OTHERS THEN
        -- Contar registros después
        SELECT COUNT(*) INTO v_count_after FROM ods_2;

        IF v_count_after = v_count_before THEN
            DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Error capturado correctamente - ' || SQLERRM);
            DBMS_OUTPUT.PUT_LINE('  - No se insertó registro inválido');
        ELSE
            DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Se insertó registro a pesar del error');
        END IF;
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 3: FUNCIÓN CONTAR_METRICAS_ODS2 - CON MÉTRICAS
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 3: CONTAR_METRICAS_ODS2 - Contar métricas de ODS 2.0 existente (ID 101)
PROMPT ============================================================================
PROMPT Resultado esperado: Debe retornar TRUE y total_metricas = 3
PROMPT

DECLARE
    v_result BOOLEAN;
    v_total_metricas NUMBER;
    v_expected NUMBER := 3;
BEGIN
    -- Ejecutar función
    v_result := contar_metricas_ods2(101, v_total_metricas);

    DBMS_OUTPUT.PUT_LINE('Resultado: ' || CASE WHEN v_result THEN 'TRUE' ELSE 'FALSE' END);
    DBMS_OUTPUT.PUT_LINE('Total métricas: ' || v_total_metricas);

    IF v_result = TRUE AND v_total_metricas = v_expected THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Función retornó valores correctos');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Valores incorrectos');
        DBMS_OUTPUT.PUT_LINE('  - Esperado: TRUE, ' || v_expected);
        DBMS_OUTPUT.PUT_LINE('  - Obtenido: ' || CASE WHEN v_result THEN 'TRUE' ELSE 'FALSE' END || ', ' || v_total_metricas);
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 4: FUNCIÓN CONTAR_METRICAS_ODS2 - SIN MÉTRICAS
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 4: CONTAR_METRICAS_ODS2 - Contar métricas de ODS 2.0 sin métricas
PROMPT ============================================================================
PROMPT Resultado esperado: Debe retornar FALSE y total_metricas = 0
PROMPT

DECLARE
    v_result BOOLEAN;
    v_total_metricas NUMBER;
    v_new_ods_id NUMBER;
BEGIN
    -- Crear un ODS 2.0 sin métricas
    INSERT INTO ods_2 (id_ods_original, nombre, descripcion, usuario_creador)
    VALUES (1, 'ODS sin métricas', 'Para prueba de función', 'test')
    RETURNING id_ods2 INTO v_new_ods_id;

    -- Ejecutar función
    v_result := contar_metricas_ods2(v_new_ods_id, v_total_metricas);

    DBMS_OUTPUT.PUT_LINE('Resultado: ' || CASE WHEN v_result THEN 'TRUE' ELSE 'FALSE' END);
    DBMS_OUTPUT.PUT_LINE('Total métricas: ' || v_total_metricas);

    IF v_result = FALSE AND v_total_metricas = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Función retornó valores correctos');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Valores incorrectos');
        DBMS_OUTPUT.PUT_LINE('  - Esperado: FALSE, 0');
        DBMS_OUTPUT.PUT_LINE('  - Obtenido: ' || CASE WHEN v_result THEN 'TRUE' ELSE 'FALSE' END || ', ' || v_total_metricas);
    END IF;

    -- Limpiar
    DELETE FROM ods_2 WHERE id_ods2 = v_new_ods_id;
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 5: PROCEDIMIENTO ACTUALIZAR_ESTADO_ODS2 - CASO EXITOSO
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 5: ACTUALIZAR_ESTADO_ODS2 - Cambiar estado de BORRADOR a REVISION
PROMPT ============================================================================
PROMPT Resultado esperado: Debe actualizar estado y registrar en historial
PROMPT

DECLARE
    v_estado_anterior VARCHAR2(20);
    v_estado_nuevo VARCHAR2(20);
    v_historial_count_before NUMBER;
    v_historial_count_after NUMBER;
BEGIN
    -- Obtener estado actual
    SELECT estado INTO v_estado_anterior FROM ods_2 WHERE id_ods2 = 101;

    -- Contar registros en historial antes
    SELECT COUNT(*) INTO v_historial_count_before FROM historial_estados WHERE id_ods2 = 101;

    -- Ejecutar procedimiento
    actualizar_estado_ods2(101, 'REVISION', 'usuario_test', 'Cambio para prueba');

    -- Verificar estado nuevo
    SELECT estado INTO v_estado_nuevo FROM ods_2 WHERE id_ods2 = 101;

    -- Contar registros en historial después
    SELECT COUNT(*) INTO v_historial_count_after FROM historial_estados WHERE id_ods2 = 101;

    IF v_estado_nuevo = 'REVISION' AND v_historial_count_after = v_historial_count_before + 1 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Estado actualizado y registrado en historial');
        DBMS_OUTPUT.PUT_LINE('  - Estado anterior: ' || v_estado_anterior);
        DBMS_OUTPUT.PUT_LINE('  - Estado nuevo: ' || v_estado_nuevo);
        DBMS_OUTPUT.PUT_LINE('  - Registros historial: ' || v_historial_count_before || ' → ' || v_historial_count_after);
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Actualización incorrecta');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 6: PROCEDIMIENTO ACTUALIZAR_ESTADO_ODS2 - CASO DE ERROR
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 6: ACTUALIZAR_ESTADO_ODS2 - Intentar actualizar ODS inexistente
PROMPT ============================================================================
PROMPT Resultado esperado: Debe capturar error NO_DATA_FOUND
PROMPT

DECLARE
    v_historial_count_before NUMBER;
    v_historial_count_after NUMBER;
BEGIN
    -- Contar registros en historial antes
    SELECT COUNT(*) INTO v_historial_count_before FROM historial_estados;

    -- Intentar actualizar ODS inexistente
    actualizar_estado_ods2(999, 'APROBADO', 'usuario_test', 'Prueba error');

    -- Si llega aquí, falló
    DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: No se capturó el error esperado');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Contar registros en historial después
        SELECT COUNT(*) INTO v_historial_count_after FROM historial_estados;

        IF v_historial_count_after = v_historial_count_before THEN
            DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Error NO_DATA_FOUND capturado correctamente');
            DBMS_OUTPUT.PUT_LINE('  - No se modificó el historial');
        ELSE
            DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Se modificó el historial a pesar del error');
        END IF;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Error inesperado - ' || SQLERRM);
END;
/

PROMPT

-- ============================================================================
-- PRUEBA 7: VERIFICACIÓN FINAL DEL ESTADO
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 7: Verificación final del estado de la base de datos
PROMPT ============================================================================

SELECT 'Tabla' AS tipo, 'Registros' AS detalle FROM dual
UNION ALL
SELECT '-----', '----------' FROM dual
UNION ALL
SELECT 'ODS_ORIGINAL', TO_CHAR(COUNT(*)) FROM ods_original
UNION ALL
SELECT 'ODS_2', TO_CHAR(COUNT(*)) FROM ods_2
UNION ALL
SELECT 'METRICA', TO_CHAR(COUNT(*)) FROM metrica
UNION ALL
SELECT 'EVIDENCIA', TO_CHAR(COUNT(*)) FROM evidencia
UNION ALL
SELECT 'VIABILIDAD', TO_CHAR(COUNT(*)) FROM viabilidad
UNION ALL
SELECT 'HISTORIAL_ESTADOS', TO_CHAR(COUNT(*)) FROM historial_estados;

PROMPT
PROMPT Estados de ODS 2.0:
SELECT id_ods2, nombre, estado, usuario_creador
FROM ods_2
ORDER BY id_ods2;

PROMPT
PROMPT ============================================================================
PROMPT                FIN DE LAS PRUEBAS DE PROCEDIMIENTOS Y FUNCIONES
PROMPT ============================================================================
PROMPT Resumen:
PROMPT - Prueba 1: Insertar ODS 2.0 válido
PROMPT - Prueba 2: Insertar ODS 2.0 inválido (error FK)
PROMPT - Prueba 3: Contar métricas de ODS con métricas
PROMPT - Prueba 4: Contar métricas de ODS sin métricas
PROMPT - Prueba 5: Actualizar estado válido
PROMPT - Prueba 6: Actualizar estado de ODS inexistente
PROMPT - Prueba 7: Verificación final del estado
PROMPT ============================================================================