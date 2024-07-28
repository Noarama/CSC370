/*
 * Purpose: This file contains a variety of queries.
 * Author: Noa Arama
*/

/******* Adding Data *******/

-- Adding data into existing tables
INSERT INTO Users
VALUES ('super_grower', 'Prince George', 1 , True);

INSERT INTO Users
VALUES ('me_me', 'Victoria', 1 , True);

INSERT INTO Comments
VALUES (101, 'super_grower', '2023-01-03', 'Help! My plant is dying!', 'Thai', 'Basil');

INSERT INTO Users 
VALUES('noarama', 'Nanaimo', 2, True);



/******* SELECT-FROM-WHERE Queries *******/



-- 1. Shows all users that are begginers
-- Relational Algebra: $\pi_{userName}( \sigma_{experienceLevel = 1}(Users) )$
SELECT userName
FROM Users
WHERE experienceLevel = 1;

-- 2. Shows all crops that are affected by aphids
SELECT crop 
FROM Attracts
WHERE pest LIKE '%aphids%' OR 'Aphids%';


/******* JOINS *******/

-- 3. Shows all the information about the user and the comments they made.
-- Relational Algebra: $Comments \bowtie_{Comments.userName = Users.userName} Users$ (Take the first five of)
SELECT * 
FROM Comments 
JOIN Users ON Comments.userName = Users.userName
LIMIT 5;

-- 4. Shows the last frost dates for each user based on their location. 
SELECT userName, Users.area, lastFrost
FROM Users
JOIN Location 
ON Users.area = Location.area;

-- 5. Displays all the comments written a certain crop
SELECT Comments.userName, Crops.name, Crops.variety, Comments.commentID, Comments.Contents
FROM Comments 
JOIN Crops 
ON Crops.name = Comments.name AND Crops.variety = Comments.variety;



/******* Aggragation *******/

-- 6. Display all "active" users 
SELECT userName
FROM Comments
GROUP BY userName
HAVING COUNT(*) > 0;

-- 7. Display the experience level that has more than 10 users 
SELECT experienceLevel
FROM Users 
GROUP BY experienceLevel
HAVING COUNT(*) < 10;
-- The result is expert. So it seems that experts are the most common users. 



/******* Subqueries *******/

-- 8. Show all users that are "inaactive"
SELECT userName
FROM Users
WHERE userName NOT IN 
(
    SELECT userName
    FROM Comments
);


-- 9. Show all active users. Equivalent to query #6. 
SELECT userName
FROM Users
WHERE userName IN 
(
    SELECT userName
    FROM Comments
);

/* 
Queries 9 and 10 can be accelerated by implementing an index on `Users`.`area`
These queries have been identified as queries which would benefit from indexing because they use all of subqueries, aggregation and 
selection which can be costly operations. 
Both of these queries have a selection predicate on `Users`.`area` through the GROUP BY `Users`.`area` and ORDER BY COUNT(*)
This is nested within the JOIN operation, so it reduces the number of rows that need to be processed in the outer query significantly.
*/
CREATE INDEX `idx_user_area` ON `Users`(`area`);


-- 10. Show the date for the last frost of the most common area among the users.
SELECT Location.area, Province, lastFrost
FROM Location
JOIN
(
    SELECT Users.area
    FROM Users
    GROUP BY Users.area
    ORDER BY COUNT(*)
    LIMIT 1  
) AS PopularArea
ON (PopularArea.area = Location.area);


-- 11. Display the name of all users living in the most common area 
SELECT userName 
FROM Users 
JOIN 
(
    SELECT Users.area
    FROM Users
    GROUP BY Users.area
    ORDER BY COUNT(*)
    LIMIT 1  
) AS PopularArea
ON (PopularArea.area = Users.area);



/******* Simplifying Queries *******/

-- Associativity 
-- These query shows all beginner users that live in Victoria 
SELECT a.userName
FROM (
    SELECT *
    FROM Users 
    WHERE experienceLevel = 1
) AS a
WHERE a.area LIKE "Victoria";

-- This is a simplified, equivalent version of above. 
SELECT username 
FROM Users 
WHERE area = "Victoria"
AND experienceLevel = 1;





