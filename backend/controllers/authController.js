const db = require("../config/db");
const bcrypt = require("bcryptjs");

const login = (req, res) => {
  const { email, password } = req.body;

  const sql = "SELECT * FROM users WHERE email = ?";

  db.query(sql, [email], async (err, results) => {
    if (err) {
      return res.status(500).json({
        success: false,
        error: err.message,
      });
    }

    if (results.length === 0) {
      return res.status(401).json({
        success: false,
        message: "Invalid Email or Password",
      });
    }

    const user = results[0];

    let isMatch = false;

    // For old hashed users
    if (user.password.startsWith("$2b$")) {
      isMatch = await bcrypt.compare(
        password,
        user.password
      );
    }
    // For newly added users with plain password
    else {
      isMatch = password === user.password;
    }

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Invalid Email or Password",
      });
    }

    res.json({
      success: true,
      user: {
        user_id: user.user_id,
        name: user.name,
        email: user.email,
        role: user.role,
        teacher_id: user.teacher_id,
        student_id: user.student_id,
      },
    });
  });
};

module.exports = { login };