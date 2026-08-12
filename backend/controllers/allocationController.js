const db = require("../config/db");

exports.getAllocations = (req, res) => {
  const sql = `
    SELECT
      a.allocation_id,
      t.name AS teacher_name,
      s.subject_name,
      d.department_name,
      sem.semester_no,
      a.assigned_date
    FROM class_allocations a
    JOIN teachers t
      ON a.teacher_id = t.teacher_id
    JOIN subjects s
      ON a.subject_id = s.subject_id
    JOIN departments d
      ON a.department_id = d.department_id
    JOIN semesters sem
      ON a.semester_id = sem.semester_id
    ORDER BY a.allocation_id DESC
  `;

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    res.json({
      success: true,
      allocations: results,
    });
  });
};

exports.addAllocation = (req, res) => {
  const {
    teacher_id,
    subject_id,
    department_id,
    semester_id,
  } = req.body;

  const sql = `
    INSERT INTO class_allocations
    (
      teacher_id,
      subject_id,
      department_id,
      semester_id,
      assigned_date
    )
    VALUES (?, ?, ?, ?, CURDATE())
  `;

  db.query(
    sql,
    [
      teacher_id,
      subject_id,
      department_id,
      semester_id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      res.json({
        success: true,
        message: "Allocation Added Successfully",
        allocationId: result.insertId,
      });
    }
  );
};

exports.deleteAllocation = (req, res) => {
  const { id } = req.params;

  db.query(
    "DELETE FROM class_allocations WHERE allocation_id = ?",
    [id],
    (err) => {
      if (err) {
        console.log("MYSQL ERROR:", err);
      
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      res.json({
        success: true,
        message: "Allocation Deleted Successfully",
      });
    }
  );
};