/* Vista 1: Vista de citas de pacientes
Proposito: Esta vista mostraro las citas de los pacientes que han sido registradas en el sistema, 
pero solo mostrar las citas del propio paciente (el paciente solo podra ver y cancelar sus propias citas). 
Ademas, no se permite ver recetas ni informacion de otros pacientes. */
use HOSPITAL;

CREATE VIEW Vista_Citas_Paciente AS
SELECT 
    c.folio AS Cita_Folio,
    c.fecha_ag AS Fecha_Agendada,
    c.Hora_ag AS Hora_Agendada,
    c.fecha AS Fecha_Cita,
    c.hora AS Hora_Cita,
    ec.descrip_estatus AS Estatus_Cita
FROM 
    CITA c
JOIN 
    ESTATUS_CITA ec ON c.id_estatus = ec.id_estatus
WHERE 
    c.id_paciente = (SELECT id_paciente FROM PACIENTE WHERE id_usuario = USER_ID()); -- Limita a citas del paciente actual

/*Vista 2: de Servicios y Tickets
Proposito: Proporciona una vista detallada de los tickets, mostrando informacion de los servicios y 
medicamentos asociados.*/
CREATE OR ALTER VIEW VW_ServiciosTickets AS
SELECT 
    t.id_ticket,
    t.Fecha_Hora,
    t.cant_serv AS cantidad_servicios,
    t.cant_med AS cantidad_medicamentos,
    s.Tipo_Servicio,
    s.Descripcion_serv AS descripcion_servicio,
    s.costo AS costo_servicio,
    m.nom_med AS nombre_medicamento,
    m.costo_med AS costo_medicamento,
    pf.id_farmaceutico,
    pf.estatuts
FROM TICKET t
JOIN SERVICIO s ON t.id_servicio = s.id_servicio
JOIN MEDICAMENTO m ON t.id_medicamento = m.id_medicamento
JOIN PAGO_FARMACIA pf ON pf.id_ticket = t.id_ticket;



CREATE PROCEDURE SP_GetActiveTicket
    @id_paciente INT,
    @id_farmaceutico INT
AS
BEGIN
    -- Seleccionar el ticket más reciente del paciente y el farmacéutico activo
    SELECT 
        t.id_ticket,
        t.Fecha_Hora,
        t.cant_serv AS cantidad_servicios,
        t.cant_med AS cantidad_medicamentos,
        s.Tipo_Servicio,
        s.Descripcion_serv AS descripcion_servicio,
        s.costo AS costo_servicio,
        m.nom_med AS nombre_medicamento,
        m.costo_med AS costo_medicamento
    FROM TICKET t
    JOIN SERVICIO s ON t.id_servicio = s.id_servicio
    JOIN MEDICAMENTO m ON t.id_medicamento = m.id_medicamento
    JOIN PAGO_FARMACIA pf ON pf.id_ticket = t.id_ticket
    WHERE pf.id_farmaceutico = @id_farmaceutico
      AND pf.estatuts = 0 -- Pendiente de cobro
      AND EXISTS (
          SELECT 1
          FROM PACIENTE p
          WHERE p.id_paciente = @id_paciente
            AND p.id_paciente = t.id_ticket -- Relacionar paciente con el ticket
      )
    ORDER BY t.Fecha_Hora DESC; -- Mostrar el ticket más reciente
END;



/*Vista 3: de datos del paciente (solo lectura para secretarias)
Proposito: Esta vista permite a las secretarias ver los datos de los pacientes, 
pero no permite que editen ni vean informacion sensible como las recetas mdicas.*/

CREATE VIEW Vista_Datos_Paciente AS
SELECT 
    d.id_Datosp AS ID_Paciente,
    d.nombre AS Nombre,
    d.ap_paterno AS Apellido_Paterno,
    d.ap_marerno AS Apellido_Materno,
    d.fecha_nacimiento AS Fecha_Nacimiento,
    d.telefono AS Telefono,
    d.correo AS Correo,
    d.edad AS Edad,
    d.curp AS CURP
FROM 
    DATOSP d
JOIN 
    USUARIO u ON d.id_Datosp = u.id_datosp
JOIN 
    PACIENTE p ON u.id_usuario = p.id_usuario
WHERE 
    u.id_tipousuario = 2;  -- Limita solo a los usuarios de tipo "Paciente"

/* Vsta 4: 
Vista_Citas_Doctor
Esta vista permitira a un doctor ver todas las citas agendadas en su especialidad, 
con la informacion del paciente que tiene la cita, la fecha y hora de la cita, y el estatus de la misma. 
El doctor solo podra ver las citas en las que el esta involucrado (es decir, aquellas que estan asociadas a su 
especialidad y consultorio).
*/

CREATE OR ALTER VIEW Vista_Citas_Doctor AS
SELECT 
    c.folio AS Cita_Folio,
    c.fecha_ag AS Fecha_Agendada,
    c.Hora_ag AS Hora_Agendada,
    c.fecha AS Fecha_Cita,
    c.hora AS Hora_Cita,
    ec.descrip_estatus AS Estatus_Cita,
    d.nombre AS Nombre_Paciente,               
    d.ap_paterno AS Apellido_Paterno_Paciente, 
    d.ap_marerno AS Apellido_Materno_Paciente
FROM 
    CITA c
JOIN 
    ESTATUS_CITA ec ON c.id_estatus = ec.id_estatus
JOIN 
    PACIENTE p ON c.id_paciente = p.id_paciente
JOIN 
    DATOSP d ON p.id_usuario = d.id_Datosp    -- Información del paciente
JOIN 
    DOCTOR_CONSULTORIO dc ON dc.ced_prof = p.id_usuario -- Relación con el doctor
WHERE 
    c.fecha = CAST(GETDATE() AS DATE) -- Solo citas del día actual
    AND c.hora > CAST(GETDATE() AS TIME) -- Solo citas pendientes en el día
    AND dc.Num_consult IN (
        SELECT Num_consult
        FROM DOCTOR_CONSULTORIO
        WHERE ced_prof = p.id_usuario
);
