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

CREATE TABLE location(
    area VARCHAR(50), 
    province VARCHAR(120), 
    lastFrost DATE,
    firstFrost DATE
); 

CREATE TABLE Users(
    isAdmin Bool, 
    userName Varchar(50), 
    currentlyGrows Varchar(120),
    experienceLevel ENUM('begginer', 'intermediate', 'expert')
);

CREATE TABLE Comments(
    CommentID int, 
    Contents Varchar(256), 
    userName Varchar(50), 
    Date Date
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
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO comments_data_100.csv' INTO TABLE `Comments`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'PATH TO Locations.csv' INTO TABLE `Locations`
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

