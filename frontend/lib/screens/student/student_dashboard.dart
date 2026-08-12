import 'package:flutter/material.dart';
import 'attendance_history_screen.dart';
import 'attendance_percentage_screen.dart';

class StudentDashboard extends StatelessWidget {
  final int studentId;
  final String studentName;

  const StudentDashboard({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  Widget dashboardCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(18),
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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(.12),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(icon, color: color, size: 30),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF081F5C),
        foregroundColor: Colors.white,
        title: const Text(
          "Student Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF081F5C), Color(0xFF0F4CFF)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 42,
                      color: Color(0xFF081F5C),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Text(
                    studentName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "Student",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            dashboardCard(
              context: context,
              title: "My Attendance",
              subtitle: "View attendance history records",
              icon: Icons.history,
              color: Colors.blue,
              screen: AttendanceHistoryScreen(studentId: studentId),
            ),

            dashboardCard(
              context: context,
              title: "Attendance Percentage",
              subtitle: "Check overall attendance percentage",
              icon: Icons.pie_chart,
              color: Colors.green,
              screen: AttendancePercentageScreen(studentId: studentId),
            ),
          ],
        ),
      ),
    );
  }
}
