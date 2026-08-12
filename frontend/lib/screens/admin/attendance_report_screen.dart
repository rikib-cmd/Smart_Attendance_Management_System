import 'package:flutter/material.dart';

import 'daily_attendance_screen.dart';
import 'student_report_screen.dart';
import 'subject_report_screen.dart';
import 'teacher_report_screen.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  Widget reportCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 10,
        ),
        leading: CircleAvatar(
          radius: 24,
          backgroundColor:
              const Color(0xFF081F5C).withOpacity(.1),
          child: Icon(
            icon,
            color: const Color(0xFF081F5C),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 18,
        ),
        onTap: onTap,
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
          "Attendance Reports",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF081F5C),
                    Color(0xFF0F4CFF),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    "Attendance Analytics",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Generate and view attendance reports",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            reportCard(
              title: "Student Wise Report",
              subtitle:
                  "View attendance by student",
              icon: Icons.people,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const StudentReportScreen(),
                  ),
                );
              },
            ),

            reportCard(
              title: "Subject Wise Report",
              subtitle:
                  "View attendance by subject",
              icon: Icons.book,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const SubjectReportScreen(),
                  ),
                );
              },
            ),

            reportCard(
              title: "Teacher Wise Report",
              subtitle:
                  "View attendance by teacher",
              icon: Icons.school,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const TeacherReportScreen(),
                  ),
                );
              },
            ),

            reportCard(
              title: "Daily Attendance",
              subtitle:
                  "View attendance by date",
              icon: Icons.calendar_month,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        const DailyAttendanceScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}