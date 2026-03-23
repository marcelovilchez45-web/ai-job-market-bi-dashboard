-- Consultas del Caso
USE ai_jobmarket_db;

-- 👉 Vista de detalle (drill-through / auditoría)

CREATE OR REPLACE VIEW vw_powerbi_master_audit AS
SELECT 
    f.job_id_original,
    f.posting_date,
    f.salary,
    f.job_openings,
    f.remote_type,
    f.hiring_urgency,
    f.years_experience,
    l.country,
    c.company_industry,
    r.job_title,
    r.education_level,
    f.skills_python,
    f.skills_sql,
    f.skills_cloud
FROM Fact_Postings f
JOIN Dim_Location l ON f.location_id = l.location_id
JOIN Dim_Company c ON f.company_id = c.company_id
JOIN Dim_Job_Roles r ON f.role_id = r.role_id;


-- 2. Vistas para Nuestro Reporte de Power BI

-- 1. Vista de KPIs Ejecutivos

-- 👉 Para tarjetas y métricas globales

CREATE OR REPLACE VIEW vw_kpi_summary AS
SELECT 
    COUNT(*) AS total_jobs,
    SUM(job_openings) AS total_openings,
    AVG(salary) AS avg_salary,
    ROUND(100 * SUM(skills_python)/COUNT(*),2) AS pct_python,
    ROUND(100 * SUM(skills_sql)/COUNT(*),2) AS pct_sql,
    ROUND(100 * SUM(skills_ml)/COUNT(*),2) AS pct_ml
FROM Fact_Postings;

-- Prueba de Visualización

SELECT * FROM vw_kpi_summary;

-- 2. Vista de Tendencias Temporales
-- 👉 Para gráficos de líneas

CREATE OR REPLACE VIEW vw_trends_time AS
SELECT 
    YEAR(f.posting_date) AS year,
    MONTH(f.posting_date) AS month,
    COUNT(*) AS total_jobs,
    SUM(f.job_openings) AS total_openings,
    AVG(f.salary) AS avg_salary
FROM Fact_Postings f
GROUP BY YEAR(f.posting_date), MONTH(f.posting_date)
ORDER BY year, month;

SELECT * FROM vw_trends_time;


USE ai_jobmarket_db;

SHOW TABLES;

SELECT COUNT(*) FROM Fact_Postings;

SELECT COUNT(*) FROM vw_trends_time;

SELECT * FROM vw_trends_time LIMIT 10;

-- 3. Vista de Demanda de Skills

-- 👉 Para análisis de habilidades

CREATE OR REPLACE VIEW vw_skills_demand AS
SELECT 
    r.job_title,
    SUM(skills_python) AS python_demand,
    SUM(skills_sql) AS sql_demand,
    SUM(skills_ml) AS ml_demand,
    SUM(skills_cloud) AS cloud_demand
FROM Fact_Postings f
JOIN Dim_Job_Roles r ON f.role_id = r.role_id
GROUP BY r.job_title;

SELECT * FROM vw_skills_demand;

-- 4. Vista de Salarios por Segmento

-- 👉 Para comparaciones

CREATE OR REPLACE VIEW vw_salary_analysis AS
SELECT 
    l.country,
    c.company_industry,
    r.job_title,
    AVG(f.salary) AS avg_salary,
    COUNT(*) AS total_jobs
FROM Fact_Postings f
JOIN Dim_Location l ON f.location_id = l.location_id
JOIN Dim_Company c ON f.company_id = c.company_id
JOIN Dim_Job_Roles r ON f.role_id = r.role_id
GROUP BY l.country, c.company_industry, r.job_title;

-- 🧨 5. Vista de “Top Insights”
CREATE OR REPLACE VIEW vw_top_roles AS
SELECT 
    r.job_title,
    AVG(f.salary) AS avg_salary,
    COUNT(*) AS demand,
    RANK() OVER (ORDER BY AVG(f.salary) DESC) AS salary_rank
FROM Fact_Postings f
JOIN Dim_Job_Roles r ON f.role_id = r.role_id
GROUP BY r.job_title;

SELECT * FROM vw_top_roles;

-- 👉 Esto te permite decir en entrevista:

-- “Identifiqué los roles mejor pagados vs más demandados”


CREATE OR REPLACE VIEW vw_trends_time AS
SELECT 
    YEAR(f.posting_date) AS year,
    MONTH(f.posting_date) AS month,

    -- 🔥 usa MIN para evitar conflicto en GROUP BY
    MIN(STR_TO_DATE(CONCAT(YEAR(f.posting_date), '-', MONTH(f.posting_date), '-01'), '%Y-%m-%d')) AS date_month,

    COUNT(*) AS total_jobs,
    SUM(f.job_openings) AS total_openings,
    AVG(f.salary) AS avg_salary
FROM Fact_Postings f
GROUP BY YEAR(f.posting_date), MONTH(f.posting_date)
ORDER BY year, month;