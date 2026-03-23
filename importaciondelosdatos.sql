
-- Importación de los Datos

-- 1 Creacion de la tabla espejo

CREATE TABLE stg_ai_market (
    job_id INT,
    job_title VARCHAR(255),
    company_size VARCHAR(255),
    company_industry VARCHAR(255),
    country VARCHAR(255),
    remote_type VARCHAR(255),
    experience_level VARCHAR(255),
    years_experience INT,
    education_level VARCHAR(255),
    skills_python INT,
    skills_sql INT,
    skills_ml INT,
    skills_deep_learning INT,
    skills_cloud INT,
    salary DECIMAL(15,2),
    job_posting_month INT,
    job_posting_year INT,
    hiring_urgency VARCHAR(255),
    job_openings INT
);

-- 2 importacion de los datos

SET GLOBAL local_infile = 1;

USE AI_JobMarket_DB;

TRUNCATE TABLE stg_ai_market;

LOAD DATA LOCAL INFILE 'C:/Users/000/Desktop/Proyecto Plantilla de Costo/Analisis de Datos/Portafolio/Job Market/AI_Job_Market_Dataset.csv'
INTO TABLE stg_ai_market
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
IGNORE 1 ROWS;