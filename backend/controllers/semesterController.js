const db = require("../config/db");

exports.getSemesters = (req, res) => {
    db.query(
      `
      SELECT
        s.semester_id,
        s.semester_no,
        d.department_name
      FROM semesters s
      JOIN departments d
        ON s.department_id = d.department_id
      ORDER BY s.semester_no
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
          semesters: results,
        });
      }
    );
  };

exports.addSemester = (req, res) => {
    const { semester_no, department_id } = req.body;
  
    db.query(
      "INSERT INTO semesters (semester_no, department_id) VALUES (?, ?)",
      [semester_no, department_id],
      (err, result) => {
        if (err) {
          return res.status(500).json({
            success: false,
            message: err.message,
          });
        }
  
        res.json({
          success: true,
          message: "Semester Added Successfully",
        });
      }
    );
  };