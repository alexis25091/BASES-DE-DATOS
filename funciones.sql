use HOSPITAL;

/*funcion 1: calcular edad
Propósito: Calcula la edad exacta de una persona basándose en su fecha de nacimiento, 
teniendo en cuenta el mes y día exactos.*/

CREATE FUNCTION dbo.CalcularEdad
(
    @FechaNacimiento DATE
)
RETURNS INT
AS
BEGIN
    DECLARE @Edad INT

    SET @Edad = DATEDIFF(YEAR, @FechaNacimiento, GETDATE()) - 
                CASE 
                    WHEN (MONTH(@FechaNacimiento) > MONTH(GETDATE())) OR 
                         (MONTH(@FechaNacimiento) = MONTH(GETDATE()) AND 
                          DAY(@FechaNacimiento) > DAY(GETDATE()))
                    THEN 1 
                    ELSE 0 
                END

    RETURN @Edad
END


/*funcion 2: 
Función para Verificar Disponibilidad de Consultorio
*/
CREATE FUNCTION dbo.VerificarDisponibilidadConsultorio
(
    @NumConsultorio INT,
    @Fecha DATE,
    @Hora TIME
)
RETURNS BIT
AS
BEGIN
    DECLARE @Disponible BIT;

    -- Verificar si el consultorio está ocupado en la fecha y hora específicas
    IF EXISTS (
        SELECT 1 
        FROM CITA c
        JOIN PACIENTE p ON c.id_paciente = p.id_paciente -- Unimos con paciente para validar
        JOIN DOCTOR d ON d.ced_prof = p.id_usuario -- Unimos con el doctor correspondiente
        WHERE c.fecha = @Fecha AND c.hora = @Hora
        AND EXISTS (
            SELECT 1 
            FROM DOCTOR_CONSULTORIO dc
            WHERE dc.Num_consult = @NumConsultorio
            AND dc.ced_prof = d.ced_prof  -- Verificamos que el doctor esté asignado al consultorio
        )
    )
    BEGIN
        SET @Disponible = 0;  -- No disponible
    END
    ELSE
    BEGIN
        SET @Disponible = 1;  -- Disponible
    END

    RETURN @Disponible;
END;

/*funcion 3:
funcion que calcula el pago total del ticket */

CREATE FUNCTION fn_calcular_costo_total_ticket (@id_ticket INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @total MONEY;

    -- Calcular el costo total de los servicios y medicamentos en el ticket
    SELECT @total = 
        (SELECT s.costo * t.cant_serv FROM TICKET t 
         JOIN SERVICIO s ON t.id_servicio = s.id_servicio 
         WHERE t.id_ticket = @id_ticket)
        +
        (SELECT SUM(m.costo_med * t.cant_med) FROM TICKET t
         JOIN MEDICAMENTO m ON t.id_medicamento = m.id_medicamento
         WHERE t.id_ticket = @id_ticket);

    RETURN ISNULL(@total, 0);
END;

/*funcion 4:
para la politica dl reembolso*/

CREATE FUNCTION dbo.CalcularReembolsoCita
(
    @id_cita INT
)
RETURNS MONEY
AS
BEGIN
    DECLARE @reembolso MONEY;
    DECLARE @hora_actual DATETIME;
    DECLARE @hora_cita DATETIME;
    DECLARE @diferencia_horas INT;

    -- Obtener la hora actual y la hora de la cita
    SET @hora_actual = GETDATE();  -- Hora y fecha actuales

    -- Convertir la fecha y la hora de la cita a un valor DATETIME
    SELECT @hora_cita = CAST(c.fecha AS DATETIME) + CAST(c.hora AS DATETIME)
    FROM CITA c
    WHERE c.folio = @id_cita;

    -- Calcular la diferencia en horas entre la hora de la cita y la hora actual
    SET @diferencia_horas = DATEDIFF(HOUR, @hora_actual, @hora_cita);

    -- Determinar el porcentaje de reembolso
    IF @diferencia_horas >= 48
    BEGIN
        SET @reembolso = 1.00;  -- 100% de reembolso
    END
    ELSE IF @diferencia_horas >= 24
    BEGIN
        SET @reembolso = 0.50;  -- 50% de reembolso
    END
    ELSE
    BEGIN
        SET @reembolso = 0.00;  -- 0% de reembolso
    END

    -- Devolver el porcentaje de reembolso
    RETURN @reembolso;
END;
