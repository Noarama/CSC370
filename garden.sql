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
    CommentID INT AUTO_INCREMENT,  
    userName VARCHAR(50), 
    Date DATE,
    Contents VARCHAR(256),
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

/*
* Adding keys to all tables
*/

ALTER TABLE comments
ADD PRIMARY KEY (CommentID)
ADD FOREIGN KEY (userName) REFERENCES Users(userName);

ALTER TABLE Users
ADD PRIMARY KEY (userName)
ADD FOREIGN KEY (area) REFERENCES Location(area);

ALTER TABLE Location
ADD PRIMARY KEY (area);

