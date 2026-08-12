import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../admin/admin_dashboard.dart';
import '../teacher/teacher_dashboard.dart';
import '../student/student_dashboard.dart';

class LoginScreen extends StatefulWidget {
  final String role;

  const LoginScreen({
    super.key,
    required this.role,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController();

  final TextEditingController passwordController =
      TextEditingController();

  bool obscurePassword = true;
  bool isLoading = false;

  Future<void> login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await ApiService.login(
        email,
        password,
      );

      if (response["success"] == true) {
        final user = response["user"];

        if (user["role"] == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => const AdminDashboard(),
            ),
          );
        } else if (user["role"] == "Teacher") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => TeacherDashboard(
                teacherId: user["teacher_id"],
                teacherName: user["name"],
              ),
            ),
          );
        } else if (user["role"] == "Student") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => StudentDashboard(
                studentId: user["student_id"],
                studentName: user["name"],
              ),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response["message"] ?? "Login Failed",
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }

    setState(() {
      isLoading = false;
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF081F5C),
            Color(0xFF0F4CFF),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            width: 1300,
            margin: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Row(
              children: [

                // LEFT PANEL
               Expanded(
  flex: 6,
  child: Container(
    height: 720,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35),
        bottomLeft: Radius.circular(35),
      ),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF081F5C),
          Color(0xFF0F4CFF),
        ],
      ),
    ),
    child: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
                border: Border.all(
                  color: Colors.white24,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.school_rounded,
                color: Colors.white,
                size: 110,
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "SMART ATTENDANCE",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 44,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "MANAGEMENT SYSTEM",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFFFC107),
                fontSize: 44,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Text(
                "Secure • Fast • Reliable",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 20),

            const SizedBox(
              width: 450,
              child: Text(
                "Academic Attendance & Management Platform",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  ),
),
                // RIGHT PANEL
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(60),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color:
                                const Color(0xFFFFC107),
                            borderRadius:
                                BorderRadius.circular(25),
                          ),
                          child: Text(
                            widget.role.toUpperCase(),
                            style: const TextStyle(
                              fontWeight:
                                  FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "${widget.role} Portal",
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight:
                                FontWeight.bold,
                            color: Color(0xFF081F5C),
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Sign in to continue",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 35),

                        TextField(
                          controller: emailController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                const Color(0xFFF8FAFC),
                            labelText:
                                "Email Address",
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                            ),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller:
                              passwordController,
                          obscureText:
                              obscurePassword,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor:
                                const Color(0xFFF8FAFC),
                            labelText: "Password",
                            prefixIcon: const Icon(
                              Icons.lock_outline,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                obscurePassword
                                    ? Icons.visibility
                                    : Icons
                                        .visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  obscurePassword =
                                      !obscurePassword;
                                });
                              },
                            ),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                      18),
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed:
                                isLoading ? null : login,
                            icon: const Icon(
                              Icons.arrow_forward,
                            ),
                            label: isLoading
                                ? const Text("Loading...")
                                : const Text(
                                    "ACCESS PORTAL",
                                    style: TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFFFFC107),
                              foregroundColor:
                                  Colors.black,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}


}