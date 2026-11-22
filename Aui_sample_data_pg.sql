-- AUI Club, Event & Facility Management System
-- Extended sample data (DML) - PostgreSQL
--
-- AI prompt used to generate this sample data:
--   "make sample data to populate this database each individual table,
--    dont run the insert yet just the file to populate it first"
--
-- Run AFTER aui_schema_pg.sql:
--   psql -v ON_ERROR_STOP=1 -a -f aui_sample_data_pg.sql -U dhanae
--
-- This file EMPTIES every table and reloads a larger data set.
-- The original rows from aui_schema_pg.sql are kept (same ids), so
-- queries that use names like 'AUI Hackathon 2026' still work.
--
-- Rows that exist on purpose for outer-join / set-difference examples:
--   * Chess Club (club 9)          -> has no members and no events
--   * Rania Ouazzani (student 30)  -> belongs to no club
--   * Folding Chairs (equipment 4) -> never requested
--   * several requests have no decision yet (pending)

TRUNCATE request, equipment, venue, administrator, registration,
         event_club, event, officer, membership, club, student
         RESTART IDENTITY CASCADE;

-- =====================================================================
-- 1. STUDENT (30 rows)
-- =====================================================================
INSERT INTO student (student_id, student_name, email) VALUES
(1,  'Amber Alaoui',       'amber.alaoui@aui.ma'),
(2,  'Youssef Benani',     'youssef.benani@aui.ma'),
(3,  'Salma El Idrissi',   'salma.elidrissi@aui.ma'),
(4,  'Omar Tazi',          'omar.tazi@aui.ma'),
(5,  'Lina Chraibi',       'lina.chraibi@aui.ma'),
(6,  'Hamza Berrada',      'hamza.berrada@aui.ma'),
(7,  'Nora Kabbaj',        'nora.kabbaj@aui.ma'),
(8,  'Ilyas Mansouri',     'ilyas.mansouri@aui.ma'),
(9,  'Meryem Fassi',       'meryem.fassi@aui.ma'),
(10, 'Adam Squalli',       'adam.squalli@aui.ma'),
(11, 'Kenza Bennani',      'kenza.bennani@aui.ma'),
(12, 'Mehdi Lahlou',       'mehdi.lahlou@aui.ma'),
(13, 'Sara Amrani',        'sara.amrani@aui.ma'),
(14, 'Rayan Kettani',      'rayan.kettani@aui.ma'),
(15, 'Hiba Sefrioui',      'hiba.sefrioui@aui.ma'),
(16, 'Anas Belkadi',       'anas.belkadi@aui.ma'),
(17, 'Zineb Hajji',        'zineb.hajji@aui.ma'),
(18, 'Karim Ouali',        'karim.ouali@aui.ma'),
(19, 'Yasmine Tahiri',     'yasmine.tahiri@aui.ma'),
(20, 'Walid Naji',         'walid.naji@aui.ma'),
(21, 'Imane Sabri',        'imane.sabri@aui.ma'),
(22, 'Othmane Rifai',      'othmane.rifai@aui.ma'),
(23, 'Aya Benjelloun',     'aya.benjelloun@aui.ma'),
(24, 'Reda El Amrani',     'reda.elamrani@aui.ma'),
(25, 'Ghita Lazrak',       'ghita.lazrak@aui.ma'),
(26, 'Bilal Cherkaoui',    'bilal.cherkaoui@aui.ma'),
(27, 'Dounia Filali',      'dounia.filali@aui.ma'),
(28, 'Taha Bouzidi',       'taha.bouzidi@aui.ma'),
(29, 'Soukaina Moussaoui', 'soukaina.moussaoui@aui.ma'),
(30, 'Rania Ouazzani',     'rania.ouazzani@aui.ma');

-- =====================================================================
-- 2. CLUB (9 rows)
-- =====================================================================
INSERT INTO club (club_id, club_name) VALUES
(1, 'Computer Science Club'),
(2, 'Debate Club'),
(3, 'Robotics Club'),
(4, 'Drama Club'),
(5, 'Photography Club'),
(6, 'Music Club'),
(7, 'Entrepreneurship Club'),
(8, 'Environmental Club'),
(9, 'Chess Club');

-- =====================================================================
-- 3. MEMBERSHIP (35 rows)
-- =====================================================================
INSERT INTO membership (student_id, club_id, join_date) VALUES
-- Computer Science Club
(1,  1, '2025-09-15'),
(2,  1, '2025-09-20'),
(3,  1, '2026-01-10'),
(23, 1, '2026-02-03'),
(24, 1, '2026-09-05'),
-- Debate Club
(1,  2, '2025-10-01'),
(4,  2, '2025-09-18'),
(5,  2, '2026-02-05'),
(27, 2, '2026-09-12'),
-- Robotics Club
(6,  3, '2025-09-25'),
(2,  3, '2026-01-20'),
(25, 3, '2026-03-14'),
(26, 3, '2026-09-08'),
-- Drama Club
(7,  4, '2025-10-12'),
(8,  4, '2026-02-14'),
(3,  4, '2026-03-01'),
(28, 4, '2026-09-20'),
-- Photography Club
(9,  5, '2025-09-17'),
(10, 5, '2025-09-22'),
(11, 5, '2026-01-25'),
(12, 5, '2026-02-10'),
-- Music Club
(13, 6, '2025-09-19'),
(14, 6, '2025-10-05'),
(15, 6, '2026-01-30'),
(9,  6, '2026-02-18'),
(29, 6, '2026-03-02'),
-- Entrepreneurship Club
(16, 7, '2025-09-23'),
(17, 7, '2025-10-10'),
(18, 7, '2026-02-01'),
(4,  7, '2026-02-20'),
(19, 7, '2026-09-15'),
-- Environmental Club
(20, 8, '2025-09-29'),
(21, 8, '2025-11-03'),
(22, 8, '2026-02-12'),
(10, 8, '2026-03-08');
-- Chess Club (9) has no members; student 30 is in no club.

-- =====================================================================
-- 4. OFFICER (15 rows) - each (student, club) pair exists in MEMBERSHIP
-- =====================================================================
INSERT INTO officer (officer_id, student_id, club_id, officer_role) VALUES
(1,  1,  1, 'President'),
(2,  2,  1, 'Treasurer'),
(3,  4,  2, 'President'),
(4,  6,  3, 'President'),
(5,  7,  4, 'President'),
(6,  3,  1, 'Secretary'),
(7,  5,  2, 'Vice President'),
(8,  2,  3, 'Vice President'),
(9,  9,  5, 'President'),
(10, 10, 5, 'Treasurer'),
(11, 13, 6, 'President'),
(12, 16, 7, 'President'),
(13, 4,  7, 'Treasurer'),
(14, 20, 8, 'President'),
(15, 8,  4, 'Secretary');

-- =====================================================================
-- 5. EVENT (15 rows)
-- =====================================================================
INSERT INTO event (event_id, event_name, event_date, created_by_officer_id) VALUES
(1,  'AUI Hackathon 2026',          '2026-10-15', 1),
(2,  'Inter-University Debate',     '2026-12-05', 3),
(3,  'Robotics Workshop',           '2026-10-22', 4),
(4,  'Theater Night',               '2026-12-12', 5),
(5,  'Technology and Debate Panel', '2026-12-15', 1),
(6,  'Campus Photo Walk',           '2026-11-08', 9),
(7,  'Spring Concert',              '2026-04-18', 11),
(8,  'Startup Pitch Day',           '2026-11-20', 12),
(9,  'Campus Clean-Up Day',         '2026-09-27', 14),
(10, 'Intro to Python Workshop',    '2026-09-10', 2),
(11, 'Photography Exhibition',      '2027-01-20', 10),
(12, 'Jazz Evening',                '2026-12-18', 11),
(13, 'Green Business Forum',        '2027-02-10', 13),
(14, 'Drone Racing Challenge',      '2027-03-05', 8),
(15, 'Open Mic Night',              '2027-02-25', 15);

-- =====================================================================
-- 6. EVENT_CLUB (18 rows) - events 5, 13 and 15 are co-organized
-- =====================================================================
INSERT INTO event_club (event_id, club_id) VALUES
(1,  1),
(2,  2),
(3,  3),
(4,  4),
(5,  1),
(5,  2),
(6,  5),
(7,  6),
(8,  7),
(9,  8),
(10, 1),
(11, 5),
(12, 6),
(13, 7),
(13, 8),
(14, 3),
(15, 4),
(15, 6);

-- =====================================================================
-- 7. REGISTRATION (63 rows)
--    attended = TRUE/FALSE for past events, NULL for upcoming events
-- =====================================================================
INSERT INTO registration (student_id, event_id, registration_date, attended) VALUES
-- 1. AUI Hackathon 2026 (past)
(1,  1, '2026-10-01', TRUE),
(2,  1, '2026-10-02', TRUE),
(3,  1, '2026-10-03', FALSE),
(23, 1, '2026-10-05', TRUE),
(24, 1, '2026-10-05', TRUE),
-- 2. Inter-University Debate (upcoming)
(4,  2, '2026-11-01', NULL),
(5,  2, '2026-11-01', NULL),
(27, 2, '2026-11-03', NULL),
-- 3. Robotics Workshop (past)
(6,  3, '2026-10-10', TRUE),
(2,  3, '2026-10-12', TRUE),
-- 4. Theater Night (upcoming)
(7,  4, '2026-11-01', NULL),
(8,  4, '2026-11-01', NULL),
-- 5. Technology and Debate Panel (upcoming)
(1,  5, '2026-11-01', NULL),
(4,  5, '2026-11-01', NULL),
(2,  5, '2026-11-04', NULL),
(27, 5, '2026-11-06', NULL),
-- 6. Campus Photo Walk (past)
(9,  6, '2026-10-20', TRUE),
(10, 6, '2026-10-21', TRUE),
(11, 6, '2026-10-22', FALSE),
(12, 6, '2026-10-25', TRUE),
(30, 6, '2026-10-28', TRUE),
-- 7. Spring Concert (past)
(13, 7, '2026-04-01', TRUE),
(14, 7, '2026-04-01', TRUE),
(15, 7, '2026-04-02', TRUE),
(9,  7, '2026-04-05', FALSE),
(29, 7, '2026-04-06', TRUE),
(1,  7, '2026-04-10', TRUE),
-- 8. Startup Pitch Day (past)
(16, 8, '2026-11-05', TRUE),
(17, 8, '2026-11-05', TRUE),
(18, 8, '2026-11-06', FALSE),
(4,  8, '2026-11-07', TRUE),
(19, 8, '2026-11-08', TRUE),
(24, 8, '2026-11-10', TRUE),
-- 9. Campus Clean-Up Day (past)
(20, 9, '2026-09-15', TRUE),
(21, 9, '2026-09-15', TRUE),
(22, 9, '2026-09-16', TRUE),
(10, 9, '2026-09-18', TRUE),
(6,  9, '2026-09-20', FALSE),
-- 10. Intro to Python Workshop (past)
(1,  10, '2026-09-01', TRUE),
(2,  10, '2026-09-01', TRUE),
(3,  10, '2026-09-02', TRUE),
(23, 10, '2026-09-03', TRUE),
(24, 10, '2026-09-05', FALSE),
(25, 10, '2026-09-06', TRUE),
-- 11. Photography Exhibition (upcoming)
(9,  11, '2026-11-15', NULL),
(11, 11, '2026-11-16', NULL),
(12, 11, '2026-11-17', NULL),
-- 12. Jazz Evening (upcoming)
(13, 12, '2026-11-18', NULL),
(15, 12, '2026-11-18', NULL),
(29, 12, '2026-11-19', NULL),
(7,  12, '2026-11-20', NULL),
-- 13. Green Business Forum (upcoming)
(16, 13, '2026-11-21', NULL),
(20, 13, '2026-11-21', NULL),
(21, 13, '2026-11-21', NULL),
(17, 13, '2026-11-22', NULL),
-- 14. Drone Racing Challenge (upcoming)
(6,  14, '2026-11-19', NULL),
(25, 14, '2026-11-19', NULL),
(26, 14, '2026-11-20', NULL),
(2,  14, '2026-11-21', NULL),
-- 15. Open Mic Night (upcoming)
(7,  15, '2026-11-20', NULL),
(8,  15, '2026-11-20', NULL),
(28, 15, '2026-11-21', NULL),
(14, 15, '2026-11-22', NULL);

-- =====================================================================
-- 8. ADMINISTRATOR (4 rows)
-- =====================================================================
INSERT INTO administrator (admin_id, admin_name) VALUES
(1, 'Dr. Karim Naciri'),
(2, 'Ms. Fatima Zahra Amrani'),
(3, 'Mr. Driss Lahlou'),
(4, 'Dr. Samira Bennis');

-- =====================================================================
-- 9. VENUE (8 rows)
-- =====================================================================
INSERT INTO venue (venue_id, venue_name, capacity) VALUES
(1, 'Main Auditorium',          500),
(2, 'Conference Room A',         60),
(3, 'Computer Lab 1',            40),
(4, 'Outdoor Stage',            200),
(5, 'Building 8 Amphitheater',  250),
(6, 'Sports Complex',           800),
(7, 'Library Seminar Room',      30),
(8, 'Student Center Lounge',    120);

-- =====================================================================
-- 10. EQUIPMENT (8 rows)
-- =====================================================================
INSERT INTO equipment (equipment_id, equipment_name, total_quantity) VALUES
(1, 'Projector',       10),
(2, 'Microphone',      20),
(3, 'Laptop',          15),
(4, 'Folding Chairs', 200),
(5, 'Speaker System',   6),
(6, 'Extension Cords', 30),
(7, 'Whiteboard',       8),
(8, 'Camera Tripod',   12);

-- =====================================================================
-- 11. REQUEST (27 rows)
--     VENUE requests: venue_id set, equipment_id and quantity NULL
--     EQUIPMENT requests: equipment_id and quantity set, venue_id NULL
--     Pending requests: admin_id, decision and decision_date all NULL
-- =====================================================================
INSERT INTO request (request_id, event_id, request_type, request_date, venue_id, equipment_id,
                     start_time, end_time, quantity, admin_id, decision, decision_date) VALUES
(1,  1,  'VENUE',     '2026-10-01', 3,    NULL, '2026-10-15 09:00:00', '2026-10-15 18:00:00', NULL, 1,    'APPROVED', '2026-10-03'),
(2,  1,  'EQUIPMENT', '2026-10-01', NULL, 3,    '2026-10-15 09:00:00', '2026-10-15 18:00:00', 10,   1,    'APPROVED', '2026-10-03'),
(3,  2,  'VENUE',     '2026-11-10', 1,    NULL, '2026-12-05 14:00:00', '2026-12-05 18:00:00', NULL, 2,    'APPROVED', '2026-11-12'),
(4,  2,  'EQUIPMENT', '2026-11-10', NULL, 2,    '2026-12-05 14:00:00', '2026-12-05 18:00:00', 4,    2,    'REJECTED', '2026-11-12'),
(5,  4,  'VENUE',     '2026-11-01', 4,    NULL, '2026-12-12 19:00:00', '2026-12-12 22:00:00', NULL, NULL, NULL,       NULL),
(6,  3,  'EQUIPMENT', '2026-10-15', NULL, 1,    '2026-10-22 10:00:00', '2026-10-22 12:00:00', 2,    1,    'APPROVED', '2026-10-20'),
(7,  6,  'VENUE',     '2026-10-15', 4,    NULL, '2026-11-08 08:00:00', '2026-11-08 12:00:00', NULL, 3,    'APPROVED', '2026-10-18'),
(8,  6,  'EQUIPMENT', '2026-10-15', NULL, 8,    '2026-11-08 08:00:00', '2026-11-08 12:00:00', 6,    3,    'APPROVED', '2026-10-18'),
(9,  7,  'VENUE',     '2026-03-20', 1,    NULL, '2026-04-18 19:00:00', '2026-04-18 23:00:00', NULL, 2,    'APPROVED', '2026-03-25'),
(10, 7,  'EQUIPMENT', '2026-03-20', NULL, 5,    '2026-04-18 19:00:00', '2026-04-18 23:00:00', 4,    2,    'APPROVED', '2026-03-25'),
(11, 7,  'EQUIPMENT', '2026-03-20', NULL, 2,    '2026-04-18 19:00:00', '2026-04-18 23:00:00', 8,    2,    'APPROVED', '2026-03-25'),
(12, 8,  'VENUE',     '2026-10-25', 5,    NULL, '2026-11-20 09:00:00', '2026-11-20 17:00:00', NULL, 4,    'APPROVED', '2026-10-28'),
(13, 8,  'EQUIPMENT', '2026-10-25', NULL, 1,    '2026-11-20 09:00:00', '2026-11-20 17:00:00', 3,    4,    'APPROVED', '2026-10-28'),
(14, 9,  'VENUE',     '2026-09-01', 4,    NULL, '2026-09-27 08:00:00', '2026-09-27 13:00:00', NULL, 1,    'APPROVED', '2026-09-04'),
(15, 10, 'VENUE',     '2026-08-25', 3,    NULL, '2026-09-10 14:00:00', '2026-09-10 17:00:00', NULL, 1,    'APPROVED', '2026-08-27'),
(16, 10, 'VENUE',     '2026-08-25', 7,    NULL, '2026-09-10 14:00:00', '2026-09-10 17:00:00', NULL, 1,    'REJECTED', '2026-08-27'),
(17, 11, 'VENUE',     '2026-11-15', 8,    NULL, '2027-01-20 10:00:00', '2027-01-20 18:00:00', NULL, NULL, NULL,       NULL),
(18, 11, 'EQUIPMENT', '2026-11-15', NULL, 7,    '2027-01-20 10:00:00', '2027-01-20 18:00:00', 4,    NULL, NULL,       NULL),
(19, 12, 'VENUE',     '2026-11-10', 8,    NULL, '2026-12-18 19:00:00', '2026-12-18 22:00:00', NULL, 3,    'APPROVED', '2026-11-14'),
(20, 12, 'EQUIPMENT', '2026-11-10', NULL, 5,    '2026-12-18 19:00:00', '2026-12-18 22:00:00', 2,    3,    'APPROVED', '2026-11-14'),
(21, 13, 'VENUE',     '2026-11-18', 1,    NULL, '2027-02-10 09:00:00', '2027-02-10 16:00:00', NULL, 4,    'REJECTED', '2026-11-20'),
(22, 13, 'VENUE',     '2026-11-20', 5,    NULL, '2027-02-10 09:00:00', '2027-02-10 16:00:00', NULL, NULL, NULL,       NULL),
(23, 14, 'VENUE',     '2026-11-19', 6,    NULL, '2027-03-05 10:00:00', '2027-03-05 17:00:00', NULL, NULL, NULL,       NULL),
(24, 14, 'EQUIPMENT', '2026-11-19', NULL, 6,    '2027-03-05 10:00:00', '2027-03-05 17:00:00', 15,   NULL, NULL,       NULL),
(25, 15, 'VENUE',     '2026-11-20', 2,    NULL, '2027-02-25 20:00:00', '2027-02-25 23:00:00', NULL, 2,    'APPROVED', '2026-11-21'),
(26, 4,  'EQUIPMENT', '2026-11-01', NULL, 2,    '2026-12-12 19:00:00', '2026-12-12 22:00:00', 6,    2,    'APPROVED', '2026-11-05'),
(27, 5,  'VENUE',     '2026-11-12', 1,    NULL, '2026-12-15 15:00:00', '2026-12-15 18:00:00', NULL, 1,    'REJECTED', '2026-11-14');


-- Move each id counter past the ids inserted above, so new rows get new ids
SELECT setval(pg_get_serial_sequence('student','student_id'),     (SELECT MAX(student_id)   FROM student));
SELECT setval(pg_get_serial_sequence('club','club_id'),           (SELECT MAX(club_id)      FROM club));
SELECT setval(pg_get_serial_sequence('officer','officer_id'),     (SELECT MAX(officer_id)   FROM officer));
SELECT setval(pg_get_serial_sequence('event','event_id'),         (SELECT MAX(event_id)     FROM event));
SELECT setval(pg_get_serial_sequence('administrator','admin_id'), (SELECT MAX(admin_id)     FROM administrator));
SELECT setval(pg_get_serial_sequence('venue','venue_id'),         (SELECT MAX(venue_id)     FROM venue));
SELECT setval(pg_get_serial_sequence('equipment','equipment_id'), (SELECT MAX(equipment_id) FROM equipment));
SELECT setval(pg_get_serial_sequence('request','request_id'),     (SELECT MAX(request_id)   FROM request));
