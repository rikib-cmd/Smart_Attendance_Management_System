const db = require("../config/db");

exports.getStudents = (req, res) => {
  const sql = `
    SELECT
      s.student_id,
      s.roll_no,
      s.student_name,
      s.email,
      s.phone,
      d.department_name,
      sem.semester_no
    FROM students s
    JOIN departments d
      ON s.department_id = d.department_id
    JOIN semesters sem
      ON s.semester_id = sem.semester_id
    ORDER BY s.student_id DESC
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
      students: results,
    });
  });
};

exports.addStudent = (req, res) => {
  const {
    roll_no,
    student_name,
    email,
    phone,
    department_id,
    semester_id,
  } = req.body;

  const sql = `
    INSERT INTO students
    (
      roll_no,
      student_name,
      email,
      password,
      phone,
      department_id,
      semester_id
    )
    VALUES (?, ?, ?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [
      roll_no,
      student_name,
      email,
      "123456",
      phone,
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

      const studentId = result.insertId;

      const userSql = `
        INSERT INTO users
        (
          name,
          email,
          password,
          role,
          student_id
        )
        VALUES (?, ?, ?, 'Student', ?)
      `;

      db.query(
        userSql,
        [
          student_name,
          email,
          "123456",
          studentId,
        ],
        (err2) => {
          if (err2) {
            return res.status(500).json({
              success: false,
              message: err2.message,
            });
          }

          res.json({
            success: true,
            message: "Student Added Successfully",
          });
        }
      );
    }
  );
};
exports.getStudentAttendance = (req, res) => {
  const { studentId } = req.params;

  const sql = `
    SELECT
      a.attendance_id,
      a.attendance_date,
      a.status,
      s.subject_name
    FROM attendance a
    JOIN class_allocations ca
      ON a.allocation_id = ca.allocation_id
    JOIN subjects s
      ON ca.subject_id = s.subject_id
    WHERE a.student_id = ?
    ORDER BY a.attendance_id DESC
  `;

  db.query(sql, [studentId], (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    res.json({
      success: true,
      attendance: results,
    });
  });
};

exports.getAttendancePercentage = (req, res) => {
  const { studentId } = req.params;

  const sql = `
    SELECT
      ROUND(
        (
          SUM(
            CASE
              WHEN status='Present'
              THEN 1
              ELSE 0
            END
          )
          /
          COUNT(*)
        ) * 100,
        2
      ) AS percentage
    FROM attendance
    WHERE student_id = ?
  `;

  db.query(sql, [studentId], (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    res.json({
      success: true,
      percentage:
        results[0]?.percentage ?? 0,
    });
  });
};