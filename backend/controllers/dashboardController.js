const db = require("../config/db");

const getDashboardStats = (req, res) => {
  const stats = {};

  db.query(
    "SELECT COUNT(*) AS totalStudents FROM students",
    (err, studentsResult) => {
      if (err) return res.status(500).json(err);

      stats.totalStudents =
          studentsResult[0].totalStudents;

      db.query(
        "SELECT COUNT(*) AS totalTeachers FROM teachers",
        (err, teachersResult) => {
          if (err) return res.status(500).json(err);

          stats.totalTeachers =
              teachersResult[0].totalTeachers;

          db.query(
            "SELECT COUNT(*) AS totalSubjects FROM subjects",
            (err, subjectsResult) => {
              if (err) return res.status(500).json(err);

              stats.totalSubjects =
                  subjectsResult[0].totalSubjects;

              db.query(
                "SELECT COUNT(*) AS totalDepartments FROM departments",
                (err, departmentsResult) => {
                  if (err) return res.status(500).json(err);

                  stats.totalDepartments =
                      departmentsResult[0].totalDepartments;

                  res.json({
                    success: true,
                    stats,
                  });
                },
              );
            },
          );
        },
      );
    },
  );
};

module.exports = {
  getDashboardStats,
};