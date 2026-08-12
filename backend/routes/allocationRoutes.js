const express = require("express");
const router = express.Router();

const {
  getAllocations,
  addAllocation,
  deleteAllocation,
} = require("../controllers/allocationController");

router.get("/", getAllocations);

router.post("/add", addAllocation);

router.delete("/:id", deleteAllocation);

module.exports = router;