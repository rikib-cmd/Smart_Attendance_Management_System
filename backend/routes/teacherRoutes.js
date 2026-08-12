const express = require("express");
const router = express.Router();

const {
  getTeachers,
  addTeacher,
  getTeacherClasses,
  getStudentsByAllocation,
} = require("../controllers/teacherController");

router.get("/", getTeachers);

router.post("/add", addTeacher);

router.get(
  "/classes/:teacherId",
  getTeacherClasses
);

router.get(
  "/students/:allocationId",
  getStudentsByAllocation
);

module.exports = router;