create database Titanic;
select * from titanic;
-- Create cleaned table with imputed values
DROP TABLE IF EXISTS titanic_clean;
CREATE TABLE titanic_clean AS
SELECT *,
       COALESCE(Age, 28.0) AS CleanedAge,
       COALESCE(Embarked, 'S') AS CleanedEmbarked,
       CASE WHEN Cabin IS NOT NULL THEN 1 ELSE 0 END AS HasCabin
FROM titanic;

-- 1. Overall Survival Rate
SELECT 
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean;

-- 2. Survival by Gender
SELECT 
    Sex,
    COUNT(*) AS Total,
    SUM(Survived) AS Survived,
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean
GROUP BY Sex;

-- 3. Survival by Passenger Class
SELECT 
    Pclass,
    COUNT(*) AS Total,
    SUM(Survived) AS Survived,
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean
GROUP BY Pclass;

-- 4. Survival by Age Group
SELECT 
    CASE 
        WHEN CleanedAge < 18 THEN 'Child'
        WHEN CleanedAge BETWEEN 18 AND 60 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    COUNT(*) AS Total,
    SUM(Survived) AS Survived,
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean
GROUP BY AgeGroup;

-- 5. Demographics: Age, Gender, Class Distribution
SELECT 
	 CASE 
        WHEN CleanedAge < 18 THEN 'Child'
        WHEN CleanedAge BETWEEN 18 AND 60 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeGroup,
    Sex,
    Pclass,
    COUNT(*) AS PassengerCount
FROM titanic_clean
GROUP BY AgeGroup, Sex, Pclass;

-- 6. Family Size Analysis
SELECT 
    CASE 
        WHEN (SibSp + Parch) = 0 THEN 'Alone'
        ELSE 'With Family'
    END AS FamilyType,
    COUNT(*) AS Total,
    SUM(Survived) AS Survived,
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean
GROUP BY FamilyType;

-- 7. Fare Distribution by Class
SELECT 
    Pclass,
    ROUND(AVG(Fare), 2) AS AverageFare,
    ROUND(MIN(Fare), 2) AS MinFare,
    ROUND(MAX(Fare), 2) AS MaxFare
FROM titanic_clean
GROUP BY Pclass;

-- 8. Embarked Port Survival Analysis
SELECT 
    CleanedEmbarked AS EmbarkPort,
    COUNT(*) AS Total,
    SUM(Survived) AS Survived,
    ROUND(AVG(Survived) * 100, 2) AS SurvivalRatePercentage
FROM titanic_clean
GROUP BY CleanedEmbarked;
