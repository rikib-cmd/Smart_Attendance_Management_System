const express = require("express");
const router = express.Router();

const {
  getDepartments,
  addDepartment,
} = require("../controllers/departmentController");

router.get("/", getDepartments);
router.post("/add", addDepartment);

module.exports = router;