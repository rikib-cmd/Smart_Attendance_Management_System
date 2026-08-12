import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'department_screen.dart';
import 'semester_screen.dart';
import 'subject_screen.dart';
import 'teacher_screen.dart';
import 'student_screen.dart';
import 'class_allocation_screen.dart';
import 'attendance_report_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int students = 0;
  int teachers = 0;
  int subjects = 0;
  int departments = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadStats();
  }

  Future<void> loadStats() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5001/api/dashboard/stats"),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        setState(() {
          students = data["stats"]["totalStudents"];
          teachers = data["stats"]["totalTeachers"];
          subjects = data["stats"]["totalSubjects"];
          departments = data["stats"]["totalDepartments"];
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget statCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 28),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget actionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [color, color.withOpacity(.8)],
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 34),
            ),

            const SizedBox(height: 16),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF081F5C),
              ),
            ),

            const SizedBox(height: 8),

            Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 250,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF081F5C), Color(0xFF0F4CFF)],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 50,
                      color: Color(0xFF081F5C),
                    ),
                  ),

                  SizedBox(height: 15),

                  Text(
                    "Administrator",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 6),

                  Text(
                    "Smart Attendance System",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),

                  SizedBox(height: 20),

                  Divider(color: Colors.white24, indent: 30, endIndent: 30),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.dashboard_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Dashboard",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.account_balance_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Departments",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DepartmentScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Semesters",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SemesterScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.menu_book_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Subjects",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubjectScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.school_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Teachers",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TeacherScreen()),
                );
              },
            ),

            ListTile(
              leading: const Icon(
                Icons.people_alt_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Students",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StudentScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.assignment_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Class Allocation",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ClassAllocationScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.analytics_rounded,
                color: Color(0xFF081F5C),
              ),
              title: const Text(
                "Attendance Reports",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AttendanceReportScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color(0xFF081F5C),
        foregroundColor: Colors.white,
        title: const Text(
          "Administrator",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF081F5C), Color(0xFF0F4CFF)],
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.admin_panel_settings,
                            color: Colors.white,
                            size: 35,
                          ),
                        ),

                        const SizedBox(width: 18),

                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome Back, Administrator",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 6),
                              Text(
                                "Manage departments, teachers, students and attendance records efficiently.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFFFFC107),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            "ADMIN",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    "System Statistics",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF081F5C),
                    ),
                  ),

                  const SizedBox(height: 15),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 2.6,
                    children: [
                      statCard(
                        title: "Students",
                        value: students.toString(),
                        icon: Icons.people,
                        color: Colors.blue,
                      ),

                      statCard(
                        title: "Teachers",
                        value: teachers.toString(),
                        icon: Icons.school,
                        color: Colors.green,
                      ),

                      statCard(
                        title: "Subjects",
                        value: subjects.toString(),
                        icon: Icons.book,
                        color: Colors.orange,
                      ),

                      statCard(
                        title: "Departments",
                        value: departments.toString(),
                        icon: Icons.account_balance,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "Quick Actions",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF081F5C),
                    ),
                  ),

                  const SizedBox(height: 15),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    crossAxisSpacing: 18,
                    mainAxisSpacing: 18,
                    childAspectRatio: 1.1,
                    children: [
                      actionCard(
                        "Departments",
                        Icons.account_balance,
                        Colors.blue,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const DepartmentScreen(),
                            ),
                          );
                        },
                      ),

                      actionCard(
                        "Semesters",
                        Icons.calendar_month,
                        Colors.green,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SemesterScreen(),
                            ),
                          );
                        },
                      ),

                      actionCard("Subjects", Icons.book, Colors.orange, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SubjectScreen(),
                          ),
                        );
                      }),

                      actionCard(
                        "Teachers",
                        Icons.school,
                        Colors.deepPurple,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const TeacherScreen(),
                            ),
                          );
                        },
                      ),

                      actionCard("Students", Icons.people, Colors.cyan, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentScreen(),
                          ),
                        );
                      }),

                      actionCard(
                        "Class Allocation",
                        Icons.assignment,
                        Colors.pink,
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ClassAllocationScreen(),
                            ),
                          );
                        },
                      ),

                      actionCard("Reports", Icons.analytics, Colors.amber, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AttendanceReportScreen(),
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
