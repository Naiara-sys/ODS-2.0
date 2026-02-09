-- ============================================================================
-- SPRINT 3: PRUEBAS DE CURSORES
-- Archivo: 04_pruebas.sql
-- Descripción: Casos de prueba para validar el correcto funcionamiento de los
--              3 cursores implementados en 03_cursores.sql
-- ============================================================================

SET SERVEROUTPUT ON;
SET LINESIZE 200;
SET PAGESIZE 100;

PROMPT ============================================================================
PROMPT                    BATERÍA DE PRUEBAS DE CURSORES
PROMPT ============================================================================
PROMPT 

-- ============================================================================
-- PRUEBA 1: CURSOR IMPLÍCITO - CASO EXITOSO
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 1: CURSOR IMPLÍCITO - Recuperar ODS 2.0 existente (ID 101)
PROMPT ============================================================================
PROMPT Resultado esperado: Debe mostrar la ficha completa del ODS 2.0 con ID 101
PROMPT 

DECLARE
    v_ods2 ods_2%ROWTYPE;
BEGIN
    SELECT *
    INTO v_ods2
    FROM ods_2
    WHERE id_ods2 = 101;

    DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA');
    DBMS_OUTPUT.PUT_LINE('ID          : ' || v_ods2.id_ods2);
    DBMS_OUTPUT.PUT_LINE('Nombre      : ' || v_ods2.nombre);
    DBMS_OUTPUT.PUT_LINE('Estado      : ' || v_ods2.estado);
    DBMS_OUTPUT.PUT_LINE('Usuario     : ' || v_ods2.usuario_creador);
    
    IF v_ods2.id_ods2 = 101 AND v_ods2.nombre IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('✓ Test 1.1: Registro recuperado correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ Test 1.1: ERROR - Datos incorrectos');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: No se encontró el registro');
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Se encontraron múltiples registros');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 2: CURSOR IMPLÍCITO - CASO DE ERROR
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 2: CURSOR IMPLÍCITO - Intentar recuperar ODS 2.0 inexistente (ID 999)
PROMPT ============================================================================
PROMPT Resultado esperado: Debe capturar la excepción NO_DATA_FOUND
PROMPT 

DECLARE
    v_ods2 ods_2%ROWTYPE;
BEGIN
    SELECT *
    INTO v_ods2
    FROM ods_2
    WHERE id_ods2 = 999;

    DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Se recuperó un registro que no debería existir');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Excepción NO_DATA_FOUND capturada correctamente');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Excepción inesperada ' || SQLERRM);
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 3: CURSOR EXPLÍCITO - VERIFICAR RECORRIDO
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 3: CURSOR EXPLÍCITO - Recorrer todos los ODS 2.0
PROMPT ============================================================================
PROMPT Resultado esperado: Debe listar 2 ODS con sus métricas y evidencias
PROMPT 

DECLARE
    CURSOR c_ods IS
        SELECT o2.id_ods2, o2.nombre, o2.estado, oo.nombre AS ods_original
        FROM ods_2 o2
        JOIN ods_original oo ON o2.id_ods_original = oo.id_ods_original;
    
    v_num_metricas NUMBER;
    v_num_evidencias NUMBER;
    v_contador NUMBER := 0;
BEGIN
    FOR ods IN c_ods LOOP
        v_contador := v_contador + 1;
        
        DBMS_OUTPUT.PUT_LINE('--- ODS 2.0 #' || v_contador || ' ---');
        DBMS_OUTPUT.PUT_LINE('ID: ' || ods.id_ods2);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || ods.nombre);
        DBMS_OUTPUT.PUT_LINE('ODS original: ' || ods.ods_original);
        
        -- Contar métricas
        SELECT COUNT(*) INTO v_num_metricas
        FROM metrica WHERE id_ods2 = ods.id_ods2;
        
        -- Contar evidencias
        SELECT COUNT(*) INTO v_num_evidencias
        FROM evidencia WHERE id_ods2 = ods.id_ods2;
        
        DBMS_OUTPUT.PUT_LINE('Métricas: ' || v_num_metricas);
        DBMS_OUTPUT.PUT_LINE('Evidencias: ' || v_num_evidencias);
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    IF v_contador = 2 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Se procesaron ' || v_contador || ' registros (esperado: 2)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Se procesaron ' || v_contador || ' registros (esperado: 2)');
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 4: CURSOR EXPLÍCITO - VERIFICAR CONTEO DE MÉTRICAS
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 4: CURSOR EXPLÍCITO - Verificar conteo de métricas por ODS
PROMPT ============================================================================
PROMPT Resultado esperado: ODS 101 debe tener 3 métricas, ODS 102 debe tener 4
PROMPT 

DECLARE
    CURSOR c_ods IS
        SELECT o2.id_ods2, o2.nombre
        FROM ods_2 o2
        ORDER BY o2.id_ods2;
    
    v_num_metricas NUMBER;
    v_test_ok BOOLEAN := TRUE;
BEGIN
    FOR ods IN c_ods LOOP
        SELECT COUNT(*) INTO v_num_metricas
        FROM metrica WHERE id_ods2 = ods.id_ods2;
        
        DBMS_OUTPUT.PUT_LINE('ODS ' || ods.id_ods2 || ': ' || v_num_metricas || ' métricas');
        
        IF (ods.id_ods2 = 101 AND v_num_metricas <> 3) OR (ods.id_ods2 = 102 AND v_num_metricas <> 4) THEN
            v_test_ok := FALSE;
            DBMS_OUTPUT.PUT_LINE('  ✗ Error: ODS ' || ods.id_ods2 || ' debe tener ' || CASE WHEN ods.id_ods2 = 101 THEN 3 ELSE 4 END || ' métricas');
        ELSE
            DBMS_OUTPUT.PUT_LINE('  ✓ Correcto');
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    IF v_test_ok THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Conteo de métricas correcto');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Conteo de métricas incorrecto');
    END IF;
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 5: CURSOR FOR UPDATE - ESTADO INICIAL
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 5: Verificar estado inicial de puntuaciones (antes del cursor FOR UPDATE)
PROMPT ============================================================================
PROMPT Resultado esperado: Puntuaciones deben estar en NULL
PROMPT 

DECLARE
    v_null_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_null_count
    FROM viabilidad
    WHERE puntuacion_final IS NULL;
    
    DBMS_OUTPUT.PUT_LINE('Registros con puntuacion_final en NULL: ' || v_null_count);
    
    IF v_null_count >= 2 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Hay registros pendientes de calcular');
    ELSE
        DBMS_OUTPUT.PUT_LINE('⚠ ADVERTENCIA: No hay registros pendientes (ya fueron calculados)');
        DBMS_OUTPUT.PUT_LINE('  → Reseteando puntuaciones para las pruebas...');
        
        UPDATE viabilidad SET puntuacion_final = NULL, evaluador = NULL;
        COMMIT;
        
        DBMS_OUTPUT.PUT_LINE('✓ Puntuaciones reseteadas');
    END IF;
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 6: CURSOR FOR UPDATE - CÁLCULO DE PUNTUACIONES
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 6: CURSOR FOR UPDATE - Calcular y actualizar puntuaciones
PROMPT ============================================================================
PROMPT Resultado esperado: Debe calcular y actualizar las puntuaciones finales
PROMPT 

DECLARE
    CURSOR c_viabilidad IS
        SELECT 
            v.id_viabilidad,
            v.id_ods2,
            o2.nombre AS nombre_ods2,
            v.impacto,
            v.coste,
            v.tiempo,
            v.riesgo,
            v.puntuacion_final
        FROM viabilidad v
        JOIN ods_2 o2 ON v.id_ods2 = o2.id_ods2
        WHERE v.puntuacion_final IS NULL
        FOR UPDATE OF v.puntuacion_final NOWAIT;
    
    v_puntuacion_calculada NUMBER(4,2);
    v_registros_actualizados NUMBER := 0;
    
BEGIN
    FOR rec_viabilidad IN c_viabilidad LOOP
        -- Fórmula: (impacto + (10-coste) + (10-tiempo) + (10-riesgo)) / 4
        v_puntuacion_calculada := ROUND(
            (rec_viabilidad.impacto + 
             (10 - rec_viabilidad.coste) + 
             (10 - rec_viabilidad.tiempo) + 
             (10 - rec_viabilidad.riesgo)) / 4, 
            2
        );
        
        UPDATE viabilidad
        SET 
            puntuacion_final = v_puntuacion_calculada,
            fecha_evaluacion = CURRENT_TIMESTAMP,
            evaluador = 'Sistema Automático TEST'
        WHERE CURRENT OF c_viabilidad;
        
        DBMS_OUTPUT.PUT_LINE('✓ ODS ' || rec_viabilidad.id_ods2 || 
                           ' → Puntuación: ' || v_puntuacion_calculada || '/10');
        
        v_registros_actualizados := v_registros_actualizados + 1;
    END LOOP;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: ' || v_registros_actualizados || ' registros actualizados');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('⚠ No hay evaluaciones pendientes de calcular');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
        ROLLBACK;
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 7: CURSOR FOR UPDATE - VERIFICAR ACTUALIZACIÓN
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 7: Verificar que las puntuaciones fueron actualizadas correctamente
PROMPT ============================================================================
PROMPT Resultado esperado: Todas las puntuaciones deben estar calculadas (NOT NULL)
PROMPT 

DECLARE
    v_null_count NUMBER;
    v_total_count NUMBER;
    v_puntuacion_101 NUMBER(4,2);
    v_puntuacion_102 NUMBER(4,2);
    v_esperada_101 NUMBER(4,2);
    v_esperada_102 NUMBER(4,2);
BEGIN
    -- Contar registros con y sin puntuación
    SELECT COUNT(*) INTO v_null_count
    FROM viabilidad WHERE puntuacion_final IS NULL;
    
    SELECT COUNT(*) INTO v_total_count
    FROM viabilidad;
    
    DBMS_OUTPUT.PUT_LINE('Total de evaluaciones: ' || v_total_count);
    DBMS_OUTPUT.PUT_LINE('Pendientes de calcular: ' || v_null_count);
    DBMS_OUTPUT.PUT_LINE('Ya calculadas: ' || (v_total_count - v_null_count));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Verificar puntuaciones específicas
    SELECT puntuacion_final INTO v_puntuacion_101
    FROM viabilidad WHERE id_ods2 = 101;
    
    SELECT puntuacion_final INTO v_puntuacion_102
    FROM viabilidad WHERE id_ods2 = 102;
    
    -- Cálculos esperados:
    -- ODS 101: impacto=8, coste=5, tiempo=6, riesgo=4
    -- Fórmula: (8 + (10-5) + (10-6) + (10-4)) / 4 = (8 + 5 + 4 + 6) / 4 = 23/4 = 5.75
    v_esperada_101 := 5.75;
    
    -- ODS 102: impacto=7, coste=4, tiempo=5, riesgo=3
    -- Fórmula: (7 + (10-4) + (10-5) + (10-3)) / 4 = (7 + 6 + 5 + 7) / 4 = 25/4 = 6.25
    v_esperada_102 := 6.25;
    
    DBMS_OUTPUT.PUT_LINE('Verificación de cálculos:');
    DBMS_OUTPUT.PUT_LINE('  ODS 101: Calculada=' || v_puntuacion_101 || 
                         ', Esperada=' || v_esperada_101);
    
    IF v_puntuacion_101 = v_esperada_101 THEN
        DBMS_OUTPUT.PUT_LINE('  ✓ Puntuación ODS 101 correcta');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✗ Puntuación ODS 101 incorrecta');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('  ODS 102: Calculada=' || v_puntuacion_102 || 
                         ', Esperada=' || v_esperada_102);
    
    IF v_puntuacion_102 = v_esperada_102 THEN
        DBMS_OUTPUT.PUT_LINE('  ✓ Puntuación ODS 102 correcta');
    ELSE
        DBMS_OUTPUT.PUT_LINE('  ✗ Puntuación ODS 102 incorrecta');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('');
    
    IF v_null_count = 0 AND 
       v_puntuacion_101 = v_esperada_101 AND 
       v_puntuacion_102 = v_esperada_102 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Todas las puntuaciones calculadas correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Hay errores en las puntuaciones');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: No se encontraron registros de viabilidad');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: ' || SQLERRM);
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 8: CURSOR FOR UPDATE - EJECUTAR SIN DATOS PENDIENTES
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 8: CURSOR FOR UPDATE - Ejecutar cuando no hay datos pendientes
PROMPT ============================================================================
PROMPT Resultado esperado: No debe actualizar ningún registro
PROMPT 

DECLARE
    CURSOR c_viabilidad IS
        SELECT v.id_viabilidad
        FROM viabilidad v
        WHERE v.puntuacion_final IS NULL
        FOR UPDATE OF v.puntuacion_final NOWAIT;
    
    v_contador NUMBER := 0;
BEGIN
    FOR rec IN c_viabilidad LOOP
        v_contador := v_contador + 1;
    END LOOP;
    
    IF v_contador = 0 THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: No hay registros pendientes (comportamiento esperado)');
    ELSE
        DBMS_OUTPUT.PUT_LINE('⚠ Se encontraron ' || v_contador || ' registros pendientes');
    END IF;
    
    COMMIT;
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 9: VERIFICAR EVALUADOR Y FECHA
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 9: Verificar que se actualizó el evaluador y fecha
PROMPT ============================================================================
PROMPT Resultado esperado: Evaluador debe ser "Sistema Automático TEST"
PROMPT 

DECLARE
    v_evaluador VARCHAR2(100);
    v_fecha_eval TIMESTAMP;
    v_test_ok BOOLEAN := TRUE;
BEGIN
    FOR rec IN (SELECT id_ods2, evaluador, fecha_evaluacion FROM viabilidad) LOOP
        DBMS_OUTPUT.PUT_LINE('ODS ' || rec.id_ods2 || ':');
        DBMS_OUTPUT.PUT_LINE('  Evaluador: ' || NVL(rec.evaluador, 'NULL'));
        DBMS_OUTPUT.PUT_LINE('  Fecha: ' || TO_CHAR(rec.fecha_evaluacion, 'DD/MM/YYYY HH24:MI:SS'));
        
        IF rec.evaluador IS NULL THEN
            DBMS_OUTPUT.PUT_LINE('  ✗ Error: Evaluador no fue actualizado');
            v_test_ok := FALSE;
        ELSE
            DBMS_OUTPUT.PUT_LINE('  ✓ Evaluador actualizado');
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('');
    IF v_test_ok THEN
        DBMS_OUTPUT.PUT_LINE('✓ PRUEBA EXITOSA: Metadatos actualizados correctamente');
    ELSE
        DBMS_OUTPUT.PUT_LINE('✗ PRUEBA FALLIDA: Evaluador no actualizado');
    END IF;
END;
/

PROMPT 

-- ============================================================================
-- PRUEBA 10: RESUMEN FINAL Y LIMPIEZA
-- ============================================================================
PROMPT ============================================================================
PROMPT PRUEBA 10: Resumen final del estado de la base de datos
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
PROMPT Puntuaciones finales:
SELECT 
    o2.id_ods2,
    o2.nombre,
    v.puntuacion_final,
    v.evaluador
FROM ods_2 o2
LEFT JOIN viabilidad v ON o2.id_ods2 = v.id_ods2
ORDER BY v.puntuacion_final DESC NULLS LAST;

PROMPT 
PROMPT ============================================================================
PROMPT                    FIN DE LAS PRUEBAS DE CURSORES
PROMPT ============================================================================
PROMPT Resumen:
PROMPT - Prueba 1: Cursor implícito con registro existente
PROMPT - Prueba 2: Cursor implícito con registro inexistente
PROMPT - Prueba 3: Cursor explícito recorriendo registros
PROMPT - Prueba 4: Cursor explícito verificando conteos
PROMPT - Prueba 5: Estado inicial de puntuaciones
PROMPT - Prueba 6: Cursor FOR UPDATE calculando puntuaciones
PROMPT - Prueba 7: Verificación de cálculos
PROMPT - Prueba 8: Cursor FOR UPDATE sin datos pendientes
PROMPT - Prueba 9: Verificación de metadatos
PROMPT - Prueba 10: Resumen final
PROMPT ============================================================================
