-- This file contains queries for sprint 2

---Show all crops that have a certain sun requirement
SELECT `Variety`, `Name`
From `Crops`
WHERE sunRequirements = 'Full sun (6-8 hours)';
