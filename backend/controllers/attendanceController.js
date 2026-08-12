const db = require("../config/db");

exports.markAttendance = (req, res) => {
  const {
    student_id,
    allocation_id,
    status,
    teacher_id,
  } = req.body;

  const checkSql = `
    SELECT *
    FROM attendance
    WHERE student_id = ?
    AND allocation_id = ?
    AND attendance_date = CURDATE()
  `;

  db.query(
    checkSql,
    [student_id, allocation_id],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      if (result.length > 0) {
        return res.json({
          success: false,
          message:
            "Attendance already taken today",
        });
      }

      const insertSql = `
        INSERT INTO attendance
        (
          student_id,
          allocation_id,
          attendance_date,
          status,
          marked_by_teacher_id
        )
        VALUES (?, ?, CURDATE(), ?, ?)
      `;

      db.query(
        insertSql,
        [
          student_id,
          allocation_id,
          status,
          teacher_id,
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
            message: "Attendance Saved",
          });
        }
      );
    }
  );
};

exports.getAttendance = (req, res) => {
  const sql = `
    SELECT
      a.attendance_id,
      a.student_id,
      a.allocation_id,
      a.attendance_date,
      a.status,
      a.marked_by_teacher_id,
      st.student_name,
      st.roll_no
    FROM attendance a
    JOIN students st
      ON a.student_id = st.student_id
    ORDER BY a.attendance_date DESC
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
      attendance: results,
    });
  });
};

exports.getStudentAttendance = (
  req,
  res
) => {
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

    ORDER BY a.attendance_date DESC
  `;

  db.query(
    sql,
    [studentId],
    (err, results) => {
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
    }
  );
};