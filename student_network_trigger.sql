USE Student_Network_Database;

#Number 1
DELIMITER $$
CREATE Trigger friendly_makes_friends AFTER INSERT ON Highschooler
	FOR EACH ROW
	BEGIN
		IF (NEW.name = 'Friendly') THEN
			INSERT INTO Likes SELECT NEW.Id, ID 
								FROM Highschooler AS h
                                WHERE new.grade = h.grade AND NOT (new.id=h.id);
        END IF;
	END; $$
DELIMITER ;
#DROP TRIGGER friendly_makes_friends;
INSERT INTO Highschooler VALUES(546, 'Friendly', 'Sophomore');

DELETE 
FROM Likes
WHERE ID1 = 546;

DELETE 
FROM Highschooler
WHERE ID = 546;

#Number 2
DELIMITER $$
CREATE Trigger autocorrect_grade AFTER INSERT ON Highschooler
	FOR EACH ROW
	BEGIN
		IF (NEW.grade < 9 OR NEW.grade > 12) THEN
			UPDATE Highschooler SET grade = NULL WHERE ID = NEW.ID;
		ELSEIF (NEW.grade = NULL) THEN
			UPDATE Highschooler SET grade = 9 WHERE ID = NEW.ID;
        END IF;
	END; $$
DELIMITER ;

#Number 3
DELIMITER $$
CREATE Trigger on_graduate AFTER UPDATE ON Highschooler
	FOR EACH ROW
	BEGIN
		IF (NEW.grade > 12) THEN
			DELETE FROM Highschooler WHERE ID = NEW.ID;
        END IF;
	END; $$
DELIMITER ;

#Number 4
create trigger add_inverse_friend_tupple after insert
on Friend
for each row
insert into Friend (id1, id2) values(new.id2, new.id1);



create trigger delete_inverse_friend_tupple before delete
on Friend
for each row
delete from Friend where new.id2 = id1 AND new.id1 = id2;

#Number 5
DELIMITER $$
CREATE Trigger on_gradeup AFTER UPDATE ON Highschooler
	FOR EACH ROW
	BEGIN
		IF (NEW.grade > 12) THEN
			DELETE FROM Highschooler WHERE ID = NEW.ID;
		ELSEIF(OLD.grade = NEW.grade - 1) THEN
			UPDATE Highschooler SET grade = grade + 1
			WHERE ID IN (SELECT ID2 FROM Friend WHERE ID1 = OLD.grade);
        END IF;
	END; $$
DELIMITER ;

#Number 6
DELIMITER $$
CREATE Trigger highschool_drama AFTER UPDATE ON Likes
	FOR EACH ROW
	BEGIN
		IF (OLD.ID2 <> NEW.ID2) THEN
			DELETE FROM Friend WHERE (ID1 = OLD.ID2 AND ID2 = NEW.ID2)
										OR (ID2 = OLD.ID2 AND ID1 = NEW.ID2);
        END IF;
	END; $$
DELIMITER ;