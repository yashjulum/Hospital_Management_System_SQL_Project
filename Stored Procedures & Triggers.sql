DELIMITER $$

CREATE TRIGGER after_treatment_insert
AFTER INSERT ON treatments
FOR EACH ROW
BEGIN
  DECLARE total DECIMAL(10,2);

  SELECT SUM(treatment_cost)
  INTO total
  FROM treatments t
  JOIN appointments a ON t.appointment_id = a.appointment_id
  WHERE a.patient_id = (
    SELECT patient_id FROM appointments WHERE appointment_id = NEW.appointment_id
  );

  UPDATE billing
  SET total_amount = total
  WHERE patient_id = (
    SELECT patient_id FROM appointments WHERE appointment_id = NEW.appointment_id
  );
END$$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE GetPatientReport(IN p_id INT)
BEGIN
  SELECT p.name AS Patient, d.name AS Doctor, d.specialization,
         a.appointment_date, t.diagnosis, t.treatment_given, 
         t.treatment_cost, b.total_amount, b.payment_status
  FROM patients p
  JOIN appointments a ON p.patient_id = a.patient_id
  JOIN doctors d ON a.doctor_id = d.doctor_id
  JOIN treatments t ON a.appointment_id = t.appointment_id
  JOIN billing b ON p.patient_id = b.patient_id
  WHERE p.patient_id = p_id;
END$$

DELIMITER ;




