import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MarkAttendanceScreen extends StatefulWidget {
  final int allocationId;
  final int teacherId;
  final String subjectName;

  const MarkAttendanceScreen({
    super.key,
    required this.allocationId,
    required this.teacherId,
    required this.subjectName,
  });

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  List students = [];
  bool loading = true;

  Map<int, bool> attendanceMap = {};

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:5001/api/teachers/students/${widget.allocationId}",
        ),
      );

      final data = jsonDecode(response.body);

      setState(() {
        students = data["students"] ?? [];

        for (var student in students) {
          attendanceMap[student["student_id"]] = true;
        }

        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> saveAttendance() async {
    try {
      bool allSaved = true;
      String message = "Attendance Saved";

      for (var student in students) {
        final response = await http.post(
          Uri.parse("http://localhost:5001/api/attendance/mark"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "student_id": student["student_id"],
            "allocation_id": widget.allocationId,
            "teacher_id": widget.teacherId,
            "status": attendanceMap[student["student_id"]] == true
                ? "Present"
                : "Absent",
          }),
        );

        final data = jsonDecode(response.body);

        if (data["success"] != true) {
          allSaved = false;
          message = data["message"] ?? "Failed to save attendance";
        }
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));

      if (allSaved) {
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Widget studentTile(dynamic student) {
    final int id = student["student_id"];
    final bool isPresent = attendanceMap[id] ?? true;

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
      child: CheckboxListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        value: isPresent,
        activeColor: Colors.green,

        secondary: CircleAvatar(
          backgroundColor: isPresent
              ? Colors.green.withOpacity(.15)
              : Colors.red.withOpacity(.15),
          child: Icon(
            isPresent ? Icons.check_circle : Icons.cancel,
            color: isPresent ? Colors.green : Colors.red,
          ),
        ),

        title: Text(
          student["student_name"].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),

        subtitle: Text("Roll No: ${student["roll_no"]}"),

        onChanged: (value) {
          setState(() {
            attendanceMap[id] = value ?? false;
          });
        },
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
        title: Text(
          widget.subjectName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : students.isEmpty
          ? const Center(
              child: Text(
                "No Students Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(15),
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
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
                        Icons.fact_check,
                        color: Colors.white,
                        size: 38,
                      ),

                      const SizedBox(height: 10),

                      Text(
                        widget.subjectName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "${students.length} Students",
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      return studentTile(students[index]);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: saveAttendance,
                      icon: const Icon(Icons.save),
                      label: const Text("SAVE ATTENDANCE"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF081F5C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
