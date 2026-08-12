const express = require("express");
const router = express.Router();

const {
  getSubjects,
  addSubject,
} = require("../controllers/subjectController");

router.get("/", getSubjects);
router.post("/add", addSubject);

module.exports = router;