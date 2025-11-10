-- Show all patients
SELECT * FROM patients;

-- Show all doctors
SELECT * FROM doctors;

-- Show all upcoming scheduled appointments
SELECT * FROM appointments WHERE status = 'Scheduled';

-- Show all completed treatments with appointment info
SELECT * FROM treatments t 
JOIN appointments a ON t.appointment_id = a.appointment_id 
WHERE a.status = 'Completed';


-- 📋 JOIN QUERIES

-- Show patient name, doctor name, specialization, appointment date, and status
SELECT p.name AS 'Patient Name', d.name AS 'Doctor Name', d.specialization AS 'Specialization',
       a.appointment_date AS 'Appointment Date', a.status AS 'Status'
FROM appointments a
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

-- Show complete treatment details with patient and doctor info
SELECT p.name AS 'Patient', d.name AS 'Doctor', d.specialization,
       t.diagnosis, t.treatment_given, t.prescribed_medicine, t.treatment_cost
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN patients p ON a.patient_id = p.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;

-- Show billing details linked with patients
SELECT p.name AS 'Patient Name', b.total_amount AS 'Total Bill', b.amount_paid AS 'Amount Paid',
       b.payment_status AS 'Status', b.bill_date AS 'Bill Date'
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
ORDER BY b.bill_date;


-- 💰 AGGREGATE / GROUP QUERIES

-- Count total patients by city
SELECT address, COUNT(*) AS 'Total Patients'
FROM patients
GROUP BY address
ORDER BY COUNT(*) DESC;

-- Total earnings by each doctor
SELECT d.name AS 'Doctor Name', d.specialization, SUM(t.treatment_cost) AS 'Total Earnings'
FROM treatments t
JOIN appointments a ON t.appointment_id = a.appointment_id
JOIN doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.name, d.specialization
ORDER BY SUM(t.treatment_cost) DESC;

-- Average treatment cost by doctor specialization
SELECT d.specialization, ROUND(AVG(t.treatment_cost),2) AS 'Average Cost'
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.specialization;


-- 📊 SUBQUERIES

-- Patients who paid above the average billing amount
SELECT name 
FROM patients 
WHERE patient_id IN (
  SELECT patient_id 
  FROM billing 
  WHERE total_amount > (SELECT AVG(total_amount) FROM billing)
);

-- Doctors who have more than 3 appointments
SELECT d.name, d.specialization, COUNT(a.appointment_id) AS 'Total Appointments'
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.doctor_id
HAVING COUNT(a.appointment_id) > 3;

-- Patients with unpaid or partially paid bills
SELECT p.name, b.payment_status, b.total_amount
FROM patients p
JOIN billing b ON p.patient_id = b.patient_id
WHERE b.payment_status IN ('Pending','Partial');


-- 📈 ANALYTICAL QUERIES

-- Top 5 highest billed patients
SELECT p.name, b.total_amount
FROM billing b
JOIN patients p ON b.patient_id = p.patient_id
ORDER BY b.total_amount DESC
LIMIT 5;

-- Total revenue by specialization
SELECT d.specialization, SUM(t.treatment_cost) AS 'Total Revenue'
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
JOIN treatments t ON a.appointment_id = t.appointment_id
GROUP BY d.specialization
ORDER BY SUM(t.treatment_cost) DESC;

-- Monthly revenue report
SELECT DATE_FORMAT(b.bill_date, '%Y-%m') AS 'Month', SUM(b.total_amount) AS 'Total Revenue'
FROM billing b
GROUP BY DATE_FORMAT(b.bill_date, '%Y-%m')
ORDER BY Month;


-- ⚙️ PROCEDURE AND TRIGGER TESTS

-- Run the stored procedure for patient 1
CALL GetPatientReport(1);

-- Add new treatment to test trigger update in billing
INSERT INTO treatments (appointment_id, diagnosis, treatment_given, prescribed_medicine, treatment_cost)
VALUES (2, 'Cold', 'Medication', 'Dolo 650', 400.00);

-- Verify billing update after trigger fires
SELECT * FROM billing WHERE patient_id = (SELECT patient_id FROM appointments WHERE appointment_id = 2);


-- 👷‍♂️ STAFF QUERIES

-- Count of staff members by role
SELECT role, COUNT(*) AS 'Total Staff' FROM staff GROUP BY role;

-- List of all night shift staff
SELECT name, role FROM staff WHERE shift_time = 'Night';

-- List of technicians working in the evening shift
SELECT name FROM staff WHERE role = 'Technician' AND shift_time = 'Evening';


-- 🧾 BONUS QUERIES

-- Most common diagnosis across all treatments
SELECT diagnosis, COUNT(*) AS 'Occurrences' 
FROM treatments 
GROUP BY diagnosis 
ORDER BY COUNT(*) DESC 
LIMIT 1;

-- Patient with the maximum number of visits
SELECT p.name, COUNT(a.appointment_id) AS 'Total Visits'
FROM patients p
JOIN appointments a ON p.patient_id = a.patient_id
GROUP BY p.name
ORDER BY COUNT(a.appointment_id) DESC
LIMIT 1;

-- Doctors who have treated more than 2 unique patients
SELECT d.name, COUNT(DISTINCT a.patient_id) AS 'Unique Patients'
FROM doctors d
JOIN appointments a ON d.doctor_id = a.doctor_id
GROUP BY d.name
HAVING COUNT(DISTINCT a.patient_id) > 2;