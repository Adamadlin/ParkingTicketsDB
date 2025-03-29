-- Q1
CREATE DATABASE ParkingTickets;

CREATE TABLE inspectors (
    id INT PRIMARY KEY IDENTITY(1, 1),
    firstName VARCHAR(20) NOT NULL DEFAULT 'John',
    lastName VARCHAR(20) NOT NULL DEFAULT 'Doe',
    hireDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE)
);

CREATE TABLE tickets (
    id INT PRIMARY KEY IDENTITY(1, 1),
    ticketDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    ticketTime TIME NOT NULL DEFAULT CAST(GETDATE() AS TIME),
    inspectorId INT FOREIGN KEY REFERENCES inspectors(id),
    sum MONEY NOT NULL DEFAULT 350,
    CHECK(sum >= 150)
);

CREATE TABLE appeals (
    id INT PRIMARY KEY IDENTITY(1, 1),
    appealDate DATE NOT NULL DEFAULT CAST(GETDATE() AS DATE),
    ticketId INT FOREIGN KEY REFERENCES tickets(id),
    appealInfo VARCHAR(250) NOT NULL
);

INSERT INTO inspectors (firstName, lastName, hireDate)
VALUES 
    ('Adam', 'Adlin', '20240101'),
    ('Jacob', 'Kasa', '20240215'),
    ('Elhanan', 'Badihi', '20240401'),
    ('Guy', 'Hiyaev', '20240501');

-- Q2
INSERT INTO tickets (ticketDate, ticketTime, inspectorId, sum)
VALUES
    ('20250213', '14:00:00', 1, 240.00),
    ('20240316', '13:28:30', 1, 370.50),
    ('20250103', '17:45:01', 1, 1000.00),
    ('20240503', '20:52:03', 1, 500.00),
    ('20240708', '11:23:45', 1, 150.00),
    ('20250110', '14:10:30', 2, 210.00),
    ('20240413', '12:22:24', 2, 170.50),
    ('20241012', '18:35:05', 2, 1250.65),
    ('20240517', '21:58:59', 2, 234.60),
    ('20240812', '09:15:36', 2, 152.23),
    ('20250123', '14:00:00', 3, 240.01),
    ('20240412', '12:18:11', 3, 270.50),
    ('20240605', '14:24:04', 3, 1343.34),
    ('20240801', '22:00:06', 3, 400.00),
    ('20241111', '07:25:00', 3, 325.00),
    ('20250205', '09:12:56', 4, 194.88),
    ('20240602', '10:41:32', 4, 363.50),
    ('20240809', '12:21:32', 4, 1293.00),
    ('20241225', '00:23:03', 4, 523.00),
    ('20240711', '02:10:22', 4, 173.20);



INSERT INTO appeals (appealDate, ticketId, appealInfo)
VALUES
    ('20250224', 1, 'Appeal regarding ticket ID 1, challenging the fine amount.'),
    ('20241002', 2, 'Appeal for ticket ID 2, requesting a reduction in penalty.'),
    ('20250202', 3, 'Appeal related to ticket ID 3, questioning the details of the report.'),
    ('20240821', 4, 'Appeal concerning ticket ID 4, disputing the charges.'),
    ('20240710', 5, 'Appeal for ticket ID 5, arguing the validity of the ticket.'),
    ('20250211', 16, 'Appeal for ticket ID 16, requesting the cancellation of the fine.'),
    ('20241107', 14, 'Appeal regarding ticket ID 14, asking for a review of the decision.'),
    ('20241205', 8, 'Appeal related to ticket ID 8, disputing the amount of the fine.'),
    ('20241009', 10, 'Appeal concerning ticket ID 10, questioning the validity of the citation.'),
    ('20250127', 11, 'Appeal for ticket ID 11, requesting a reconsideration of the fine.'),
    ('20240503', 7, 'Appeal regarding ticket ID 7, challenging the legality of the ticket issued.'),
    ('20240612', 12, 'Appeal related to ticket ID 12, requesting a decrease in the fine amount.');




-- SELECT * FROM appeals
SELECT * from appeals

INSERT INTO tickets (ticketDate, ticketTime, inspectorId, sum)
VALUES
('20230212', '17:30:00', 1, 190.00)


-- q3
SELECT COUNT(t.id) as totalTickets ,SUM(t.sum) as tickets2024
from tickets t
WHERE ticketDate like '2024%'


-- q4
SELECT i.firstName , i.lastName ,COUNT(t.id)
FROM inspectors i
INNER JOIN  tickets t on t.inspectorId = i.id
WHERE ticketDate like '2024%'
GROUP BY i.firstName,i.lastName


-- q5
-- CREATE view inspectorInfo  AS
-- SELECT i.firstName.i.lastName,COUNT(t.sum) 
-- from inspectors i
-- INNER JOIN  tickets t on t.inspectorId = i.id
-- OR ticketDate like '2024%'
-- GROUP BY i.firstName,i.lastName


-- CREATE PROCEDURE inspectorInfo AS 
-- SELECT i.firstName, i.lastName, COUNT(t.id) AS totalTickets, SUM(t.sum) AS totalSum
-- FROM inspectors i
-- INNER JOIN tickets t ON t.inspectorId = i.id
-- WHERE t.ticketDate LIKE '2024%'
-- GROUP BY i.firstName, i.lastName
-- GO;



CREATE PROCEDURE inspectorInfo AS
SELECT 
    i.firstName, 
    i.lastName, 
    COUNT(t.id) AS totalTickets, 
    SUM(t.sum) AS totalSum
FROM inspectors i
INNER JOIN tickets t ON t.inspectorId = i.id
WHERE CAST(t.ticketDate AS VARCHAR) LIKE '2024%'  -- or use `t.ticketDate BETWEEN '2024-01-01' AND '2024-12-31'`
GROUP BY i.firstName, i.lastName;


EXECUTE inspectorInfo


SELECT * FROM inspectors



-- Q6 


CREATE PROCEDURE sp_avg_appeal_day
AS
BEGIN
    SELECT AVG(DATEDIFF(DAY, t.ticketDate, a.appealDate))
    FROM dbo.appeals a
    JOIN dbo.tickets t
    ON a.ticketId = t.id
END;


EXECUTE sp_avg_appeal_day


-- q7


-- CREATE PROCEDURE inspector_stats
-- AS
-- BEGIN
--     -- Query 1: Inspector with the most tickets
--     SELECT TOP 1 
--         i.firstName,
--         i.lastName AS inspector_full_name, 
--         COUNT(t.id) AS totalTickets
--     FROM inspectors i
--     INNER JOIN tickets t ON i.id = t.inspectorId
--     GROUP BY i.firstName, i.lastName, i.id
--     ORDER BY totalTickets DESC;

--     -- Query 2: Inspector who collected the biggest sum
--     SELECT TOP 1 
--         i.firstName,
--         i.lastName AS inspector_full_name, 
--         SUM(t.sum) AS totalSum
--     FROM inspectors i
--     INNER JOIN tickets t ON i.id = t.inspectorId
--     GROUP BY i.firstName, i.lastName, i.id
--     ORDER BY totalSum DESC;
-- END;



ALTER PROCEDURE sp_inspector_bonus
AS
BEGIN
    SELECT ins.firstName + ' ' + ins.lastName AS [full name]
    FROM dbo.inspectors ins
    WHERE
        ins.firstName + ' ' + ins.lastName = (
            SELECT TOP(1)
                i.firstName + ' ' + i.lastName
            FROM dbo.tickets t
            JOIN dbo.inspectors i
            ON i.id = t.inspectorId
            GROUP BY i.firstName + ' ' + i.lastName
            ORDER BY SUM(t.sum) DESC
        ) OR ins.firstName + ' ' + ins.lastName = (
            SELECT TOP(1)
                i.firstName + ' ' + i.lastName
            FROM dbo.tickets t
            JOIN dbo.inspectors i
            ON i.id = t.inspectorId
            GROUP BY i.firstName + ' ' + i.lastName
            ORDER BY COUNT(t.id) DESC
        )
END;


-- q8

CREATE PROCEDURE sp_max_appeals_inspector
AS
BEGIN
    SELECT TOP(1)
        i.firstName,
        i.lastName
    FROM dbo.appeals a
    JOIN dbo.tickets t
    ON a.ticketId = t.id
    JOIN dbo.inspectors i
    ON t.inspectorId = i.id
    GROUP BY i.firstName, i.lastName
    ORDER BY COUNT(a.id) DESC
END;




-- q9

-- CREATE PROCEDURE AddTicket
--     @inspectorId INT,       -- Input parameter for the inspectorId
--     @sum MONEY               -- Input parameter for the sum (amount of the ticket)
-- AS
-- BEGIN
--     -- Insert the new ticket into the tickets table
--     INSERT INTO tickets (ticketDate, ticketTime, inspectorId, sum)
--     VALUES (GETDATE(), GETDATE(), @inspectorId, @sum);  -- Use GETDATE() for the current date and time
-- END;

-- EXEC AddTicket @inspectorId = 1, @sum = 2000.00;


CREATE PROCEDURE sp_insert_ticket
    @inspectorId INT,
    @sum MONEY
AS
BEGIN
    BEGIN TRANSACTION;

    BEGIN TRY
        IF @inspectorId NOT IN (SELECT i.id FROM dbo.inspectors i) BEGIN
            RAISERROR('Inspector ID must exist in inspectors table.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @sum < 150 BEGIN
            RAISERROR('Minimum sum for ticket is 150.00', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        INSERT INTO dbo.tickets (inspectorId, sum)
        VALUES (@inspectorId, @sum);

        COMMIT TRANSACTION;
        PRINT 'Ticket inserted successfully.';
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred while inserting the ticket.';
        PRINT ERROR_MESSAGE();
        ROLLBACK TRANSACTION;
    END CATCH
END;






-- q10
CREATE FUNCTION GetAppealsWithinDateRange
(
    @date1 DATE,  -- Start date
    @date2 DATE   -- End date
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        a.id AS appealId,
        i.firstName + ' ' + i.lastName AS inspector_full_name,  -- Inspector's full name
        t.sum AS ticket_sum,      -- Sum of the ticket
        a.appealInfo AS description -- Appeal description
    FROM appeals a
    INNER JOIN tickets t ON a.ticketId = t.id  -- Join to tickets table to get ticket information
    INNER JOIN inspectors i ON t.inspectorId = i.id  -- Join to inspectors table to get inspector info
    WHERE a.appealDate BETWEEN @date1 AND @date2  -- Filter by date range
    ORDER BY a.appealDate  -- Order by appeal date
);






