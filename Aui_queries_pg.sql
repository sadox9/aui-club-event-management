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


-- =====================================================================
-- ADVANCED QUERIES: ordering, set operations, outer joins, subqueries
-- =====================================================================

-- ---------------------------------------------------------------------
-- ORDER BY
-- ---------------------------------------------------------------------

-- Q13. List all events, latest first; events on the same date sorted by name.
SELECT event_name, event_date
FROM event
ORDER BY event_date DESC, event_name ASC;

-- Q14. Top 3 venues by capacity.
SELECT venue_name, capacity
FROM venue
ORDER BY capacity DESC
LIMIT 3;

-- Q15. Clubs ranked by number of members (most first), ties broken by name.
SELECT c.club_name, COUNT(m.student_id) AS number_of_members
FROM club c
LEFT JOIN membership m ON c.club_id = m.club_id
GROUP BY c.club_name
ORDER BY number_of_members DESC, c.club_name;

-- ---------------------------------------------------------------------
-- UNION / UNION ALL
-- ---------------------------------------------------------------------

-- Q16. Every person in the system (students and administrators) with their type.
SELECT student_name AS person_name, 'Student' AS person_type
FROM student
UNION
SELECT admin_name, 'Administrator'
FROM administrator
ORDER BY person_type, person_name;

-- Q17. Every resource (venue or equipment) that was requested at least once.
--      UNION removes duplicates (a resource requested twice appears once).
SELECT v.venue_name AS resource_name, 'Venue' AS resource_type
FROM request r JOIN venue v ON r.venue_id = v.venue_id
UNION
SELECT q.equipment_name, 'Equipment'
FROM request r JOIN equipment q ON r.equipment_id = q.equipment_id
ORDER BY resource_type, resource_name;

-- Q18. UNION ALL keeps duplicates: one row per student-club link,
--      once as a member, and again if the student is also an officer.
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

-- ---------------------------------------------------------------------
-- INTERSECT
-- ---------------------------------------------------------------------

-- Q19. Students who are members of BOTH the Computer Science Club and the Debate Club.
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

-- Q20. Officers who also registered for at least one event.
SELECT s.student_name
FROM student s JOIN officer o ON s.student_id = o.student_id
INTERSECT
SELECT s.student_name
FROM student s JOIN registration r ON s.student_id = r.student_id;

-- ---------------------------------------------------------------------
-- EXCEPT (set difference)
-- ---------------------------------------------------------------------

-- Q21. Students who are club members but hold no officer position.
SELECT s.student_id, s.student_name
FROM student s JOIN membership m ON s.student_id = m.student_id
EXCEPT
SELECT s.student_id, s.student_name
FROM student s JOIN officer o ON s.student_id = o.student_id
ORDER BY student_id;

-- Q22. Venues that have never been requested.
SELECT venue_name FROM venue
EXCEPT
SELECT v.venue_name
FROM venue v JOIN request r ON v.venue_id = r.venue_id;

-- Q23. Debate Club members who did NOT register for the 'Inter-University Debate'.
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

-- ---------------------------------------------------------------------
-- OUTER JOINS (LEFT / RIGHT / FULL)
-- ---------------------------------------------------------------------

-- Q24. LEFT JOIN: every venue with its requests (venues never requested show NULLs).
SELECT v.venue_name, r.request_id, r.decision
FROM venue v
LEFT JOIN request r ON v.venue_id = r.venue_id
ORDER BY v.venue_name;

-- Q25. LEFT JOIN + IS NULL (anti-join): equipment that has never been requested.
SELECT q.equipment_name
FROM equipment q
LEFT JOIN request r ON q.equipment_id = r.equipment_id
WHERE r.request_id IS NULL;

-- Q26. RIGHT JOIN: every administrator and the requests they reviewed
--      (same result as a LEFT JOIN with the two tables swapped).
SELECT a.admin_name, r.request_id, r.decision
FROM request r
RIGHT JOIN administrator a ON r.admin_id = a.admin_id
ORDER BY a.admin_name, r.request_id;

-- Q27. FULL OUTER JOIN: all requests and all venues together.
--      Equipment requests have no venue (NULL venue_name);
--      unused venues have no request (NULL request_id).
SELECT r.request_id, r.request_type, v.venue_name
FROM request r
FULL OUTER JOIN venue v ON r.venue_id = v.venue_id
ORDER BY r.request_id NULLS LAST;

-- Q28. LEFT JOIN on a filtered subquery + COALESCE: venue status of every event,
--      including events that have no venue request at all.
SELECT e.event_name,
       COALESCE(r.decision,
                CASE WHEN r.request_id IS NULL THEN 'NO REQUEST' ELSE 'PENDING' END)
           AS venue_status
FROM event e
LEFT JOIN (SELECT * FROM request WHERE request_type = 'VENUE') r
       ON e.event_id = r.event_id
ORDER BY e.event_name;

-- ---------------------------------------------------------------------
-- SELF JOIN and CROSS JOIN
-- ---------------------------------------------------------------------

-- Q29. SELF JOIN: pairs of students who share a club (each pair listed once).
SELECT c.club_name, s1.student_name AS student_1, s2.student_name AS student_2
FROM membership m1
JOIN membership m2 ON m1.club_id = m2.club_id AND m1.student_id < m2.student_id
JOIN student s1    ON m1.student_id = s1.student_id
JOIN student s2    ON m2.student_id = s2.student_id
JOIN club c        ON m1.club_id = c.club_id
ORDER BY c.club_name, student_1, student_2;

-- Q30. CROSS JOIN + EXCEPT: clubs each student has not joined yet.
SELECT s.student_name, c.club_name
FROM student s CROSS JOIN club c
EXCEPT
SELECT s.student_name, c.club_name
FROM membership m
JOIN student s ON m.student_id = s.student_id
JOIN club c    ON m.club_id = c.club_id
ORDER BY student_name, club_name;

-- ---------------------------------------------------------------------
-- SUBQUERIES: IN / NOT IN / EXISTS / NOT EXISTS / ANY / ALL
-- ---------------------------------------------------------------------

-- Q31. IN: students registered for an event organized by the Robotics Club.
SELECT student_name
FROM student
WHERE student_id IN (SELECT r.student_id
                     FROM registration r
                     JOIN event_club ec ON r.event_id = ec.event_id
                     JOIN club c        ON ec.club_id = c.club_id
                     WHERE c.club_name = 'Robotics Club');

-- Q32. NOT IN: students who are not officers of any club.
SELECT student_name
FROM student
WHERE student_id NOT IN (SELECT student_id FROM officer);

-- Q33. EXISTS (correlated): clubs that organize at least one event in December 2026.
SELECT c.club_name
FROM club c
WHERE EXISTS (SELECT 1
              FROM event_club ec JOIN event e ON ec.event_id = e.event_id
              WHERE ec.club_id = c.club_id
                AND e.event_date BETWEEN '2026-12-01' AND '2026-12-31');

-- Q34. NOT EXISTS: events that have no venue request yet.
SELECT e.event_name, e.event_date
FROM event e
WHERE NOT EXISTS (SELECT 1 FROM request r
                  WHERE r.event_id = e.event_id AND r.request_type = 'VENUE');

-- Q35. >= ALL: the venue(s) with the largest capacity.
SELECT venue_name, capacity
FROM venue
WHERE capacity >= ALL (SELECT capacity FROM venue);

-- Q36. > ANY: venues larger than at least one venue that has been requested.
SELECT venue_name, capacity
FROM venue
WHERE capacity > ANY (SELECT v.capacity
                      FROM venue v JOIN request r ON v.venue_id = r.venue_id);

-- Q37. Nested subquery: events with more registrations than the average event.
SELECT e.event_name, COUNT(r.student_id) AS registrations
FROM event e
LEFT JOIN registration r ON e.event_id = r.event_id
GROUP BY e.event_name
HAVING COUNT(r.student_id) > (SELECT AVG(cnt)
                              FROM (SELECT COUNT(r2.student_id) AS cnt
                                    FROM event e2
                                    LEFT JOIN registration r2 ON e2.event_id = r2.event_id
                                    GROUP BY e2.event_id) AS per_event);

-- ---------------------------------------------------------------------
-- DIVISION ("for all" queries)
-- ---------------------------------------------------------------------

-- Q38. Students who registered for ALL events organized by the Computer Science Club.
--      Version 1: double NOT EXISTS
--      ("there is no CS event that the student did not register for").
SELECT s.student_name
FROM student s
WHERE NOT EXISTS (
    SELECT ec.event_id
    FROM event_club ec JOIN club c ON ec.club_id = c.club_id
    WHERE c.club_name = 'Computer Science Club'
      AND NOT EXISTS (SELECT 1 FROM registration r
                      WHERE r.student_id = s.student_id
                        AND r.event_id   = ec.event_id));

-- Q39. Same question, Version 2: EXCEPT
--      (CS events minus the events of the student must be empty).
SELECT s.student_name
FROM student s
WHERE NOT EXISTS (
    SELECT ec.event_id
    FROM event_club ec JOIN club c ON ec.club_id = c.club_id
    WHERE c.club_name = 'Computer Science Club'
    EXCEPT
    SELECT r.event_id FROM registration r WHERE r.student_id = s.student_id);

-- Q40. Same question, Version 3: counting
--      (CS events the student registered for = total number of CS events).
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

-- ---------------------------------------------------------------------
-- WITH (CTE), LIKE, DISTINCT, CASE
-- ---------------------------------------------------------------------

-- Q41. WITH: the club(s) with the most members.
WITH club_size AS (
    SELECT c.club_name, COUNT(m.student_id) AS members
    FROM club c LEFT JOIN membership m ON c.club_id = m.club_id
    GROUP BY c.club_name
)
SELECT club_name, members
FROM club_size
WHERE members = (SELECT MAX(members) FROM club_size);

-- Q42. LIKE + DISTINCT: clubs that organize an event whose name contains 'Debate'.
SELECT DISTINCT c.club_name
FROM club c
JOIN event_club ec ON c.club_id = ec.club_id
JOIN event e       ON ec.event_id = e.event_id
WHERE e.event_name LIKE '%Debate%';

-- Q43. CASE: label each request with a readable status, pending ones first.
SELECT r.request_id, e.event_name, r.request_type,
       CASE
           WHEN r.decision IS NULL      THEN 'Pending'
           WHEN r.decision = 'APPROVED' THEN 'Approved'
           ELSE 'Rejected'
       END AS status
FROM request r
JOIN event e ON r.event_id = e.event_id
ORDER BY (r.decision IS NULL) DESC, r.request_date;