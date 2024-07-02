-- get a list of users who have commented most in a particular period
SELECT users.userName, COUNT(comments.commentID) AS totalComments, AVG(LENGTH(comments.contents)) AS avgCommentLength
FROM `users`
JOIN comments ON users.userName = comments.userName
WHERE comments.date BETWEEN '2023-01-01' AND '2023-12-31'
GROUP BY userName
ORDER BY totalComments DESC;

--find all users growing tomatoes and their location
SELECT users.Username, users.Area,location.Province
FROM users 
JOIN location ON users.Area = location.Area
WHERE users.Growing LIKE '%Tomato%';

-- TRANSACTION for bulk commenting
START TRANSACTION;

INSERT INTO comments (userName, Date, contents, Variety, Name)
VALUES ('earth_elite', '2024-06-01', 'Great crop!', 'Variety1', 'Tomato'),
       ('earth_elite', '2024-06-02', 'Need more water', 'Variety2', 'Cucumber'),
       ('earth_elite', '2024-06-03', 'Harvested early', 'Variety3', 'Lettuce');

COMMIT;

-- TRANSACTION for changing a userName
--have to temporarlily disable foreign key checks or else transaction won't work
SET FOREIGN_KEY_CHECKS = 0; 

START TRANSACTION;

UPDATE users
SET userName = 'new_username'
WHERE userName = 'plant_pro';

UPDATE comments
SET userName = 'new_username'
WHERE userName = 'plant_pro';

COMMIT;

SET FOREIGN_KEY_CHECKS = 1; --turn foreign key checks back on

-- TRANSACTION for removing a user and their associated data from the system

START TRANSACTION;

DELETE FROM comments
WHERE userName = 'user_to_delete';

DELETE FROM users
WHERE userName = 'user_to_delete';

COMMIT;



