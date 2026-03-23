-- Estructura del Proyecto 

CREATE DATABASE Proyecto_AI_Market;

-- Creacion del Sript 

-- 1. Crear el esquema
CREATE DATABASE IF NOT EXISTS AI_JobMarket_DB;
USE AI_JobMarket_DB;

-- 2. Tabla de Dimensiones: Empresas
CREATE TABLE Dim_Company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_size VARCHAR(50),
    company_industry VARCHAR(100)
);

-- 3. Tabla de Dimensiones: Ubicación
CREATE TABLE Dim_Location (
    location_id INT AUTO_INCREMENT PRIMARY KEY,
    country VARCHAR(100)
);

-- 4. Tabla de Dimensiones: Roles y Requisitos
CREATE TABLE Dim_Job_Roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    job_title VARCHAR(150),
    experience_level VARCHAR(50),
    education_level VARCHAR(50)
);

-- 5. Tabla de Hechos: Postulaciones (Fact_Postings)
-- Aquí almacenamos las métricas y las llaves foráneas
CREATE TABLE Fact_Postings (
    id_registro INT AUTO_INCREMENT PRIMARY KEY,
    job_id_original INT, -- ID que viene del CSV para trazabilidad
    role_id INT,
    company_id INT,
    location_id INT,
    remote_type VARCHAR(50),
    years_experience INT,
    skills_python TINYINT(1), -- Booleanos representados como 0 o 1
    skills_sql TINYINT(1),
    skills_ml TINYINT(1),
    skills_deep_learning TINYINT(1),
    skills_cloud TINYINT(1),
    salary DECIMAL(15,2),
    hiring_urgency VARCHAR(50),
    job_openings INT,
    posting_date DATE, -- Combinaremos mes y año del CSV aquí
    FOREIGN KEY (role_id) REFERENCES Dim_Job_Roles(role_id),
    FOREIGN KEY (company_id) REFERENCES Dim_Company(company_id),
    FOREIGN KEY (location_id) REFERENCES Dim_Location(location_id)
);

