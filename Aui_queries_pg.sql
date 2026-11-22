-- AUI Club, Event & Facility Management System
-- Queries (run after aui_schema_pg.sql)
-- Run with:  psql -v ON_ERROR_STOP=1 -a -f aui_queries_pg.sql -U dhanae

-- Q1. Which clubs does each student belong to?
SELECT s.student_name, c.club_name, m.join_date
FROM student s
JOIN membership m ON s.student_id = m.student_id
JOIN club c       ON m.club_id = c.club_id
ORDER BY s.student_name;

-- Q2. How many members does each club have?
SELECT c.club_name, COUNT(m.student_id) AS number_of_members
FROM club c
LEFT JOIN membership m ON c.club_id = m.club_id
GROUP BY c.club_name;

-- Q3. Who are the officers of each club and what is their role?
SELECT c.club_name, s.student_name, o.officer_role
FROM officer o
JOIN student s ON o.student_id = s.student_id
JOIN club c    ON o.club_id = c.club_id
ORDER BY c.club_name;

-- Q4. Which club(s) organize each event?
SELECT e.event_name, e.event_date, c.club_name
FROM event e
JOIN event_club ec ON e.event_id = ec.event_id
JOIN club c        ON ec.club_id = c.club_id
ORDER BY e.event_date;

-- Q5. Which students registered for the event 'AUI Hackathon 2026'?
SELECT s.student_name, r.registration_date, r.attended
FROM registration r
JOIN student s ON r.student_id = s.student_id
JOIN event e   ON r.event_id = e.event_id
WHERE e.event_name = 'AUI Hackathon 2026';

-- Q6. How many students registered for each event?
SELECT e.event_name, COUNT(r.student_id) AS number_of_registrations
FROM event e
LEFT JOIN registration r ON e.event_id = r.event_id
GROUP BY e.event_name;

-- Q7. For events with recorded attendance, how many registered students attended?
SELECT e.event_name,
       COUNT(*)           AS registered,
       SUM(CASE WHEN r.attended THEN 1 ELSE 0 END) AS attended
FROM registration r
JOIN event e ON r.event_id = e.event_id
WHERE r.attended IS NOT NULL
GROUP BY e.event_name;

-- Q8. Which students belong to more than one club?
SELECT s.student_name, COUNT(m.club_id) AS number_of_clubs
FROM student s
JOIN membership m ON s.student_id = m.student_id
GROUP BY s.student_name
HAVING COUNT(m.club_id) > 1;

-- Q9. Which venue requests have been approved, and for which event?
SELECT e.event_name, v.venue_name, r.start_time, r.end_time
FROM request r
JOIN event e ON r.event_id = e.event_id
JOIN venue v ON r.venue_id = v.venue_id
WHERE r.decision = 'APPROVED';

-- Q10. Which requests are still pending (no decision yet)?
SELECT r.request_id, e.event_name, r.request_type, r.request_date
FROM request r
JOIN event e ON r.event_id = e.event_id
WHERE r.decision IS NULL;

-- Q11. Which equipment was requested, how many units, and what was the decision?
SELECT e.event_name, q.equipment_name, r.quantity, r.decision
FROM request r
JOIN event e     ON r.event_id = e.event_id
JOIN equipment q ON r.equipment_id = q.equipment_id;

-- Q12. Which administrator reviewed how many requests?
SELECT a.admin_name, COUNT(r.request_id) AS requests_reviewed
FROM administrator a
LEFT JOIN request r ON a.admin_id = r.admin_id
GROUP BY a.admin_name;


-- Part 2: more queries (order by, set operations, outer joins, subqueries)

-- Q13. List the events from latest to earliest (same date -> by name)
SELECT event_name, event_date
FROM event
ORDER BY event_date DESC, event_name ASC;

-- Q14. What are the 3 biggest venues?
SELECT venue_name, capacity
FROM venue
ORDER BY capacity DESC
LIMIT 3;

-- Q15. Clubs sorted by number of members
SELECT c.club_name, COUNT(m.student_id) AS number_of_members
FROM club c
LEFT JOIN membership m ON c.club_id = m.club_id
GROUP BY c.club_name
ORDER BY number_of_members DESC, c.club_name;

-- Q16. All people in the system, students and administrators (UNION)
SELECT student_name AS person_name, 'Student' AS person_type
FROM student
UNION
SELECT admin_name, 'Administrator'
FROM administrator
ORDER BY person_type, person_name;

-- Q17. Which venues and equipment were requested at least once?
-- (union removes the duplicates)
SELECT v.venue_name AS resource_name, 'Venue' AS resource_type
FROM request r JOIN venue v ON r.venue_id = v.venue_id
UNION
SELECT q.equipment_name, 'Equipment'
FROM request r JOIN equipment q ON r.equipment_id = q.equipment_id
ORDER BY resource_type, resource_name;

-- Q18. Members and officers in one list (UNION ALL keeps duplicates,
-- so officers show up twice)
SELECT s.student_name, c.club_name, 'Member' AS link_type
FROM membership m
JOIN student s ON m.student_id = s.student_id
JOIN club c    ON m.club_id = c.club_id
UNION ALL
SELECT s.student_name, c.club_name, 'Officer (' || o.officer_role || ')'
FROM officer o
JOIN student s ON o.student_id = s.student_id
JOIN club c    ON o.club_id = c.club_id
ORDER BY student_name, club_name;

-- Q19. Which students are in both the CS club and the Debate club? (INTERSECT)
SELECT s.student_name
FROM student s
JOIN membership m ON s.student_id = m.student_id
JOIN club c       ON m.club_id = c.club_id
WHERE c.club_name = 'Computer Science Club'
INTERSECT
SELECT s.student_name
FROM student s
JOIN membership m ON s.student_id = m.student_id
JOIN club c       ON m.club_id = c.club_id
WHERE c.club_name = 'Debate Club';

-- Q20. Which officers also registered for an event?
SELECT s.student_name
FROM student s JOIN officer o ON s.student_id = o.student_id
INTERSECT
SELECT s.student_name
FROM student s JOIN registration r ON s.student_id = r.student_id;

-- Q21. Members that are not officers (EXCEPT)
SELECT s.student_id, s.student_name
FROM student s JOIN membership m ON s.student_id = m.student_id
EXCEPT
SELECT s.student_id, s.student_name
FROM student s JOIN officer o ON s.student_id = o.student_id
ORDER BY student_id;

-- Q22. Which venues were never requested?
SELECT venue_name FROM venue
EXCEPT
SELECT v.venue_name
FROM venue v JOIN request r ON v.venue_id = r.venue_id;

-- Q23. Debate club members who didnt register for the Inter-University Debate
SELECT s.student_name
FROM student s
JOIN membership m ON s.student_id = m.student_id
JOIN club c       ON m.club_id = c.club_id
WHERE c.club_name = 'Debate Club'
EXCEPT
SELECT s.student_name
FROM student s
JOIN registration r ON s.student_id = r.student_id
JOIN event e        ON r.event_id = e.event_id
WHERE e.event_name = 'Inter-University Debate';

-- Q24. All venues with their requests (left join, so unused venues show null)
SELECT v.venue_name, r.request_id, r.decision
FROM venue v
LEFT JOIN request r ON v.venue_id = r.venue_id
ORDER BY v.venue_name;

-- Q25. Equipment that was never requested
SELECT q.equipment_name
FROM equipment q
LEFT JOIN request r ON q.equipment_id = r.equipment_id
WHERE r.request_id IS NULL;

-- Q26. Admins and the requests they reviewed (right join)
SELECT a.admin_name, r.request_id, r.decision
FROM request r
RIGHT JOIN administrator a ON r.admin_id = a.admin_id
ORDER BY a.admin_name, r.request_id;

-- Q27. Requests and venues with a full outer join
-- equipment requests have no venue, and some venues have no request
SELECT r.request_id, r.request_type, v.venue_name
FROM request r
FULL OUTER JOIN venue v ON r.venue_id = v.venue_id
ORDER BY r.request_id NULLS LAST;

-- Q28. Venue request status for every event
SELECT e.event_name,
       COALESCE(r.decision,
                CASE WHEN r.request_id IS NULL THEN 'NO REQUEST' ELSE 'PENDING' END)
           AS venue_status
FROM event e
LEFT JOIN (SELECT * FROM request WHERE request_type = 'VENUE') r
       ON e.event_id = r.event_id
ORDER BY e.event_name;

-- Q29. Pairs of students in the same club (self join)
SELECT c.club_name, s1.student_name AS student_1, s2.student_name AS student_2
FROM membership m1
JOIN membership m2 ON m1.club_id = m2.club_id AND m1.student_id < m2.student_id
JOIN student s1    ON m1.student_id = s1.student_id
JOIN student s2    ON m2.student_id = s2.student_id
JOIN club c        ON m1.club_id = c.club_id
ORDER BY c.club_name, student_1, student_2;

-- Q30. Clubs that each student hasnt joined yet (cross join minus membership)
SELECT s.student_name, c.club_name
FROM student s CROSS JOIN club c
EXCEPT
SELECT s.student_name, c.club_name
FROM membership m
JOIN student s ON m.student_id = s.student_id
JOIN club c    ON m.club_id = c.club_id
ORDER BY student_name, club_name;

-- Q31. Students registered for a Robotics club event
SELECT student_name
FROM student
WHERE student_id IN (SELECT r.student_id
                     FROM registration r
                     JOIN event_club ec ON r.event_id = ec.event_id
                     JOIN club c        ON ec.club_id = c.club_id
                     WHERE c.club_name = 'Robotics Club');

-- Q32. Students who are not officers
SELECT student_name
FROM student
WHERE student_id NOT IN (SELECT student_id FROM officer);

-- Q33. Clubs that have an event in December 2026
SELECT c.club_name
FROM club c
WHERE EXISTS (SELECT 1
              FROM event_club ec JOIN event e ON ec.event_id = e.event_id
              WHERE ec.club_id = c.club_id
                AND e.event_date BETWEEN '2026-12-01' AND '2026-12-31');

-- Q34. Events that dont have a venue request yet
SELECT e.event_name, e.event_date
FROM event e
WHERE NOT EXISTS (SELECT 1 FROM request r
                  WHERE r.event_id = e.event_id AND r.request_type = 'VENUE');

-- Q35. Venue with the biggest capacity (using ALL)
SELECT venue_name, capacity
FROM venue
WHERE capacity >= ALL (SELECT capacity FROM venue);

-- Q36. Venues bigger than at least one requested venue (using ANY)
SELECT venue_name, capacity
FROM venue
WHERE capacity > ANY (SELECT v.capacity
                      FROM venue v JOIN request r ON v.venue_id = r.venue_id);

-- Q37. Events with more registrations than the average
SELECT e.event_name, COUNT(r.student_id) AS registrations
FROM event e
LEFT JOIN registration r ON e.event_id = r.event_id
GROUP BY e.event_name
HAVING COUNT(r.student_id) > (SELECT AVG(cnt)
                              FROM (SELECT COUNT(r2.student_id) AS cnt
                                    FROM event e2
                                    LEFT JOIN registration r2 ON e2.event_id = r2.event_id
                                    GROUP BY e2.event_id) AS per_event);

-- Q38. Students who registered for all the CS club events (division)
-- method 1: not exists inside not exists
SELECT s.student_name
FROM student s
WHERE NOT EXISTS (
    SELECT ec.event_id
    FROM event_club ec JOIN club c ON ec.club_id = c.club_id
    WHERE c.club_name = 'Computer Science Club'
      AND NOT EXISTS (SELECT 1 FROM registration r
                      WHERE r.student_id = s.student_id
                        AND r.event_id   = ec.event_id));

-- Q39. same as Q38 but with EXCEPT
SELECT s.student_name
FROM student s
WHERE NOT EXISTS (
    SELECT ec.event_id
    FROM event_club ec JOIN club c ON ec.club_id = c.club_id
    WHERE c.club_name = 'Computer Science Club'
    EXCEPT
    SELECT r.event_id FROM registration r WHERE r.student_id = s.student_id);

-- Q40. same as Q38 but by counting
SELECT s.student_name
FROM student s
JOIN registration r ON s.student_id = r.student_id
JOIN event_club ec  ON r.event_id = ec.event_id
JOIN club c         ON ec.club_id = c.club_id
WHERE c.club_name = 'Computer Science Club'
GROUP BY s.student_name
HAVING COUNT(*) = (SELECT COUNT(*)
                   FROM event_club ec2 JOIN club c2 ON ec2.club_id = c2.club_id
                   WHERE c2.club_name = 'Computer Science Club');

-- Q41. Which club has the most members? (with WITH)
WITH club_size AS (
    SELECT c.club_name, COUNT(m.student_id) AS members
    FROM club c LEFT JOIN membership m ON c.club_id = m.club_id
    GROUP BY c.club_name
)
SELECT club_name, members
FROM club_size
WHERE members = (SELECT MAX(members) FROM club_size);

-- Q42. Clubs that organize an event with 'Debate' in the name
SELECT DISTINCT c.club_name
FROM club c
JOIN event_club ec ON c.club_id = ec.club_id
JOIN event e       ON ec.event_id = e.event_id
WHERE e.event_name LIKE '%Debate%';

-- Q43. Status of each request, pending ones first
SELECT r.request_id, e.event_name, r.request_type,
       CASE
           WHEN r.decision IS NULL      THEN 'Pending'
           WHEN r.decision = 'APPROVED' THEN 'Approved'
           ELSE 'Rejected'
       END AS status
FROM request r
JOIN event e ON r.event_id = e.event_id
ORDER BY (r.decision IS NULL) DESC, r.request_date;
