--1) Show each student's name, the course they enrolled in, and their score.

SELECT s.student_name,
       c.course_name,
	   e.score
FROM enrollments AS e 
INNER JOIN students AS s 
ON e.student_id = s.student_id
INNER JOIN courses AS c 
ON e.course_id = c.course_id;


--2) Find the average score per course. Show course name and average score, sorted highest first.
SELECT c.course_name,
	    AVG(e.score) AS average_score
FROM enrollments AS e 
INNER JOIN courses AS c 
ON e.course_id = c.course_id 
GROUP BY c.course_name 
ORDER BY average_score DESC


--3) Show students who scored above 85. Display student name, course name, and score.

SELECT s.student_name,
	   c.course_name,
	   e.score
FROM enrollments AS e 
INNER JOIN students AS s 
ON e.student_id = s.student_id
INNER JOIN courses AS c 
ON e.course_id = c.course_id
WHERE e.score > 85;


--4) Find which department has the highest average score across all enrollments.

SELECT s.department, 
	   AVG(e.score) AS Average_score 
FROM enrollments AS e 
INNER JOIN students AS s 
ON e.student_id = s.student_id 
GROUP BY s.department 
ORDER BY Average_score DESC 
LIMIT 1;

--5) Count how many students each instructor is teaching.

SELECT c.instructor, 
		COUNT(s.student_name) AS No_of_students
FROM enrollments AS e 
INNER JOIN students AS s
ON e.student_id = s.student_id 
INNER JOIN courses AS c 
ON e.course_id = c.course_id 
GROUP BY c.instructor
ORDER BY No_of_students DESC;



