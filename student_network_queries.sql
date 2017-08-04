#Number 1
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN (SELECT DISTINCT ID
				FROM Highschooler JOIN Likes ON Highschooler.ID = Likes.ID1 OR 
												Highschooler.ID = Likes.ID2);
                                                
#Number 2
CREATE VIEW Mutual_Friends AS
	SELECT a.ID1 AS Likes1, a.ID2 AS Likes2, Friend.ID2 AS Mutual_Friend
	FROM Friend JOIN (SELECT *
					FROM Likes
					WHERE (ID1, ID2) NOT IN (SELECT Likes.ID1, Likes.ID2
									FROM Likes JOIN Friend ON 
										Likes.ID1 = Friend.ID1 
										AND Likes.ID2 = Friend.ID2)) AS a ON (Friend.ID1 = a.ID1 OR
																				Friend.ID1 = a.ID2)
	GROUP BY a.ID1, a.ID2, Friend.ID2
	HAVING COUNT(*) > 1;

SELECT y.aName, y.aGrade, y.bName, y.bGrade, y.cName AS MutualFriendName, y.cGrade AS MutualFriendGrade
FROM Mutual_Friends JOIN (SELECT a.ID AS aID, a.name AS aName, a.grade AS aGrade,
									b.ID AS bID, b.name AS bName, b.grade AS bGrade,
									c.ID AS cID, c.name AS cName, c.grade AS cGrade
							FROM Highschooler a, Highschooler b, Highschooler c) AS y
												ON Likes1 = y.aID 
													AND Likes2 = y.bID
                                                    AND Mutual_Friend = y.cID;

#Number 3
CREATE VIEW distinct_name_count AS
SELECT COUNT(*) - COUNT(DISTINCT name) AS Difference
FROM Highschooler;

SELECT *
FROM distinct_name_count;
#Number 4
CREATE VIEW friend_count AS
	SELECT COUNT(*) AS friendCount
	FROM Friend
	GROUP BY ID1;
    
SELECT AVG(friendCount)
FROM friend_count;

#Number 5
CREATE VIEW cass_friends AS
	SELECT cass_ID.ID AS cassID, ID2 AS friendID
	FROM (SELECT ID
	FROM Highschooler
	WHERE name = 'Cassandra') AS cass_ID JOIN 
		Friend ON cass_ID.ID = Friend.ID1;
    
SELECT COUNT(DISTINCT Friend.ID2) + COUNT(DISTINCT friendID) AS numFriendNetwork
FROM  cass_friends JOIN Friend ON cass_friends.friendID = Friend.ID1
WHERE ID2 <> cassID;
    
#Number 6
CREATE VIEW max_friend_count AS
	SELECT MAX(friendCount)
	FROM (SELECT COUNT(*) AS friendCount
			FROM Friend
			GROUP BY ID1);
            
SELECT name, grade
FROM Highschooler JOIN (SELECT ID1, COUNT(*) AS friendCount
FROM Friend
GROUP BY ID1) AS b ON Highschooler.ID = b.ID1
WHERE friendCount = max_friend_count;