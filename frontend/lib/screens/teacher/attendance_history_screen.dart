import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendanceHistoryScreen extends StatefulWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  List attendance = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAttendance();
  }

  Future<void> loadAttendance() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:5001/api/attendance?t=${DateTime.now().millisecondsSinceEpoch}",
        ),
      );

      final data = jsonDecode(response.body);

      setState(() {
        attendance = data["attendance"] ?? [];
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Widget attendanceCard(dynamic item) {
    final bool isPresent = item["status"] == "Present";

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
          radius: 24,
          backgroundColor: isPresent
              ? Colors.green.withOpacity(.15)
              : Colors.red.withOpacity(.15),
          child: Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : Colors.red,
          ),
        ),

        title: Text(
          item["student_name"] ?? "Unknown Student",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "Roll No: ${item["roll_no"]}\n"
            "Date: ${item["attendance_date"]}",
          ),
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isPresent
                ? Colors.green.withOpacity(.12)
                : Colors.red.withOpacity(.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            item["status"],
            style: TextStyle(
              color: isPresent ? Colors.green : Colors.red,
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
          "Attendance History",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : attendance.isEmpty
          ? const Center(child: Text("No Attendance Found"))
          : RefreshIndicator(
              onRefresh: loadAttendance,
              child: ListView(
                padding: const EdgeInsets.all(20),
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
                        const Icon(
                          Icons.history,
                          color: Colors.white,
                          size: 40,
                        ),

                        const SizedBox(height: 10),

                        const Text(
                          "Attendance History",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${attendance.length} Records Found",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  ...attendance.map((item) => attendanceCard(item)),
                ],
              ),
            ),
    );
  }
}
