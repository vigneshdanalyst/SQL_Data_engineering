--1) Show each appointment with the doctor's name, specialization, patient name, and fee.
SELECT d.doctor_name,
	   d.specialization,
	   a.patient_name,
	   a.fee,
	   a.appointment_date
FROM appointments AS a 
INNER JOIN doctors AS d 
ON a.doctor_id = d.doctor_id;


--2) Find total revenue earned per doctor. Show doctor name and total fees collected, sorted highest first.
SELECT d.doctor_name,
	   SUM(fee) AS total_fee
FROM appointments AS a 
INNER JOIN doctors AS d 
ON a.doctor_id = d.doctor_id 
GROUP BY d.doctor_name
ORDER BY total_fee DESC;


--3) Show only Cardiology appointments. Display doctor name, hospital, patient name, and appointment date.

SELECT d.doctor_name,
	   d.hospital,
	   a.patient_name,
	   a.appointment_date
FROM appointments AS a 
INNER JOIN doctors AS d 
ON a.doctor_id = d.doctor_id 
WHERE specialization = 'Cardiology';


--4) Find which hospital has collected the most total fee revenue across all appointments.

SELECT d.hospital,
       SUM(fee) AS total_revenue
FROM appointments AS a 
INNER JOIN doctors AS d 
ON a.doctor_id = d.doctor_id 
GROUP BY d.hospital
ORDER BY total_revenue DESC;


--5) Count how many appointments each specialization has handled.

SELECT d.specialization,
	   COUNT(a.doctor_id) AS total_appointments 
FROM appointments AS a 
INNER JOIN doctors AS d 
ON a.doctor_id = d.doctor_id
GROUP BY d.specialization
ORDER BY total_appointments DESC

