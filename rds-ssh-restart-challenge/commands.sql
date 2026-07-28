-- RDS SSH Challenge — SQL commands

-- Create and select a working database
CREATE DATABASE restart_lab;
USE restart_lab;

-- 1. Create the RESTART table
CREATE TABLE RESTART (
  StudentID INT NOT NULL,
  StudentName VARCHAR(100) NOT NULL,
  RestartCity VARCHAR(100) NOT NULL,
  GraduationDate DATETIME NOT NULL,
  PRIMARY KEY (StudentID)
);

-- 2. Insert 10 sample rows
INSERT INTO RESTART VALUES (1, 'Ana Silva', 'São Paulo', '2024-03-15 10:00:00');
INSERT INTO RESTART VALUES (2, 'Bruno Costa', 'Rio de Janeiro', '2024-03-15 10:00:00');
INSERT INTO RESTART VALUES (3, 'Carla Souza', 'Belo Horizonte', '2024-03-15 10:00:00');
INSERT INTO RESTART VALUES (4, 'Daniel Oliveira', 'Curitiba', '2024-06-20 14:30:00');
INSERT INTO RESTART VALUES (5, 'Eduarda Lima', 'Porto Alegre', '2024-06-20 14:30:00');
INSERT INTO RESTART VALUES (6, 'Felipe Santos', 'Salvador', '2024-06-20 14:30:00');
INSERT INTO RESTART VALUES (7, 'Gabriela Alves', 'Recife', '2024-09-10 09:00:00');
INSERT INTO RESTART VALUES (8, 'Hugo Pereira', 'Fortaleza', '2024-09-10 09:00:00');
INSERT INTO RESTART VALUES (9, 'Isabela Rocha', 'Brasília', '2024-09-10 09:00:00');
INSERT INTO RESTART VALUES (10, 'João Martins', 'Manaus', '2024-12-05 16:00:00');

-- 3. Select all rows
SELECT * FROM RESTART;

-- 4. Create the CLOUD_PRACTITIONER table
CREATE TABLE CLOUD_PRACTITIONER (
  StudentID INT NOT NULL,
  CertificationDate DATETIME NOT NULL,
  PRIMARY KEY (StudentID)
);

-- 5. Insert 5 sample rows (StudentIDs also present in RESTART)
INSERT INTO CLOUD_PRACTITIONER VALUES (1, '2024-04-01 10:00:00');
INSERT INTO CLOUD_PRACTITIONER VALUES (3, '2024-04-15 11:00:00');
INSERT INTO CLOUD_PRACTITIONER VALUES (5, '2024-07-10 09:30:00');
INSERT INTO CLOUD_PRACTITIONER VALUES (7, '2024-10-01 15:00:00');
INSERT INTO CLOUD_PRACTITIONER VALUES (9, '2024-11-20 13:45:00');

-- 6. Select all rows
SELECT * FROM CLOUD_PRACTITIONER;

-- 7. Inner join: student ID, student name, and certification date
SELECT RESTART.StudentID, RESTART.StudentName, CLOUD_PRACTITIONER.CertificationDate
FROM RESTART
INNER JOIN CLOUD_PRACTITIONER ON RESTART.StudentID = CLOUD_PRACTITIONER.StudentID;
