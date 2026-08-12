const db = require("../config/db");

// Get All Departments
const getDepartments = (req, res) => {
  const sql = "SELECT * FROM departments ORDER BY department_id DESC";

  db.query(sql, (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    res.json({
      success: true,
      departments: results,
    });
  });
};

// Add Department
const addDepartment = (req, res) => {
  const { department_name } = req.body;

  const sql =
    "INSERT INTO departments (department_name) VALUES (?)";

  db.query(sql, [department_name], (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    res.json({
      success: true,
      message: "Department Added Successfully",
    });
  });
};

module.exports = {
  getDepartments,
  addDepartment,
};