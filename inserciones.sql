use HOSPITAL;

-------------------------------------------------------------------------------------------------------------------
INSERT INTO TIPO_USUARIO ( Descr_Tip_Usu) VALUES
('Empleado'),  -- Empleado 
('Paciente')  -- Paciente

----------------------------------------------------------------------------------------------------------------
INSERT INTO TIPO_EMPLEADO (tipo_emp) VALUES 
('Doctor'),         -- Tipo de empleado 7: Doctor
('Recepcionista'),  -- Tipo de empleado 8: Recepcionista
('Farmacéutico');   -- Tipo de empleado 9: Farmacéutico

--------------------------------------------------------------------------------------------------------------------
INSERT INTO DATOSP (nombre, ap_paterno, ap_marerno, fecha_nacimiento, TELEFONO, correo, edad, curp)
VALUES 
('Ana', 'García', 'Luna', '1990-03-17', 5522334455, 'anagarcía@mail.com', dbo.CalcularEdad('1990-03-17'), 'GALA900317MDFRNC06');
INSERT INTO DATOSP (nombre, ap_paterno, ap_marerno, fecha_nacimiento, TELEFONO, correo, edad, curp)
VALUES
('Juan', 'Pérez', 'Gómez', '1985-06-15', 5534456789, 'juanperez@mail.com', dbo.CalcularEdad('1985-06-15'), 'PEPJ850615HDFRNS01');
INSERT INTO DATOSP (nombre, ap_paterno, ap_marerno, fecha_nacimiento, TELEFONO, correo, edad, curp)
VALUES
('Carlos', 'Martínez', 'Hernández', '1980-09-30', 5533223344, 'carlosmartin@mail.com', dbo.CalcularEdad('1980-09-30'), 'MHCN800930HDFRSC03');


---------------------------------------------------------------------------------------------------------------
INSERT INTO ESPECIALIDAD (costo, descripcion) VALUES
(1500.00, 'Cardiología'),
(1200.00, 'Dermatología'),
(1800.00, 'Neurología'),
(1000.00, 'Pediatría'),
(2200.00, 'Ortopedia'),
(1400.00, 'Ginecología'),
(1600.00, 'Oftalmología'),
(1300.00, 'Psiquiatría'),
(1100.00, 'Odontología'),
(2000.00, 'Medicina General');

-----------------------------------------------------------------------------------------------------------------
INSERT INTO JORNADA (turno, Hora_inicio, Hora_fin, turno_inicio, turno_fin) VALUES 
('MATUTINO', '06:00', '18:00', '06:00', '18:00'),  -- Turno Mañana
('VESPERTINO', '18:00', '06:00', '18:00', '06:00');  -- Turno tarde

---------------------------------------------------------------------------------------------------------------

INSERT INTO USUARIO (contraseña, nombre_usuario, id_tipousuario, id_datosp) VALUES 
('pass123', 'anagarcia', 3, 42)
INSERT INTO USUARIO (contraseña, nombre_usuario, id_tipousuario,id_datosp) VALUES
('pass123', 'juanperez', 4,43) -- Juan Pérez
INSERT INTO USUARIO (contraseña, nombre_usuario, id_tipousuario,id_datosp) VALUES
('pass456', 'carlosmart', 3, 44) -- Carlos Martínez




--------------------------------------------------------------------------------------


INSERT INTO EMPLEADO (id_tipoemp, estatus_emp, id_usuario, id_jornada)
VALUES 
(8, 1, (SELECT MAX(id_usuario) FROM USUARIO), 1);
INSERT INTO EMPLEADO (id_tipoemp, estatus_emp, id_usuario, id_jornada) 
VALUES (8, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'anagarcia'), 1);  -- '8' es el id_tipoemp para Recepcionista, y '1' es el id_jornada
INSERT INTO RECEPCIONISTA (id_tipoemp)
VALUES (
    (SELECT id_tipoemp FROM TIPO_EMPLEADO WHERE tipo_emp = 'Recepcionista')  -- Buscamos el id_tipoemp para "Recepcionista"
);

------------------------------------------------------------------------------------------------------------------
-- DATOSP
INSERT INTO DATOSP (nombre, ap_paterno, ap_marerno, fecha_nacimiento, TELEFONO, correo, edad, curp)
VALUES
('María', 'Lopez', 'Ruiz', '1992-02-14', 5511223344, 'marialopez@mail.com', dbo.CalcularEdad('1992-02-14'), 'LORM920214MDFRRA05'),
('Luis', 'Hernandez', 'Ramirez', '1988-05-23', 5544332211, 'luishernandez@mail.com', dbo.CalcularEdad('1988-05-23'), 'HURL880523HDFRRM02'),
('Sofía', 'Gómez', 'Flores', '1995-07-10', 5512345678, 'sofiagomez@mail.com', dbo.CalcularEdad('1995-07-10'), 'GOSF950710MDFLRS07'),
('Miguel', 'Torres', 'Morales', '1990-09-08', 5532123445, 'migueltorres@mail.com', dbo.CalcularEdad('1990-09-08'), 'TORM900908HDFMLS09'),
('Lucía', 'Rojas', 'Sánchez', '1998-03-25', 5543225567, 'luciarojas@mail.com', dbo.CalcularEdad('1998-03-25'), 'ROLS980325MDFSNC04'),
('Diego', 'Vargas', 'Ortega', '1985-11-19', 5523445566, 'diegovargas@mail.com', dbo.CalcularEdad('1985-11-19'), 'VORD851119HDFRRG08'),
('Paula', 'Medina', 'Castillo', '1994-12-01', 5544567788, 'paulamedina@mail.com', dbo.CalcularEdad('1994-12-01'), 'MEPC941201MDFRST12'),
('Jorge', 'Ortiz', 'Cruz', '1989-06-07', 5512334455, 'jorgeortiz@mail.com', dbo.CalcularEdad('1989-06-07'), 'ORJC890607HDFCRZ01'),
('Carla', 'Nuñez', 'Hernandez', '1993-01-22', 5523456677, 'carlanunez@mail.com', dbo.CalcularEdad('1993-01-22'), 'NUHC930122MDFNRD06'),
('Francisco', 'Salazar', 'Vega', '1986-04-13', 5532348899, 'franciscosalazar@mail.com', dbo.CalcularEdad('1986-04-13'), 'SAVF860413HDFVGR03');

-- TIPO_USUARIO (ya hay registros suficientes, no se necesita más)
-- Si no, agrega más con el patrón existente.

-- USUARIO
INSERT INTO USUARIO (contraseña, nombre_usuario, id_tipousuario, id_datosp)
VALUES
('clave123', 'mlopez', 3, 50),
('clave456', 'lhernandez', 3, 51),
('clave789', 'sgomez', 3, 52),
('clave012', 'mtorres', 3, 53),
('clave345', 'lrojas', 3, 54),
('clave678', 'dvargas', 3, 55),
('clave901', 'pmedina', 3, 56),
('clave234', 'jortiz', 3, 57),
('clave567', 'cnunez', 3, 58),
('clave890', 'fsalazar', 3, 59);

-- PACIENTE
INSERT INTO PACIENTE (id_usuario)
VALUES
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'mlopez')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'lhernandez')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'sgomez')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'mtorres')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'lrojas')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'dvargas')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'pmedina')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'jortiz')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'cnunez')),
((SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'fsalazar'));

INSERT INTO EMPLEADO (id_tipoemp, estatus_emp, id_usuario, id_jornada)
VALUES 
(7, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'mlopez'), 1),
(8, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'lhernandez'), 2),
(9, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'sgomez'), 1),
(7, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'mtorres'), 2),
(8, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'lrojas'), 1),
(9, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'dvargas'), 2),
(7, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'pmedina'), 1),
(8, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'jortiz'), 2),
(9, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'cnunez'), 1),
(7, 1, (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'fsalazar'), 2);

INSERT INTO DOCTOR (id_tipoemp, id_especialidad)
VALUES
(7, 1), (7, 2), (7, 3), (7, 4), (7, 5), (7, 6), (7, 7), (7, 8), (7, 9), (7, 10);

INSERT INTO CONSULTORIO (Estatus_consultorio)
VALUES 
(1), (1), (1), (1), (1), (1), (1), (1), (1), (1);

INSERT INTO DOCTOR_CONSULTORIO (ced_prof, Num_consult)
VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);


INSERT INTO DOCTOR_CONSULTORIO (ced_prof, Num_consult)
VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);


INSERT INTO DOCTOR_CONSULTORIO (ced_prof, Num_consult)
VALUES 
(1, 6), 
(2, 7), 
(3, 8), 
(4, 9), 
(5, 10), 
(6, 11), 
(7, 12), 
(8, 13), 
(9, 14), 
(10, 15);
---------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO ESTATUS_CITA (descrip_estatus)
VALUES 
('Pendiente por pagar'),
('Pagada (pendiente por asistir)'),
('Atendida (sí asistió)'),
('Cancelada no asistio'),
('Cancelada por el doc'),
('Cancelada por la recepcionista por solicitud del paciente');

---------------------------------------------------------------------------------------------------------------------------------------
INSERT INTO CITA (fecha_ag, hora_ag, fecha, hora, id_estatus, id_paciente)
VALUES 
('2024-12-04', '09:00:00', '2024-12-05', '09:30:00', 8,  -- Pendiente por pagar
 (SELECT id_paciente FROM PACIENTE WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'mlopez'))),
 
('2024-12-04', '10:00:00', '2024-12-06', '10:30:00', 9,  -- Pagada (pendiente por asistir)
 (SELECT id_paciente FROM PACIENTE WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'lhernandez'))),
 
('2024-12-04', '11:00:00', '2024-12-07', '11:30:00', 10,  -- Atendida (sí asistió)
 (SELECT id_paciente FROM PACIENTE WHERE id_usuario = (SELECT id_usuario FROM USUARIO WHERE nombre_usuario = 'sgomez')));
 --------------------------------------------------------------------------------------------------------------------------------------------
 INSERT INTO MEDICAMENTO (nom_med, costo_med, cantidad, descripcion)
VALUES 
('Paracetamol', 150.00, 100, 'Analgésico y antipirético'),
('Ibuprofeno', 200.00, 50, 'Antiinflamatorio no esteroideo'),
('Amoxicilina', 300.00, 75, 'Antibiótico de amplio espectro'),
('Aspirina', 120.00, 200, 'Antiinflamatorio y analgésico'),
('Omeprazol', 250.00, 80, 'Inhibidor de la bomba de protones');
------------------------------------------------------------------------------------------------------------------------------------------------






