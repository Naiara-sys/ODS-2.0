-- ============================================================================
-- CURSOR 1: CURSOR IMPLÍCITO
-- Cursor implícito
-- Se utiliza para recuperar un solo registro de la tabla ODS_2
-- ============================================================================

SET SERVEROUTPUT ON;

DECLARE
-- Variable que almacenará todos los campos de un ODS 2.0
    v_ods2 ods_2%ROWTYPE;

BEGIN
    -- SELECT INTO abre un cursor implícito automáticamente
    -- Recupera un único ODS 2.0 según su identificador
    SELECT *
    INTO v_ods2
    FROM ods_2
    WHERE id_ods2 = 101;

    DBMS_OUTPUT.PUT_LINE('=== FICHA ODS 2.0 ===');
    DBMS_OUTPUT.PUT_LINE('ID          : ' || v_ods2.id_ods2);
    DBMS_OUTPUT.PUT_LINE('Nombre      : ' || v_ods2.nombre);
    DBMS_OUTPUT.PUT_LINE('Descripción : ' || v_ods2.descripcion);
    DBMS_OUTPUT.PUT_LINE('Estado      : ' || v_ods2.estado);
END;
/


SET SERVEROUTPUT ON;


-- ============================================================================
-- CURSOR 2: CURSOR EXPLÍCITO
-- Generamos un informe con los ODS, sus métricas y evidencias
-- ============================================================================

DECLARE
    -- Declaramos el cursor
    CURSOR c_ods IS
        SELECT o2.id_ods2, o2.nombre, o2.estado, oo.nombre AS ods_original
        FROM ods_2 o2
        JOIN ods_original oo ON o2.id_ods_original = oo.id_ods_original;
    
    v_num_metricas NUMBER;
    v_num_evidencias NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('INFORME DE ODS 2.0');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Recorremos el cursor
    FOR ods IN c_ods LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || ods.id_ods2);
        DBMS_OUTPUT.PUT_LINE('Nombre: ' || ods.nombre);
        DBMS_OUTPUT.PUT_LINE('ODS original: ' || ods.ods_original);
        DBMS_OUTPUT.PUT_LINE('Estado: ' || ods.estado);
        
        -- Contamos métricas
        SELECT COUNT(*) INTO v_num_metricas
        FROM metrica WHERE id_ods2 = ods.id_ods2;
        
        -- Contamos evidencias
        SELECT COUNT(*) INTO v_num_evidencias
        FROM evidencia WHERE id_ods2 = ods.id_ods2;
        
        DBMS_OUTPUT.PUT_LINE('Métricas: ' || v_num_metricas);
        DBMS_OUTPUT.PUT_LINE('Evidencias: ' || v_num_evidencias);
        
        -- Mostramos las métricas
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('Detalle de métricas:');
        FOR rec_metrica IN (SELECT nombre, valor_objetivo, unidad 
                           FROM metrica 
                           WHERE id_ods2 = ods.id_ods2) LOOP
            DBMS_OUTPUT.PUT_LINE('  - ' || rec_metrica.nombre || 
                               ': ' || rec_metrica.valor_objetivo || ' ' || rec_metrica.unidad);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
END;
/


SET SERVEROUTPUT ON;


-- ============================================================================
-- CURSOR 3: CURSOR FOR UPDATE
-- Actualización de puntuaciones de viabilidad
-- ============================================================================
-- Descripción: Este cursor recorre la tabla VIABILIDAD y calcula automáticamente
--              la puntuación final basándose en los criterios evaluados:
--              - Impacto (mayor es mejor)
--              - Coste (menor es mejor, se invierte en la fórmula)
--              - Tiempo (menor es mejor, se invierte en la fórmula)
--              - Riesgo (menor es mejor, se invierte en la fórmula)
--
-- Fórmula: puntuacion_final = (impacto + (10-coste) + (10-tiempo) + (10-riesgo)) / 4
--
-- Justificación FOR UPDATE:
--   - Se bloquean las filas durante la actualización para evitar modificaciones
--   - Se usa "WHERE CURRENT OF" para actualizar la fila exacta del cursor
--   - Es una operación transaccional que debe completarse de forma atómica
-- ============================================================================

DECLARE
    -- Cursor con FOR UPDATE para bloquear las filas durante la actualización
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
        WHERE v.puntuacion_final IS NULL  -- Solo los que no tienen puntuación
        FOR UPDATE OF v.puntuacion_final NOWAIT;  -- Bloquea solo la columna puntuacion_final

    v_puntuacion_calculada NUMBER(4,2);
    v_registros_actualizados NUMBER := 0;

BEGIN
    DBMS_OUTPUT.PUT_LINE('=============================================');
    DBMS_OUTPUT.PUT_LINE(' ACTUALIZACIÓN DE PUNTUACIONES DE VIABILIDAD');
    DBMS_OUTPUT.PUT_LINE('=============================================');
    DBMS_OUTPUT.PUT_LINE('');

    -- Recorrer todas las evaluaciones de viabilidad pendientes
    FOR rec_viabilidad IN c_viabilidad LOOP

        -- Calcular la puntuación final basada en los 4 criterios
        -- Impacto: cuanto mayor, mejor (se suma directamente)
        -- Coste, Tiempo, Riesgo: cuanto menor, mejor (se invierten)
        v_puntuacion_calculada := ROUND(
            (rec_viabilidad.impacto + 
             (10 - rec_viabilidad.coste) + 
             (10 - rec_viabilidad.tiempo) + 
             (10 - rec_viabilidad.riesgo)) / 4, 
            2
        );

        -- Actualizar la fila actual del cursor usando WHERE CURRENT OF
        UPDATE viabilidad
        SET
            puntuacion_final = v_puntuacion_calculada,
            fecha_evaluacion = CURRENT_TIMESTAMP,
            evaluador = 'Sistema Automático'
        WHERE CURRENT OF c_viabilidad;

        -- Mostrar información del registro actualizado
        DBMS_OUTPUT.PUT_LINE('✓ ODS 2.0: ' || rec_viabilidad.nombre_ods2);
        DBMS_OUTPUT.PUT_LINE('  - Impacto: ' || rec_viabilidad.impacto || '/10');
        DBMS_OUTPUT.PUT_LINE('  - Coste: ' || rec_viabilidad.coste || '/10');
        DBMS_OUTPUT.PUT_LINE('  - Tiempo: ' || rec_viabilidad.tiempo || '/10');
        DBMS_OUTPUT.PUT_LINE('  - Riesgo: ' || rec_viabilidad.riesgo || '/10');
        DBMS_OUTPUT.PUT_LINE('  → Puntuación Final: ' || v_puntuacion_calculada || '/10');
        DBMS_OUTPUT.PUT_LINE('');

        v_registros_actualizados := v_registros_actualizados + 1;

    END LOOP;

    -- Confirmar los cambios
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('=============================================');
    DBMS_OUTPUT.PUT_LINE('     Total de evaluaciones actualizadas: ' || v_registros_actualizados);
    DBMS_OUTPUT.PUT_LINE('=============================================');

END;
/

