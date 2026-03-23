-- Consultas de Verificacion
USE AI_JobMarket_DB;

SELECT * FROM stg_ai_market LIMIT 10;


-- 1. Verificación de volumen: ¿Están los 10,337 registros?
SELECT COUNT(*) AS total_registros_importados FROM stg_ai_market;

-- 2. Verificación de integridad: ¿Se leen bien los nombres y salarios?
SELECT job_title, company_industry, salary, country 
FROM stg_ai_market 
LIMIT 10;

-- 3. Verificación de tipos: ¿El salario es un número y no un texto?
-- (Si esta suma da un número coherente, la importación fue perfecta)
SELECT SUM(salary) AS suma_total_salarios FROM stg_ai_market;