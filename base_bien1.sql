USE HOSPITAL;

CREATE TABLE DATOSP(
	id_Datosp INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	nombre NVARCHAR(15) NOT NULL,		--nombres de las personas
	ap_paterno NVARCHAR(10) NOT NULL,	--apellido paterno
	ap_marerno NVARCHAR(10) NOT NULL,	--apellido materno 
	fecha_nacimiento DATE NOT NULL,
	TELEFONO INT NOT NULL,
	correo NVARCHAR(25) NOT NULL,
	edad INT NOT NULL,
	curp NVARCHAR(18) NOT NULL,	-- curp de las personas
);

CREATE TABLE TIPO_USUARIO(
	id_tipousuario INT IDENTITY (1,1) NOT NULL PRIMARY KEY ,
	Descr_Tip_Usu INT NOT NULL,
);

CREATE TABLE USUARIO (
	id_usuario INT IDENTITY (1,1) NOT NULL  PRIMARY KEY ,
	contraseña NVARCHAR(15) NOT NULL,
	nombre_usuario NVARCHAR(15) NOT NULL,
	id_tipousuario INT not null,
	CONSTRAINT FK_id_tipousuario FOREIGN KEY(id_tipousuario) --foreign key 
	REFERENCES TIPO_USUARIO (id_tipousuario),
	id_datosp INT not null,
	CONSTRAINT FK_id_Datosp FOREIGN KEY(id_Datosp) --foreign key 
	REFERENCES DATOSP (id_Datosp),
);

CREATE TABLE PACIENTE(
	id_paciente INT IDENTITY (1,1) PRIMARY KEY NOT NULL ,
	id_usuario INT not null,
	CONSTRAINT FK_id_usuario FOREIGN KEY (id_usuario) --foreign key 
	REFERENCES USUARIO (id_usuario),
);

CREATE TABLE JORNADA (
	id_jornada INT IDENTITY (1,1) PRIMARY KEY NOT NULL,
	turno INT NOT NULL,
	Hora_inicio time not null,
	Hora_fin time not null,
	turno_inicio TIME NOT NULL,
	turno_fin TIME NOT NULL, 
);

CREATE TABLE TIPO_EMPLEADO(
	id_tipoemp INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
	tipo_emp INT NOT NULL,
);


CREATE TABLE EMPLEADO(
    id_empleado INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_tipoemp INT not null,
    CONSTRAINT FK_EMPLEADO_TIPOEMP FOREIGN KEY(id_tipoemp) 
    REFERENCES TIPO_EMPLEADO (id_tipoemp),
    id_jornada INT not null,
    CONSTRAINT FK_EMPLEADO_JORNADA FOREIGN KEY(id_jornada) 
    REFERENCES JORNADA (id_jornada),
    id_usuario INT not null,
    CONSTRAINT FK_EMPLEADO_USUARIO FOREIGN KEY (id_usuario) 
    REFERENCES USUARIO (id_usuario),
);

CREATE TABLE RECEPCIONISTA (
    id_recepcionista INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    id_tipoemp INT not null,
    CONSTRAINT FK_RECEPCIONISTA_TIPOEMP FOREIGN KEY(id_tipoemp) 
    REFERENCES TIPO_EMPLEADO (id_tipoemp),
);

CREATE TABLE ESPECIALIDAD (
	id_especialidad INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	costo MONEY NOT NULL,
);

CREATE TABLE DOCTOR (
	ced_prof INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	id_tipoemp INT not null,
    CONSTRAINT FK_DOCTOR_TIPOEMP FOREIGN KEY(id_tipoemp) 
    REFERENCES TIPO_EMPLEADO (id_tipoemp),
    id_especialidad INT not null,
    CONSTRAINT FK_DOCTOR_ESPECIALIDAD FOREIGN KEY(id_especialidad) 
    REFERENCES ESPECIALIDAD (id_especialidad),
);

CREATE TABLE CONSULTORIO(
	Num_consult INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	Estatus_consultorio Bit,
);

CREATE TABLE DOCTOR_CONSULTORIO(
	id_doc_consul INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	ced_prof INT not null,
    CONSTRAINT FK_DOCTOR_DOCTCONSULT FOREIGN KEY(ced_prof) 
    REFERENCES DOCTOR (ced_prof),
	Num_consult INT not null,
    CONSTRAINT FK_CONSULTORIO_DCONSULT FOREIGN KEY(Num_consult) 
    REFERENCES CONSULTORIO (Num_consult),
);

CREATE TABLE FARMACEUTICO(
	id_farmaceutico INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	id_empleado INT not null,
    CONSTRAINT FK_EMPLEADO_FARMACEUTICO FOREIGN KEY(id_empleado) 
    REFERENCES EMPLEADO (id_empleado),
);

CREATE TABLE MEDICAMENTO(
	id_medicamento INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	nom_med NVARCHAR(50),
	costo_med money,
	cantidad INT,
	descripcion NVARCHAR(50),
);

CREATE TABLE SERVICIO(
	id_servicio INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	costo money,
	Tipo_Servicio INT,
	Descripcion_serv NVARCHAR(50)
);

CREATE TABLE TICKET(
	id_ticket INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	cant_serv INT,
	cant_med INT,
	Fecha_Hora DATETIME,
	id_servicio INT,
	CONSTRAINT FK_SERVICIO_TICKET FOREIGN KEY(id_servicio) 
    REFERENCES SERVICIO (id_servicio),
	id_medicamento INT,
	CONSTRAINT FK_MEDICAMENTO_TICKET FOREIGN KEY(id_medicamento) 
    REFERENCES MEDICAMENTO (id_medicamento),
	id_farmaceutico INT,
	CONSTRAINT FK_FARMACEUTICO_TICKET FOREIGN KEY(id_farmaceutico) 
    REFERENCES FARMACEUTICO (id_farmaceutico),
);

CREATE TABLE PAGO_FARMACIA(
	folio INT IDENTITY (1,1)NOT NULL PRIMARY KEY,
	total money,
	estatuts BIT,
	id_ticket INT,
	CONSTRAINT FK_TICKET_PAGO_FARMACIA FOREIGN KEY(id_ticket) 
    REFERENCES TICKET (id_ticket),
);

CREATE TABLE ESTATUS_CITA (
	id_estatus INT IDENTITY (1,1) PRIMARY KEY,
	descrip_estatus INT not null,

);

CREATE TABLE CITA(
	folio INT IDENTITY (1,1) NOT NULL PRIMARY KEY,
	fecha_ag DATE,
	Hora_ag TIME,
	fecha DATE,
	hora TIME,
	id_estatus INT,
	CONSTRAINT FK_CITA_ESTATUS FOREIGN KEY(id_estatus) 
    REFERENCES ESTATUS_CITA (id_estatus),
	id_paciente INT,
	CONSTRAINT FK_PACIENTE_ESTATUS FOREIGN KEY(id_paciente) 
    REFERENCES PACIENTE (id_paciente),
);

CREATE TABLE RECETA (
	id_receta INT IDENTITY (1,1) not null PRIMARY KEY,
	observacion NVARCHAR(50),
	diagnostico NVARCHAR(50),
	tratamiento NVARCHAR(50),
	folio INT,
	CONSTRAINT FK_CITA_RECETA FOREIGN KEY(folio) 
    REFERENCES CITA (folio),

);

CREATE TABLE PAGO(
	id_pago INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	monto_dev MONEY ,
	SI_NO_POL_CANC BIT,
);

CREATE TABLE COMPROBANTE (
	id_comprobante INT IDENTITY(1,1) NOT NULL PRIMARY KEY ,
	fecha datetime,
	id_pago INT,
	CONSTRAINT FK_COMPROBANTE_PAGO FOREIGN KEY(id_pago) 
    REFERENCES PAGO (id_pago),
	folio INT,
	CONSTRAINT FK_CITA_COMPORBANTE FOREIGN KEY(folio) 
    REFERENCES CITA (folio),
);
