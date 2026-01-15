INSERT INTO ods_original VALUES (1,'ODS 4 - Educación de calidad','Garantizar una educación inclusiva, equitativa y de calidad.'
);

INSERT INTO ods_original VALUES (2,'ODS 12 - Producción y consumo responsables','Garantizar modalidades de consumo y producción sostenibles.'
);

INSERT INTO ods_2 VALUES (101,1,
    'Acceso digital educativo medible',
    'Mejorar el acceso real a recursos digitales en centros educativos.',
    'BORRADOR'
);

INSERT INTO ods_2 VALUES (102,2,
    'Reducción medible de residuos tecnológicos',
    'Reducir el impacto ambiental del residuo electrónico.',
    'BORRADOR'
);

--ODS 4.2.0
INSERT INTO metrica VALUES (1, 101, 'Aulas con internet', '%', 95);
INSERT INTO metrica VALUES (2, 101, 'Dispositivos por alumno', 'ratio', 1);
INSERT INTO metrica VALUES (3, 101, 'Profesorado con formación digital', '%', 80);

--ODS 12.2.0
INSERT INTO metrica VALUES (4, 102, 'Residuos electrónicos reciclados', 'kg/año', 500);
INSERT INTO metrica VALUES (5, 102, 'Dispositivos reutilizados', '%', 40);
INSERT INTO metrica VALUES (6, 102, 'Vida media de dispositivos', 'años', 5);

--ODS 4.2.0
INSERT INTO evidencia VALUES (1, 101,
    'Informe de conectividad educativa',
    'Ministerio de Educación',
    4
);

INSERT INTO evidencia VALUES (2, 101,
    'Auditoría TIC de centros públicos',
    'Consejería autonómica',
    3
);

--ODS 12.2.0
INSERT INTO evidencia VALUES (3, 102,
    'Certificado oficial de reciclaje electrónico',
    'Empresa gestora autorizada',
    5
);

INSERT INTO evidencia VALUES (4, 102,
    'Informe interno de inventario tecnológico',
    'Departamento TIC',
    3
);

INSERT INTO viabilidad VALUES (1, 101,8, 5, 6, 4,NULL);

INSERT INTO viabilidad VALUES (2, 102,7, 4, 5, 3, NULL);

COMMIT;