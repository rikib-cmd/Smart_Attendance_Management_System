const express = require("express");

const router = express.Router();

const {
  markAttendance,
  getAttendance,
  getStudentAttendance,
} = require(
  "../controllers/attendanceController"
);

router.post(
  "/mark",
  markAttendance
);

router.get(
  "/",
  getAttendance
);

router.get(
  "/student/:studentId",
  getStudentAttendance
);

module.exports = router;