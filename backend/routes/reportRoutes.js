const express = require("express");
const router = express.Router();

const {
  getAttendanceReport,
  getStudentReport,
  getSubjectReport,
  getTeacherReport,
} = require("../controllers/reportController");

router.get("/", getAttendanceReport);

router.get("/students", getStudentReport);

router.get("/subjects", getSubjectReport);

router.get("/teachers", getTeacherReport);

module.exports = router;