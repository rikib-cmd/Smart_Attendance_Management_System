const db = require("../config/db");

exports.getTeachers = (req, res) => {
  const sql = `
    SELECT
      t.teacher_id,
      t.teacher_code,
      t.name,
      t.email,
      t.phone,
      d.department_name
    FROM teachers t
    JOIN departments d
      ON t.department_id = d.department_id
    ORDER BY t.teacher_id DESC
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
      teachers: results,
    });
  });
};

exports.addTeacher = (req, res) => {
  const {
    teacher_code,
    name,
    email,
    phone,
    department_id,
  } = req.body;

  const sql = `
    INSERT INTO teachers
    (
      teacher_code,
      name,
      email,
      password,
      phone,
      department_id
    )
    VALUES (?, ?, ?, ?, ?, ?)
  `;

  db.query(
    sql,
    [
      teacher_code,
      name,
      email,
      "123456",
      phone,
      department_id,
    ],
    (err, result) => {
      if (err) {
        return res.status(500).json({
          success: false,
          message: err.message,
        });
      }

      const teacherId = result.insertId;

      const userSql = `
        INSERT INTO users
        (
          name,
          email,
          password,
          role,
          teacher_id
        )
        VALUES (?, ?, ?, 'Teacher', ?)
      `;

      db.query(
        userSql,
        [
          name,
          email,
          "123456",
          teacherId,
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
            message: "Teacher Added Successfully",
          });
        }
      );
    }
  );
};

exports.getTeacherClasses = (req, res) => {
  const { teacherId } = req.params;

  const sql = `
    SELECT
      ca.allocation_id,
      d.department_name,
      sem.semester_id,
      s.subject_name
    FROM class_allocations ca
    JOIN departments d
      ON ca.department_id = d.department_id
    JOIN semesters sem
      ON ca.semester_id = sem.semester_id
    JOIN subjects s
      ON ca.subject_id = s.subject_id
    WHERE ca.teacher_id = ?
    ORDER BY ca.allocation_id DESC
  `;

  db.query(sql, [teacherId], (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        message: err.message,
      });
    }

    res.json({
      success: true,
      classes: results,
    });
  });
};

exports.getStudentsByAllocation = (req, res) => {
  const { allocationId } = req.params;

  const sql = `
    SELECT
      st.student_id,
      st.roll_no,
      st.student_name
    FROM class_allocations ca
    JOIN students st
      ON st.department_id = ca.department_id
      AND st.semester_id = ca.semester_id
    WHERE ca.allocation_id = ?
    ORDER BY st.student_name
  `;

  db.query(sql, [allocationId], (err, results) => {
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