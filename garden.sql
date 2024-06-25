CREATE TABLE Crops(
    name VARCHAR(50),
    variety VARCHAR(100),
    type ENUM('Vegetable', 'Fruit', 'Herb'),
    germinationPeriod VARCHAR(120),
    water_needs ENUM('Low', 'Moderate', 'High'),
    fertilizationNeeds VARCHAR(120),
    companions VARCHAR(120),
    commonPests VARCHAR(80),
    sunRequirements ENUM('Partial shade', 'Partial shade to full sun', 'Full sun to partial shade', 'Full sun (6-8 hours)'),
    timeToPlant VARCHAR(120)
);

--chat gpt date are strings and don't fit as sql DATE data type
CREATE TABLE Location(
    area VARCHAR(50), 
    province VARCHAR(120), 
    lastFrost VARCHAR(30),
    firstFrost VARCHAR(30)
); 

CREATE TABLE Users(
    userName VARCHAR(50),
    area VARCHAR(50),
    experienceLevel ENUM('beginner', 'intermediate', 'expert'),
    isAdmin BOOL, 
    growing VARCHAR(120)
);

CREATE TABLE Comments(
    CommentID int,  
    userName Varchar(50), 
    Date Date,
    Contents Varchar(256),
    variety VARCHAR(100),
    name VARCHAR(50)
);

/*
When loading in data from a local source you have to log into mysql use the command: $sudo mysql --local-infile=1 -u root -p
Then, in mysql you need to change the local_infile from 0 to 1: $SET GLOBAL local_infile=1;
Note: These commands are only necessary when you are going to be loading data from a local source during the session
*/

LOAD DATA LOCAL INFILE 'PATH TO New_Crops_Data.csv' INTO TABLE `Crops`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO users_data.csv' INTO TABLE `Users`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO Comments.csv' INTO TABLE `Comments`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO Locations.csv' INTO TABLE `Location`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

/****** Removing Unwanted Duplicate Values from Tables ******/
-- This is to allow definition of primary keys and satisfying a normalized database.

-- Crops Data:
WITH CTE_duplicates AS (
    SELECT 
        name, 
        variety,
        ROW_NUMBER() OVER (PARTITION BY name, variety ORDER BY (SELECT NULL)) AS row_num
    FROM 
        Crops
)
DELETE FROM Crops
WHERE EXISTS (
    SELECT 1 
    FROM CTE_duplicates 
    WHERE 
        Crops.name = CTE_duplicates.name AND
        Crops.variety = CTE_duplicates.variety AND
        CTE_duplicates.row_num > 1
);

-- Users Data:
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

-- Locations Data:
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



/****** Adding Keys to all Tables: ******/
-- Make sure you ran above queries first!
-- RUN THESE IN ORDER!

-- Adding Primary Keys:
ALTER TABLE Comments
ADD PRIMARY KEY (CommentID); 

ALTER TABLE Users
ADD PRIMARY KEY (userName);

ALTER TABLE Location
ADD PRIMARY KEY (area);

ALTER TABLE Crops
ADD PRIMARY KEY (name,variety);


-- Adding Foreign Keys: 

-- This deletes values violating the needed foreign key constraints in users table
DELETE FROM Users
WHERE area NOT IN (SELECT area FROM Location);

ALTER TABLE Users
ADD CONSTRAINT FK_area
FOREIGN KEY (area) REFERENCES Location(area);

-- This deletes values violating the needed foreign key constraints in comments table
DELETE FROM Comments
WHERE userName NOT IN (SELECT userName FROM Users);

ALTER TABLE Comments
ADD CONSTRAINT FK_UserName
FOREIGN KEY (userName) REFERENCES Users(userName);










