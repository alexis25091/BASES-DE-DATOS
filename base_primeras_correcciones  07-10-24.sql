USE NEW_HOSPITAL;

CREATE TABLE USUARIOS(
	id_usuario INT PRIMARY KEY IDENTITY (1,1),
	usuario NVARCHAR(10),
	contraseña NVARCHAR(10)
);


CREATE TABLE EMPLEADOS(
	id_empleado INT PRIMARY KEY	IDENTITY (1,1), --identificador unico
	id_usuario INT FOREIGN KEY REFERENCES USUARIOS (id_usuario),
	nombre NVARCHAR(10) NOT NULL,	--nombre de los empleados()creo que se puede omitir por el nombre que se inserta de cada uno de los demas usuarios de las demas tablas
);

CREATE TABLE JORNADA(
	id_jornada INT PRIMARY KEY IDENTITY(1,1),
	hora_inicio TIME NOT NULL,
	hora_fin TIME NOT NULL,
	dia_laborable NVARCHAR NOT NULL,
	id_empleado INT FOREIGN KEY REFERENCES EMPLEADOS (id_empleado)
);

CREATE TABLE DATOSP(
	id_datos INT PRIMARY KEY IDENTITY(1,1),
	nombre NVARCHAR(15) NOT NULL,		--nombres de las personas
	apellido_p NVARCHAR(10) NOT NULL,	--apellido paterno
	apellido_m Nvarchar(10) NOT NULL,	--apellido materno 
	curp_p NVARCHAR(18) NOT NULL,	-- curp de las personas
	fecha_nacim DATE NOT NULL,
	edad INT NOT NULL,
	IMC FLOAT NOT NULL,
);



CREATE TABLE ESPECIALIDADES(
	id_especialidad INT PRIMARY KEY IDENTITY(1,1),	--identificador unico
	num_esp INT NOT NULL,

);

CREATE TABLE NOMBREESP(
	id_nombreesp INT PRIMARY KEY IDENTITY(1,1),
	nom_esp NVARCHAR(15)NOT NULL,	--nombres de las especialidades
	id_especialidad INT FOREIGN KEY REFERENCES ESPECIALIDADES (id_especialidad)
);

CREATE TABLE COMPROBANTES(
	id_comprobante INT PRIMARY KEY IDENTITY(1,1),
	--especialidad, consultorio, nobre del que saco la cita
	fecha DATE NOT NULL,	--para guardar la fecha de la cita que se hizo
	hora TIME NOT NULL,	--hora de las citas que se hicieron
    estado NVARCHAR(10) NOT NULL,	--estado activa o cancelada
);

CREATE TABLE BITACORA (
    id_bitacora INT PRIMARY KEY IDENTITY(1,1),	--identificador unico
	tipo_mov NVARCHAR(10), --asignación de cita o cancelacion
	id_comprobante INT FOREIGN KEY REFERENCES COMPROBANTES (id_comprobante),
    fecha DATE NOT NULL,
	hora TIME NOT NULL,	
	dia NVARCHAR(10) NOT NULL
);

CREATE TABLE PACIENTES (
    id_paciente INT PRIMARY KEY IDENTITY(1,1),  --identificador unico
    id_bitacora INT FOREIGN KEY REFERENCES BITACORA (id_bitacora),
	id_datos INT FOREIGN KEY REFERENCES DATOSP (id_datos),
    id_usuario INT FOREIGN KEY REFERENCES USUARIOS (id_usuario),
);

CREATE TABLE CITAS (
    id_cita INT PRIMARY KEY IDENTITY(1,1),	--identificador unico
	id_paciente INT FOREIGN KEY REFERENCES PACIENTES (id_paciente),		--para la llave foranea
	id_bitacora INT FOREIGN KEY REFERENCES BITACORA (id_bitacora),
	id_comprobante INT FOREIGN KEY REFERENCES COMPROBANTES (id_comprobante),
	id_especialidad INT FOREIGN KEY REFERENCES ESPECIALIDADES (id_especialidad)
);

CREATE TABLE PAGOS (
    id_pago INT PRIMARY KEY IDENTITY(1,1),--identificador unico
    monto DECIMAL(10, 2) NOT NULL,--monto a pagar ya sea sobre la cita o algo mas
    estado NVARCHAR(10) NOT NULL,--estado del pago (pagado o sin pagar)
	id_comprobante INT FOREIGN KEY REFERENCES COMPROBANTES (id_comprobante)
);

CREATE TABLE SERVICIOS (
    id_servicio INT PRIMARY KEY IDENTITY(1,1),  --identificador unico
    id_pago INT FOREIGN KEY REFERENCES PAGOS (id_pago),  --llave foránea de los pagos
    id_cita INT FOREIGN KEY REFERENCES CITAS(id_cita),  --llave foránea de citas
    nombre_ser NVARCHAR(15) NOT NULL,  --nombre de los servicios
    descripcion NVARCHAR(MAX)  --descripción del servicio
);

CREATE TABLE RECETAS (
    id_receta INT PRIMARY KEY IDENTITY(1,1),	--identificador unico
    diagnostico NVARCHAR(MAX) NOT NULL,		--descripcion que llevaria la receta como padecimientos y de mas cosas que pueda poner un doctor
	tratamiento NVARCHAR(MAX) NOT NULL,
	id_servicio INT FOREIGN KEY REFERENCES SERVICIOS (id_servicio),
	id_paciente INT FOREIGN KEY REFERENCES PACIENTES (id_paciente),		--para la llave foranea
);

CREATE TABLE DATOSPROF (
	id_datosprofesionales INT PRIMARY KEY IDENTITY(1,1),
	cedula NVARCHAR(10) NOT NULL,
	id_especialidad INT FOREIGN KEY REFERENCES ESPECIALIDADES (id_especialidad),  --ahora relacionada con la tabla ESPECIALIDADES
	licencia_sanitaria INT NOT NULL,
	tel INT NOT NULL,
	correo NVARCHAR(15)
); 

CREATE TABLE DOCTORES (
    id_doctor INT PRIMARY KEY IDENTITY(1,1),   --identificador unico
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADOS (id_empleado),  --llave foranea
    id_receta INT FOREIGN KEY REFERENCES RECETAS (id_receta),
    id_datos INT FOREIGN KEY REFERENCES DATOSP (id_datos),
	id_usuario INT FOREIGN KEY REFERENCES USUARIOS (id_usuario),
    id_cita INT FOREIGN KEY REFERENCES CITAS(id_cita),  --para el uso de la llave foranea
	id_datosprofesionales INT FOREIGN KEY REFERENCES DATOSPROF (id_datosprofesionales)
);

CREATE TABLE SECRETARIA (
    id_secretaria INT PRIMARY KEY IDENTITY(1,1),  --identificador unico
    id_datos INT FOREIGN KEY REFERENCES DATOSP (id_datos),
    id_empleado INT FOREIGN KEY REFERENCES EMPLEADOS (id_empleado),
	id_comprobante INT FOREIGN KEY REFERENCES COMPROBANTES (id_comprobante)
);


CREATE TABLE CONSULTORIOS (
    id_consultorio INT PRIMARY KEY IDENTITY(1,1),  --identificador unico
    id_cita INT FOREIGN KEY REFERENCES CITAS(id_cita),  --LLAVE FORANEA DE CITAS
    nombre_c NVARCHAR(10) NOT NULL,  --consultorio "tal"
    num_consult TINYINT NOT NULL,  --numeración de los consultorios
    ubicacion NVARCHAR(20) NOT NULL,  --ubicación del consultorio
	id_doctor INT FOREIGN KEY REFERENCES DOCTORES (id_doctor)
);

CREATE TABLE MEDICAMENTOS (
    id_medicamento INT PRIMARY KEY IDENTITY(1,1),	--identificador unico
	id_receta INT FOREIGN KEY REFERENCES RECETAS (id_receta),
	id_pago INT FOREIGN KEY REFERENCES PAGOS (id_pago),
    nombre NVARCHAR(15) NOT NULL,	--nombre de los medicamentos
    descripcion NVARCHAR(MAX)	--descripcion de los medicamentos como gramaje y de mas (se podria omitir)
);

CREATE TABLE FARMACIA (
    id_farm INT PRIMARY KEY IDENTITY(1,1),
    cant_medicamnetos INT NOT NULL,
    costo_medicamento FLOAT NOT NULL,
    id_medicamento INT FOREIGN KEY REFERENCES MEDICAMENTOS (id_medicamento)
);

CREATE TABLE COBRO (
	id_cobro INT PRIMARY KEY IDENTITY (1,1),
	id_medicamento INT FOREIGN KEY REFERENCES MEDICAMENTOS (id_medicamento),
	cant_compra INT NOT NULL,
	total FLOAT NOT NULL,
	id_farm INT FOREIGN KEY REFERENCES FARMACIA (id_farm),
	id_comprobante INT FOREIGN KEY REFERENCES COMPROBANTES (id_comprobante)

);
