
-- Fase 3: Normalización y Modelado en Estrella.
-- Paso 1: Poblar las Tablas de Dimensiones

USE AI_JobMarket_DB;

-- 1. Llenar Dim_Company (Tamaños e Industrias únicas)
INSERT INTO Dim_Company (company_size, company_industry)
SELECT DISTINCT company_size, company_industry FROM stg_ai_market;

-- 2. Llenar Dim_Location (Países únicos)
INSERT INTO Dim_Location (country)
SELECT DISTINCT country FROM stg_ai_market;

-- 3. Llenar Dim_Job_Roles (Roles, niveles y educación únicos)
INSERT INTO Dim_Job_Roles (job_title, experience_level, education_level)
SELECT DISTINCT job_title, experience_level, education_level FROM stg_ai_market;

-- Paso 2: El "Gran Salto" a la Fact Table

INSERT INTO Fact_Postings (
    job_id_original, role_id, company_id, location_id, remote_type, 
    years_experience, skills_python, skills_sql, skills_ml, 
    skills_deep_learning, skills_cloud, salary, hiring_urgency, 
    job_openings, posting_date
)
SELECT 
    s.job_id, r.role_id, c.company_id, l.location_id, s.remote_type,
    s.years_experience, s.skills_python, s.skills_sql, s.skills_ml,
    s.skills_deep_learning, s.skills_cloud, s.salary, s.hiring_urgency,
    s.job_openings, 
    -- Transformamos mes y año en una fecha real (día 1 del mes)
    STR_TO_DATE(CONCAT(s.job_posting_year, '-', s.job_posting_month, '-01'), '%Y-%m-%d')
FROM stg_ai_market s
JOIN Dim_Job_Roles r ON s.job_title = r.job_title 
    AND s.experience_level = r.experience_level 
    AND s.education_level = r.education_level
JOIN Dim_Company c ON s.company_size = c.company_size 
    AND s.company_industry = c.company_industry
JOIN Dim_Location l ON s.country = l.country;

-- Paso 3: Verificación de Integridad del Modelo

-- Suma en Staging
SELECT SUM(salary) FROM stg_ai_market;

-- Suma en Fact Table (Debe ser igual)
SELECT SUM(salary) FROM Fact_Postings;