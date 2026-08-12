import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentReportScreen extends StatefulWidget {
  const StudentReportScreen({super.key});

  @override
  State<StudentReportScreen> createState() => _StudentReportScreenState();
}

class _StudentReportScreenState extends State<StudentReportScreen> {
  List reports = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5001/api/reports/students"),
      );

      final data = jsonDecode(response.body);

      setState(() {
        reports = data["reports"] ?? [];
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Widget reportCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
        contentPadding: const EdgeInsets.all(16),

        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Colors.blue.withOpacity(.12),
          child: const Icon(Icons.person, color: Colors.blue),
        ),

        title: Text(
          item["student_name"].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            "Roll No: ${item["roll_no"]}\n"
            "Classes: ${item["total_classes"]}\n"
            "Present: ${item["present_count"]}\n"
            "Attendance: ${item["attendance_percentage"]}%",
          ),
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.12),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "${item["attendance_percentage"]}%",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
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
          "Student Wise Report",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : reports.isEmpty
          ? const Center(child: Text("No Reports Found"))
          : SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.people, color: Colors.white, size: 40),

                        const SizedBox(height: 10),

                        const Text(
                          "Student Reports",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${reports.length} Students Available",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      return reportCard(reports[index]);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
