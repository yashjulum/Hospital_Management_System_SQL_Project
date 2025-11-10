create database Hospital;
use Hospital;

CREATE TABLE patients (
  patient_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  gender ENUM('Male', 'Female', 'Other') NOT NULL,
  dob DATE NOT NULL,
  contact_no VARCHAR(15) UNIQUE NOT NULL,
  address VARCHAR(255)
);

CREATE TABLE doctors (
  doctor_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  specialization VARCHAR(100) NOT NULL,
  contact_no VARCHAR(15) UNIQUE NOT NULL,
  email VARCHAR(100) UNIQUE NOT NULL
);


CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  doctor_id INT,
  appointment_date DATE NOT NULL,
  appointment_time TIME NOT NULL,
  status ENUM('Scheduled','Completed','Cancelled') DEFAULT 'Scheduled',
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);



CREATE TABLE treatments (
  treatment_id INT AUTO_INCREMENT PRIMARY KEY,
  appointment_id INT,
  diagnosis VARCHAR(255),
  treatment_given VARCHAR(255),
  prescribed_medicine VARCHAR(255),
  treatment_cost DECIMAL(10,2),
  FOREIGN KEY (appointment_id) REFERENCES appointments(appointment_id)
);




CREATE TABLE billing (
  bill_id INT AUTO_INCREMENT PRIMARY KEY,
  patient_id INT,
  total_amount DECIMAL(10,2),
  amount_paid DECIMAL(10,2),
  payment_status ENUM('Paid','Pending','Partial') DEFAULT 'Pending',
  bill_date DATE,
  FOREIGN KEY (patient_id) REFERENCES patients(patient_id)
);


CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  role ENUM('Nurse','Receptionist','Technician','Cleaner','Security') NOT NULL,
  contact_no VARCHAR(15),
  shift_time ENUM('Morning','Evening','Night') NOT NULL
);





