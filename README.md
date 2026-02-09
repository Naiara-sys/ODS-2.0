# ODS-2.0
Reto ETHAZI: “ODS 2.0”
## Diagrama ER
![Diagrama ER](tablas.png)

## Descripción del Proyecto
Somos el equipo técnico de un Observatorio de Sostenibilidad encargado de revisar los Objetivos de Desarrollo Sostenible (ODS). Los ODS originales son demasiado genéricos, por lo que creamos ODS 2.0: versiones más realistas, medibles y evaluables. El sistema de base de datos con PL/SQL permite almacenar ODS originales, crear ODS reformulados vinculados, definir métricas, evidencias y calcular viabilidad automáticamente.

## Archivos del Proyecto

- **01_ddl.sql**: Definición completa de tablas (DDL), claves primarias, foráneas y restricciones (mín. 6 tablas).
- **02_inserts.sql**: Inserción de datos mínimos (ODS originales, 2 ODS 2.0, métricas y evidencias).
- **03_cursores.sql**: Tres cursores PL/SQL (implícito, explícito y FOR UPDATE) para informes y actualizaciones.
- **04_pruebas.sql**: Pruebas unitarias para validar los cursores de 03_cursores.sql.
- **05_proced_func.sql**: Tres procedimientos/funciones PL/SQL con parámetros IN y al menos uno OUT.
- **06_pruebas.sql**: Pruebas unitarias para validar los procedimientos/funciones de 05_proced_func.sql.

## Enunciado del Trabajo

### Sprint 1 — "Entender el problema" (Semana 1)
• Lista de ODS a replantear (mín. 2 ODS2 por equipo).
• Reglas de viabilidad (criterios y fórmula).
• Boceto ER (a mano vale).
Entrega 1: diseño + justificación (1 página).

### Sprint 2 — "BD funcional" (Semana 2)
• DDL completo, claves y restricciones.
• Insert de datos mínimos (ODS originales + 2 ODS2 + métricas + evidencias).
Entrega 2: 01_ddl.sql + 02_inserts.sql

### Sprint 3 — "PL/SQL - cursores" (Semana 3)
• Cursores con informes.
Entrega 3: 03_cursores.sql + 04_pruebas.sql

### Sprint 4 — "PL/SQL – procedimientos y funciones" (Semana 4)
• Procedimientos/funciones operativos.
Entrega 4: 05_proced_func.sql + 06_pruebas.sql

### Contexto
Sois el equipo técnico de un Observatorio de Sostenibilidad encargado de revisar los Objetivos de Desarrollo Sostenible (ODS).
Se ha detectado que muchos ODS originales son demasiado genéricos y difíciles de medir, por lo que el Observatorio ha decidido crear una versión mejorada llamada ODS 2.0, con objetivos más realistas, medibles y evaluables.
Vuestra misión es diseñar un sistema de base de datos con PL/SQL que permita:
• Almacenar ODS originales.
• Crear ODS reformulados (ODS 2.0) vinculados a los originales.
• Definir métricas, evidencias y niveles de fiabilidad.
• Calcular automáticamente la viabilidad de cada ODS 2.0 (impacto, coste, tiempo, riesgo).
El sistema servirá para analizar, justificar y comparar los ODS 2.0 mediante informes técnicos.

### Requisitos Obligatorios

#### A) Requisitos de negocio (Sostenibilidad)
El sistema debe permitir:
1. Guardar ODS originales
2. Crear ODS reformulados (ODS 2.0) vinculados a un ODS original.
3. Cada ODS 2.0 debe tener métricas nuevas (mín. 3 por ODS2) que permitan medirlo.
4. Cada ODS 2.0 debe tener evidencias o fuentes (mín. 2 por ODS2) con un nivel de fiabilidad (por ejemplo 0–5 o bajo/medio/alto).
5. Cada ODS 2.0 debe tener una evaluación de viabilidad basada en (mínimo) 4 criterios (ej.: impacto, coste, tiempo, riesgo).
   - La fórmula exacta la decidís vosotros, pero debe estar documentada.

#### B) Requisitos técnicos (Base de datos)
1. Modelo libre, pero debe incluir mínimo 6 tablas reales (no "tabla única gigante").
2. Deben existir:
   - PK y FK bien definidas.
   - restricciones (CHECK/NOT NULL/UNIQUE) donde tenga sentido.

#### C) Requisitos PL/SQL
Tenéis que incluir sí o sí:
1) Cursores (mínimo 3)
   • 1 cursor implícito
   • 1 cursor explícito
   • 1 cursor con FOR UPDATE.
2) Procedimientos/funciones (mínimo 3)
   Deben usar parámetros IN y al menos 1 OUT en alguno.