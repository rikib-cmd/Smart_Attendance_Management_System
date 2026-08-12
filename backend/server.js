require("dotenv").config();

const express = require("express");
const cors = require("cors");
const db = require("./config/db");
const authRoutes = require("./routes/authRoutes");
const dashboardRoutes = require("./routes/dashboardRoutes");
const app = express();
const departmentRoutes = require("./routes/departmentRoutes");
const semesterRoutes = require("./routes/semesterRoutes");
const subjectRoutes = require("./routes/subjectRoutes");
const teacherRoutes = require("./routes/teacherRoutes");
const studentRoutes = require("./routes/studentRoutes");
const allocationRoutes = require("./routes/allocationRoutes");
const reportRoutes = require("./routes/reportRoutes");
const attendanceRoutes = require("./routes/attendanceRoutes");
// Middleware
app.use(cors());
app.use(express.json());

// Auth Routes
app.use("/api/auth", authRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/departments", departmentRoutes);
app.use("/api/semesters", semesterRoutes);
app.use("/api/subjects", subjectRoutes);
app.use("/api/teachers", teacherRoutes);
app.use("/api/students", studentRoutes);
app.use("/api/allocations", allocationRoutes);
app.use("/api/reports", reportRoutes);
app.use("/api/attendance", attendanceRoutes);
// Home Route
app.get("/", (req, res) => {
  res.send("Smart Attendance API Running");
});

// Database Test Route
app.get("/test-db", (req, res) => {
  db.query("SELECT 1", (err, result) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    res.json({
      success: true,
      message: "Database Connected",
    });
  });
});

// Start Server
const PORT = process.env.PORT || 5001;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
});