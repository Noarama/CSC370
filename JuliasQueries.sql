/*
 * Purpose: This file contains a variety of queries.
 * Author: Julia Knaak
*/

/******* Subqueries *******/

/* 
Query 1 can be accelerated by implementing an index on `Comments`.`userName`
This query has been identified as a query which would benefit from indexing because it uses all of subqueries, group by and
order by which are costly operations. 
This queries has a selection predicate on `Comments`.`userName` through the GROUP BY `Comments`.`userName` and ORDER BY COUNT(*) DESC
and another selection on `Users`.`userName`. Since `Users`.`userName` is a primary key, it is already indexed and `Comments`.`userName`
is the most beneficial choice for indexing
*/
CREATE INDEX `idx_comment_userName` ON `Comments`(`userName`);

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

/* 
Query 2 can also be accelerated by implementing an index on `Comments`.`userName`
This queries has a selection predicate on `Comments`.`userName` through the WHERE clause in the outer subquery. An index on
`Comments`.`userName` will accelerate the filtering proccesss. Since `Users`.`userName` is a primary key, it is already indexed and `Comments`.`userName`
is the most beneficial choice for indexing
*/

-- 2. Show all users who have never commented 
SELECT `userName`
FROM `Users`
  WHERE `userName` NOT IN
(
    SELECT `userName`
    FROM `Comments`
);

-- 3. Show all users who do not grow Basil
SELECT `userName`
FROM `Users`
WHERE `userName` NOT IN 
(
  SELECT `userName`
  FROM `Users`
  WHERE `growing` LIKE '%Basil%'
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
