-- This file contains queries for sprint 2

--- Show all crops that have a certain sun requirement
SELECT `Variety`, `Name`
FROM `Crops`
WHERE sunRequirements = 'Full sun (6-8 hours)';

--- Show all crops that have a certain water requirement
SELECT DISTINCT `Variety`, `Name`
FROM `Crops`
WHERE water_needs = 'Moderate';

--- Show all crops affected by a certain pest - (basic, string processing) (Noa)
--- Show all users growing a specific crop (join aggregation) (Julia)

--- Show all varieties of a certain crop 
SELECT DISTINCT `Variety`
FROM `Crops`
WHERE Name = 'Tomato';

--- Show all vegetables 
SELECT DISTINCT `Variety`, `Name`
FROM `Crops`
WHERE type = 'Vegetable';

--- Show all fruits 
SELECT DISTINCT `Variety`, `Name`
FROM `Crops`
WHERE type = 'Fruit';

--- Show all herbs 
SELECT DISTINCT `Variety`, `Name`
FROM `Crops`
WHERE type = 'Herb';

--- Show where a user that wrote a comment lives - in this case looking for user who wrote comment with commentID =2 (join)
SELECT users.area 
FROM `Comments` 
JOIN users ON comments.userName=users.userName 
WHERE Comments.CommentID = 2;
--- Show the user with the most comments (join, aggregation) (Noa)
--- Show the level of a user that wrote a certain comment (join) (Julia)
--- Add a comment associated with a crop (basic) (Ella)
INSERT INTO `Comments`
VALUES(101, 'harvest_hustler', '2024-06-14', 'This variety is growing super fast!!!!', 'Tomato', 'Cherry');
--- Comment I love tomatoes on all varieties of tomatoes (subquery) (Ella)
--- Show where each user growing basil lives in (sub queries) (Noa)
--- Show the most popular area where eggplant is grown (sub queries, aggregation) (Julia)
