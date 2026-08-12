const express = require("express");
const router = express.Router();

const {
  getStudents,
  addStudent,
  getStudentAttendance,
  getAttendancePercentage,
} = require("../controllers/studentController");

router.get("/", getStudents);

router.post("/add", addStudent);

router.get(
  "/attendance/:studentId",
  getStudentAttendance
);

router.get(
  "/percentage/:studentId",
  getAttendancePercentage
);

module.exports = router;