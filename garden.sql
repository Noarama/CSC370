/*
 * This file contains queries related to the implementation of the garden database 
 * according to our design. This database is implemented in MySQL. 
 * Run queries in order. 
 * 
 * Authors: Noa Arama, Ella Palter, Julia Knaak
 */


-- **** Database Creation ****
CREATE DATABASE Garden;
USE Garden;


-- **** Tables Creation ****

CREATE TABLE Crops(
    name VARCHAR(50) NOT NULL,
    variety VARCHAR(100) NOT NULL,
    type ENUM('Vegetable', 'Fruit', 'Herb') NOT NULL,
    germinationPeriod VARCHAR(120) NOT NULL,
    water_needs ENUM('Low', 'Moderate', 'High') NOT NULL,
    fertilizationNeeds VARCHAR(120) NOT NULL,
    companions VARCHAR(120) NOT NULL,
    commonPests VARCHAR(80) NOT NULL,
    sunRequirements ENUM('Partial shade', 'Partial shade to full sun', 'Full sun to partial shade', 'Full sun (6-8 hours)') NOT NULL,
    timeToPlant VARCHAR(120) NOT NULL
);

CREATE TABLE Location(
    area VARCHAR(50) NOT NULL, 
    province VARCHAR(120) NOT NULL, 
    lastFrost VARCHAR(30) NOT NULL,
    firstFrost VARCHAR(30) NOT NULL
); 

CREATE TABLE Users(
    userName VARCHAR(50) NOT NULL,
    area VARCHAR(50) NULL,
    experienceLevel ENUM('beginner', 'intermediate', 'expert') NULL,
    isAdmin BOOL NOT NULL, 
    growing VARCHAR(120) NULL
);

CREATE TABLE Comments(
    CommentID int NOT NULL,  
    userName Varchar(50) NOT NULL, 
    Date Date NOT NULL,
    Contents Varchar(256) NOT NULL,
    variety VARCHAR(100) NOT NULL,
    name VARCHAR(50) NOT NULL
);

-- Below are tables for the relationships:
CREATE TABLE Attracts(
    name VARCHAR (50) NOT NULL,
    variety VARCHAR(100) NOT NULL,
    pest VARCHAR(100) NOT NULL
);

CREATE TABLE Growing(
    username VARCHAR(50),
    name VARCHAR(50),
    variety VARCHAR(100)
);

CREATE TABLE Pests(
    pestName VARCHAR(100),
    treatment VARCHAR(300)
);

--  Below is table for subset:
CREATE TABLE Admins(
    userName VARCHAR(50),
    FOREIGN KEY (userName) REFERENCES Users(userName)
);

CREATE TABLE Monitors(
    userName VARCHAR(50), 
    CommentID int, 
    contentStatus ENUM('appropriate', 'inappropriate'),
    FOREIGN KEY (userName) REFERENCES Users(userName), 
    FOREIGN KEY (CommentID) REFERENCES Comments(CommentID)
);

-- **** Data Insertion ****
/*
When loading in data from a local source you have to log into mysql use the command: $sudo mysql --local-infile=1 -u root -p
Then, in mysql you need to change the local_infile from 0 to 1: $SET GLOBAL local_infile=1;
Note: These commands are only necessary when you are going to be loading data from a local source during the session
*/

LOAD DATA LOCAL INFILE 'PATH TO New_Crops_Data.csv' INTO TABLE `Crops`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO users_data.csv' INTO TABLE `Users`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO Comments.csv' INTO TABLE `Comments`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO Locations.csv' INTO TABLE `Location`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO pests_data.csv' INTO TABLE `Attracts`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO growing_data.csv' INTO TABLE `Growing`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO pests_treatment.csv' INTO TABLE `Pests`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

INSERT INTO Admins(
    SELECT userName 
    FROM Users
    WHERE isAdmin = TRUE);


/****** Data Manipulation ******/
-- We have decided to store the data of crop name and variety together in one column.

-- ** Crops Table: **
-- Concatanating the name and variety
ALTER TABLE Crops ADD COLUMN crop VARCHAR(150) FIRST;
UPDATE Crops SET crop = CONCAT(variety, ' ', name);
ALTER TABLE Crops DROP COLUMN name, DROP COLUMN variety;

-- Dropping the columns to account for the new relationship implementation
ALTER TABLE Crops DROP COLUMN companions, DROP COLUMN commonPests;

-- Removing duplicate values
WITH CTE_duplicates AS (
    SELECT 
        crop,
        ROW_NUMBER() OVER (PARTITION BY crop ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Crops
)
DELETE FROM Crops
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Crops.crop= CTE_duplicates.crop AND
        CTE_duplicates.row_num > 1
);


-- ** Users Table **
-- Dropping the columns to account for the new relationship implementation
ALTER TABLE Users DROP COLUMN growing;

-- Removing duplicate values
WITH CTE_duplicates AS (
    SELECT 
        userName, 
        ROW_NUMBER() OVER (PARTITION BY userName ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Users
)
DELETE FROM Users
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Users.userName = CTE_duplicates.userName AND
        CTE_duplicates.row_num > 1
);

-- Removing data violating foreign key constraint 
DELETE FROM Users
WHERE area NOT IN (SELECT area FROM Location);


-- ** Comments Table **
-- Concatanating the name and variety
ALTER TABLE Comments ADD COLUMN crop VARCHAR(150);
UPDATE Comments SET crop = CONCAT(variety, ' ', name);
ALTER TABLE Comments DROP COLUMN name, DROP COLUMN variety;

-- Removing data violating foreign key constraint 
DELETE FROM Comments
WHERE userName NOT IN (SELECT userName FROM Users);

-- ** Locations Table **
-- Removing duplicate values
WITH CTE_duplicates AS (
    SELECT 
        area, 
        ROW_NUMBER() OVER (PARTITION BY area ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Location
)
DELETE FROM Location
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Location.area = CTE_duplicates.area AND
        CTE_duplicates.row_num > 1
);


-- ** Attracts Table **
-- Concatanating the name and variety
ALTER TABLE Attracts ADD COLUMN crop VARCHAR(150) FIRST;
UPDATE Attracts SET crop = CONCAT(variety, ' ', name);
ALTER TABLE Attracts DROP COLUMN name, DROP COLUMN variety;

-- Removing duplicate values
WITH CTE_duplicates AS (
    SELECT 
        crop, 
        pest,
        ROW_NUMBER() OVER (PARTITION BY crop, pest ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Attracts
)
DELETE FROM Attracts
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Attracts.crop = CTE_duplicates.crop AND 
        Attracts.pest = CTE_duplicates.pest AND 
        CTE_duplicates.row_num > 1
);

-- Removing data violating foreign key constraint 
DELETE FROM Attracts
WHERE crop NOT IN (SELECT crop FROM Crops);

DELETE FROM Attracts
WHERE pest NOT IN (SELECT pestName FROM Pests);


-- ** Growing Table **
-- Concatanating the name and variety
ALTER TABLE Growing ADD COLUMN crop VARCHAR(150) FIRST;
UPDATE Growing SET crop = CONCAT(variety, ' ', name);
ALTER TABLE Growing DROP COLUMN name, DROP COLUMN variety;

-- Removing duplicate values
WITH CTE_duplicates AS (
    SELECT 
        userName, 
        crop,
        ROW_NUMBER() OVER (PARTITION BY userName, crop ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Growing
)
DELETE FROM Growing
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Growing.crop = CTE_duplicates.crop AND 
        Growing.userName = CTE_duplicates.userName AND 
        CTE_duplicates.row_num > 1
);

-- Removing data violating foreign key constraint 
DELETE FROM Growing
WHERE crop NOT IN (SELECT crop FROM Crops);

DELETE FROM Growing
WHERE userName NOT IN (SELECT userName FROM Users);

/****** Adding Keys to all Tables: ******/

-- Adding Primary Keys:
ALTER TABLE Crops
ADD PRIMARY KEY (crop);

ALTER TABLE Users
ADD PRIMARY KEY (userName);

ALTER TABLE Comments
ADD PRIMARY KEY (CommentID); 

ALTER TABLE Location
ADD PRIMARY KEY (area);

ALTER TABLE Pests
ADD PRIMARY KEY (pestName);


-- Adding Foreign Keys: 

-- Users and Location
ALTER TABLE Users
ADD CONSTRAINT FK_area
FOREIGN KEY (area) REFERENCES Location(area);

-- Comments and Users
ALTER TABLE Comments
ADD CONSTRAINT FK_UserName
FOREIGN KEY (userName) REFERENCES Users(userName);

-- Attracts and Crops
ALTER TABLE Attracts
ADD CONSTRAINT FK_Attracts_Crops
FOREIGN KEY (crop) REFERENCES Crops(crop);

-- Attracts and Pests
ALTER TABLE Attracts 
ADD CONSTRAINT FK_Attracts_Pests
FOREIGN KEY (pest) REFERENCES Pests(pestName);

-- Growing and Crops
ALTER TABLE Growing
ADD CONSTRAINT FK_Growing_Crops
FOREIGN KEY (crop) REFERENCES Crops(crop);

-- Growing and Users
ALTER TABLE Growing
ADD CONSTRAINT FK_Growing_Users
FOREIGN KEY (userName) REFERENCES Users(userName);



/****** Views: ******/

-- This view shows the users without their personal information
CREATE VIEW PublicUsers AS 
SELECT userName, experienceLevel, growing
FROM Users;

-- This view shows all expert users
CREATE VIEW Experts AS
SELECT * 
FROM Users 
WHERE experienceLevel = 3;




/****** Security and Privilages: ******/

-- Create the type of user
CREATE USER 'admin'@'%' IDENTIFIED BY 'IAmAdmin';
CREATE USER 'user'@'%' IDENTIFIED BY 'IAmUser';
CREATE USER 'expert'@'%' IDENTIFIED BY 'IAmExpert';

-- Give privilages 

-- This is for admin users
GRANT ALL PRIVILEGES 
ON Crops, Users, Location, Comments
TO 'admin'@'%';

-- This is for the regular user
GRANT SELECT 
ON Publicusers, Crops, Comments 
TO 'user'@'%';

GRANT INSERT
ON Comments 
TO 'user'@'%';

-- This is for expert users
GRANT SELECT 
ON Publicusers, Crops, Comments 
TO 'expert'@'%'

GRANT INSERT
ON Comments 
TO 'expert'@'%'

GRANT INSERT, ALTER 
ON Crops 
TO 'expert'@'%';

/****** Check Constraints and Triggers: ******/
--Comments cannot contain inappropriate language
ALTER TABLE `Comments`
ADD CHECK (`Contents` NOT LIKE '%fuck%' AND `Contents` NOT LIKE '%shit%' AND `Contents` NOT LIKE '%bitch');

ALTER TABLE Users
    ADD COLUMN commentsMade INT NOT NULL DEFAULT 0, 
    ADD COLUMN startCountTime DATE;

ALTER TABLE `Users` 
 ADD CHECK(`commentsMade` <= 200); -- max number of comments made in 24hr period is 200 to avoid spamming

--For testing purposes (don't want to simulate writing 200 comments)
ALTER TABLE `Users` 
 ADD CHECK(`commentsMade` <= 1); 

DELIMITER $$

CREATE TRIGGER `count_commentsMade`
BEFORE INSERT ON `Comments`
FOR EACH ROW
BEGIN
    DECLARE user_comment_count INT DEFAULT 0;
    DECLARE user_start_count_time DATE;

    -- Fetch current comment count and startCountTime for the user
    SELECT commentsMade, startCountTime INTO user_comment_count, user_start_count_time
    FROM Users
    WHERE userName = NEW.userName;

    -- If startCountTime is NULL, set it to the current date
    IF user_start_count_time IS NULL THEN
        SET user_start_count_time = NEW.Date;
    END IF;

    -- Check if the comment date is different from the last comment date
    IF user_start_count_time = NEW.Date AND user_comment_count >= 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'User has already made a comment today.';
    ELSE
        IF user_start_count_time <> NEW.Date THEN
            UPDATE Users
            SET commentsMade = 1, startCountTime = NEW.Date
            WHERE userName = NEW.userName;
        ELSE
            UPDATE Users
            SET commentsMade = commentsMade + 1
            WHERE userName = NEW.userName;
        END IF;
    END IF;
END$$

DELIMITER ;

-- write some comments
INSERT INTO `Comments`
VALUES(402, 'crop_caretaker', CURRENT_DATE(), 'this is a comments', 'Lemon', 'Cucumber');

-- this comment will not be added if it is written within 24hrs of the previous comment
INSERT INTO `Comments`
VALUES(403, 'crop_caretaker', CURRENT_DATE(), 'this exceeds the max # of comments', 'Lemon', 'Cucumber');






