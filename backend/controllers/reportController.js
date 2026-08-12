const db = require("../config/db");

exports.getStudentReport = (req, res) => {
  const sql = `
    SELECT
      s.student_name,
      s.roll_no,
      COUNT(a.attendance_id) AS total_classes,
      SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) AS present_count,
      ROUND(
        (SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END)
        / COUNT(a.attendance_id))*100,2
      ) AS attendance_percentage
    FROM attendance a
    JOIN students s
      ON a.student_id = s.student_id
    GROUP BY s.student_id
  `;

  db.query(sql, (err, results) => {
    if (err)
      return res.status(500).json({
        success: false,
        message: err.message,
      });

    res.json({
      success: true,
      reports: results,
    });
  });
};

exports.getSubjectReport = (req, res) => {
  const sql = `
    SELECT
      sub.subject_name,
      COUNT(a.attendance_id) total_records,
      SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) present_count
    FROM attendance a
    JOIN class_allocations ca
      ON a.allocation_id = ca.allocation_id
    JOIN subjects sub
      ON ca.subject_id = sub.subject_id
    GROUP BY sub.subject_id
  `;

  db.query(sql, (err, results) => {
    if (err)
      return res.status(500).json({
        success: false,
        message: err.message,
      });

    res.json({
      success: true,
      reports: results,
    });
  });
};

exports.getTeacherReport = (req, res) => {
  const sql = `
    SELECT
      t.name,
      COUNT(a.attendance_id) total_records,
      SUM(CASE WHEN a.status='Present' THEN 1 ELSE 0 END) present_count
    FROM attendance a
    JOIN teachers t
      ON a.marked_by_teacher_id = t.teacher_id
    GROUP BY t.teacher_id
  `;

  db.query(sql, (err, results) => {
    if (err)
      return res.status(500).json({
        success: false,
        message: err.message,
      });

    res.json({
      success: true,
      reports: results,
    });
  });
};

exports.getAttendanceReport = (req, res) => {
  const sql = `
    SELECT
      a.attendance_id,
      s.student_name,
      a.attendance_date,
      a.status
    FROM attendance a
    JOIN students s
      ON a.student_id = s.student_id
    ORDER BY a.attendance_date DESC
  `;

  db.query(sql, (err, results) => {
    if (err)
      return res.status(500).json({
        success: false,
        message: err.message,
      });

    res.json({
      success: true,
      reports: results,
    });
  });
};