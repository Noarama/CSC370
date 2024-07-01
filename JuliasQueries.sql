/*
 * Purpose: This file contains a variety of queries.
 * Author: Julia Knaak
*/

/******* Subqueries *******/

-- 1. Show the crops of the user with the most comments
SELECT `growing`
FROM `Users`
WHERE `Users`.`userName` IN
(
  SELECT `Comments`.`userName`
  FROM `Comments`
  GROUP BY `Comments`.`userName`
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- 2. Show all users who do not grow Basil
SELECT `userName`
FROM `Users`
WHERE `userName` NOT IN 
(
  SELECT `userName`
  FROM `Users`
  WHERE `growing` LIKE '%Basil%'
  );

-- 3. Show all users who have never commented 
SELECT `userName`
FROM `Users`
  WHERE `userName` NOT IN
(
    SELECT `userName`
    FROM `Comments`
);

/******* Grouping and Aggregation*******/
  
-- 4. Show users who have commented more than once
SELECT `userName`
FROM `Comments`
GROUP BY `Comments`.`userName`
HAVING COUNT(*) > 1
ORDER BY COUNT(*) ASC;

-- 5. Show all users who grow crops which are planted after last frost
SELECT `userName`
FROM `Users`
JOIN `Crops`
  ON `Users`.`growing` LIKE CONCAT('%', `Crops`.`name`, ', ', `Crops`.`variety`,'%')
WHERE `Crops`.`timeToPlant` LIKE 'After last frost';

-- 6. Show all comments written about a crop that a specific user grows //not working (yet)

SELECT `Comments`.`Contents`
FROM `Comments`
JOIN(
    SELECT `growing`
    FROM `Users`
    WHERE `Users`.`userName` = 'field_fanatic'
)AS `userCrops`
  ON (`userCrops`.`growing` LIKE CONCAT('%',`Comments`.`name`,'%', `Comments`.`variety`,'%'));
