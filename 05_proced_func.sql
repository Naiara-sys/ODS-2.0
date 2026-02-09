-- ============================================================================
-- SPRINT 4: PROCEDIMIENTOS Y FUNCIONES
-- Archivo: 05_proced_func.sql
-- Descripción: Tres procedimientos y funciones PL/SQL que interactúan con
--              las tablas del sistema ODS 2.0. Incluyen parámetros IN y OUT.
-- ============================================================================

SET SERVEROUTPUT ON;

-- ============================================================================
-- PROCEDIMIENTO 1: INSERTAR ODS 2.0
-- Descripción: Procedimiento para insertar un nuevo ODS 2.0 en la tabla ODS_2
-- Parámetros:
--   - p_id_ods_original (IN): ID del ODS original
--   - p_nombre (IN): Nombre del nuevo ODS 2.0
--   - p_descripcion (IN): Descripción del ODS 2.0
--   - p_usuario (IN): Usuario creador
-- ============================================================================

CREATE OR REPLACE PROCEDURE insertar_ods2 (
    p_id_ods_original IN NUMBER,
    p_nombre IN VARCHAR2,
    p_descripcion IN CLOB,
    p_usuario IN VARCHAR2
) IS
BEGIN
    INSERT INTO ods_2 (
        id_ods_original,
        nombre,
        descripcion,
        estado,
        fecha_creacion,
        fecha_modificacion,
        usuario_creador
    ) VALUES (
        p_id_ods_original,
        p_nombre,
        p_descripcion,
        'BORRADOR',
        CURRENT_TIMESTAMP,
        CURRENT_TIMESTAMP,
        p_usuario
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('ODS 2.0 insertado correctamente: ' || p_nombre);
END insertar_ods2;
/

-- ============================================================================
-- FUNCIÓN 2: CONTAR MÉTRICAS DE UN ODS 2.0
-- Descripción: Función que cuenta el número de métricas asociadas a un ODS 2.0
-- Parámetros:
--   - p_id_ods2 (IN): ID del ODS 2.0
--   - p_total_metricas (OUT): Número total de métricas
-- Retorna: BOOLEAN (TRUE si tiene métricas, FALSE si no)
-- ============================================================================

CREATE OR REPLACE FUNCTION contar_metricas_ods2 (
    p_id_ods2 IN NUMBER,
    p_total_metricas OUT NUMBER
) RETURN BOOLEAN IS
BEGIN
    SELECT COUNT(*) INTO p_total_metricas
    FROM metrica
    WHERE id_ods2 = p_id_ods2;

    IF p_total_metricas > 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END contar_metricas_ods2;
/

-- ============================================================================
-- PROCEDIMIENTO 3: ACTUALIZAR ESTADO ODS 2.0
-- Descripción: Procedimiento para cambiar el estado de un ODS 2.0 y registrar
--              el cambio en el historial de estados
-- Parámetros:
--   - p_id_ods2 (IN): ID del ODS 2.0
--   - p_nuevo_estado (IN): Nuevo estado ('BORRADOR', 'REVISION', 'APROBADO')
--   - p_usuario (IN): Usuario que realiza el cambio
--   - p_comentario (IN): Comentario opcional del cambio
-- ============================================================================

CREATE OR REPLACE PROCEDURE actualizar_estado_ods2 (
    p_id_ods2 IN NUMBER,
    p_nuevo_estado IN VARCHAR2,
    p_usuario IN VARCHAR2,
    p_comentario IN VARCHAR2 DEFAULT NULL
) IS
    v_estado_anterior VARCHAR2(20);
BEGIN
    -- Obtener el estado anterior
    SELECT estado INTO v_estado_anterior
    FROM ods_2
    WHERE id_ods2 = p_id_ods2;

    -- Actualizar el estado
    UPDATE ods_2
    SET estado = p_nuevo_estado,
        fecha_modificacion = CURRENT_TIMESTAMP
    WHERE id_ods2 = p_id_ods2;

    -- Insertar en historial
    INSERT INTO historial_estados (
        id_ods2,
        estado_anterior,
        estado_nuevo,
        fecha_cambio,
        usuario,
        comentario
    ) VALUES (
        p_id_ods2,
        v_estado_anterior,
        p_nuevo_estado,
        CURRENT_TIMESTAMP,
        p_usuario,
        p_comentario
    );

    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Estado actualizado de ' || v_estado_anterior || ' a ' || p_nuevo_estado);
END actualizar_estado_ods2;
/