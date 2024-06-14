-- This file contains queries for sprint 2

--- Show all crops that have a certain sun requirement
SELECT `Variety`, `Name`
FROM `Crops`
WHERE sunRequirements = 'Full sun (6-8 hours)';

--- Show all crops that have a certain water requirement
SELECT `Variety`, `Name`
FROM `Crops`
WHERE water_needs = 'Moderate';

--- Show all crops affected by a certain pest - (basic, string processing) 
--- Show all users growing a specific crop (join aggregation)
--- Show all varieties of a certain crop 
SELECT `Variety`
FROM `Crops`
WHERE Name = 'Tomatoe';

--- Show all vegetables 
--- Show all fruits 
--- Show all herbs (basic)
--- Show where a user that wrote a comment  lives (join)
--- Show the user with the most comments (join, aggregation)
--- Show the level of a user that wrote a certain comment (join)
--- Add a comment associated with a crop (basic)
--- Comment I love tomatoes on all varieties of tomatoes (subquery) 
--- Show where each user growing basil lives in (sub queries)
--- Show the most popular area where eggplant is grown (sub queries, aggregation) 
