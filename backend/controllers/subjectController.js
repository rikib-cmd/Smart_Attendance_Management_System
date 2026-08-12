const db = require("../config/db");

exports.getSubjects = (req, res) => {
    db.query(
      `
      SELECT
        s.subject_id,
        s.subject_name,
        d.department_name,
        sem.semester_no
      FROM subjects s
      JOIN departments d
        ON s.department_id = d.department_id
      JOIN semesters sem
        ON s.semester_id = sem.semester_id
      ORDER BY s.subject_name
      `,
      (err, results) => {
        if (err) {
          return res.status(500).json({
            success: false,
            message: err.message,
          });
        }
  
        res.json({
          success: true,
          subjects: results,
        });
      }
    );
  };

  exports.addSubject = (req, res) => {
    const {
      subject_name,
      department_id,
      semester_id,
    } = req.body;
  
    db.query(
      `
      INSERT INTO subjects
      (subject_name, department_id, semester_id)
      VALUES (?, ?, ?)
      `,
      [
        subject_name,
        department_id,
        semester_id,
      ],
      (err) => {
        if (err) {
          return res.status(500).json({
            success: false,
            message: err.message,
          });
        }
  
        res.json({
          success: true,
          message: "Subject Added Successfully",
        });
      }
    );
  };