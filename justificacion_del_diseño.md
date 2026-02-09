# Justificación Técnica del Diseño de la Base de Datos ODS 2.0

## Contexto y Análisis del Problema
El reto "ODS 2.0" requiere un sistema de base de datos para gestionar Objetivos de Desarrollo Sostenible (ODS) originales y sus versiones reformuladas (ODS 2.0), permitiendo medir viabilidad, métricas y evidencias. Traducimos el problema a requisitos: almacenar ODS originales, vincular ODS 2.0, definir métricas (mín. 3 por ODS 2.0), evidencias con fiabilidad (mín. 2 por ODS 2.0) y evaluar viabilidad con 4 criterios (impacto, coste, tiempo, riesgo). La fórmula de viabilidad es: puntuación_final = (impacto + (10-coste) + (10-tiempo) + (10-riesgo)) / 4, donde mayor impacto y menores coste/tiempo/riesgo mejoran la puntuación.

## Identificación de Entidades y Modelo ER
Identificamos 6 entidades principales para evitar redundancias y asegurar normalización (3FN):
- **ODS_ORIGINAL**: Almacena ODS oficiales (ej. ODS 4, 12). Campos: id, numero_ods (único, 1-17), nombre, descripcion, fecha_registro. Justificación: Base para vincular ODS 2.0, con CHECK para validar rango ODS.
- **ODS_2**: ODS reformulados vinculados a originales. Campos: id, id_ods_original (FK), nombre, descripcion, estado (BORRADOR/REVISION/APROBADO), fechas, usuario. Justificación: Central para métricas/evidencias, con índices en estado y fecha para consultas rápidas.
- **METRICA**: Métricas por ODS 2.0 (mín. 3). Campos: id, id_ods2 (FK), nombre, unidad, valor_objetivo/actual, fecha. Justificación: Medibilidad; UNIQUE en (id_ods2, nombre) evita duplicados; CHECK asegura valores positivos.
- **EVIDENCIA**: Fuentes con fiabilidad (mín. 2). Campos: id, id_ods2 (FK), descripcion, fuente, fiabilidad (0-5), tipo_fuente, fecha, url. Justificación: Soporte técnico; CHECK en fiabilidad y tipos; UNIQUE evita evidencias duplicadas por ODS.
- **VIABILIDAD**: Evaluación por ODS 2.0. Campos: id, id_ods2 (FK único), impacto/coste/tiempo/riesgo (0-10), puntuacion_final, fecha, evaluador. Justificación: Viabilidad automática; fórmula documentada en PL/SQL; CHECK en rangos.
- **HISTORIAL_ESTADOS**: Auditoría de cambios en ODS_2. Campos: id, id_ods2 (FK), estados anterior/nuevo, fecha, usuario, comentario. Justificación: Trazabilidad; CHECK en estados válidos; índices en id_ods2 y fecha para búsquedas.

Relaciones: ODS_ORIGINAL (1) -- (N) ODS_2; ODS_2 (1) -- (N) METRICA/EVIDENCIA; ODS_2 (1) -- (1) VIABILIDAD; ODS_2 (1) -- (N) HISTORIAL_ESTADOS. FK con ON DELETE CASCADE para integridad referencial.

## Decisiones Técnicas y Anticipación de Problemas
- **Normalización**: 3FN evita redundancias (ej. no repetir ODS en métricas). Índices optimizan consultas (ej. idx_estado para filtrar por estado).
- **Restricciones**: PK IDENTITY para autoincremento; FK para integridad; CHECK/NOT NULL/UNIQUE previenen datos erróneos (ej. fiabilidad 0-5, estados válidos). UNIQUE en viabilidad por ODS evita múltiples evaluaciones.
- **Problemas anticipados**: Concurrencia en actualizaciones (resuelto con FOR UPDATE en cursores); crecimiento de datos (índices en fechas); integridad (CASCADE elimina dependencias); escalabilidad (modelo extensible para más ODS).
- **PL/SQL integración**: Tablas diseñadas para cursores (implícito/explícito/FOR UPDATE) y procedimientos (IN/OUT para inserts/consultas).

Este diseño cumple requisitos técnicos (≥6 tablas, PK/FK/restricciones) y de negocio, permitiendo informes y cálculos automáticos. Total: ~500 palabras. (Fin de página)