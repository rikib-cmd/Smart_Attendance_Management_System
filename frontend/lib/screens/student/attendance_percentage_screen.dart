import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AttendancePercentageScreen extends StatefulWidget {
  final int studentId;

  const AttendancePercentageScreen({super.key, required this.studentId});

  @override
  State<AttendancePercentageScreen> createState() =>
      _AttendancePercentageScreenState();
}

class _AttendancePercentageScreenState
    extends State<AttendancePercentageScreen> {
  double percentage = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadPercentage();
  }

  Future<void> loadPercentage() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:5001/api/students/percentage/${widget.studentId}",
        ),
      );

      final data = jsonDecode(response.body);

      setState(() {
        percentage = double.tryParse(data["percentage"].toString()) ?? 0;
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Color getStatusColor() {
    if (percentage >= 75) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.orange;
    }
    return Colors.red;
  }

  String getStatusText() {
    if (percentage >= 75) {
      return "Excellent Attendance";
    } else if (percentage >= 50) {
      return "Average Attendance";
    }
    return "Low Attendance";
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
          "Attendance Percentage",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
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
                      children: [
                        const Icon(
                          Icons.pie_chart,
                          size: 50,
                          color: Colors.white,
                        ),

                        const SizedBox(height: 12),

                        const Text(
                          "Attendance Overview",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        const Text(
                          "Your current attendance percentage",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
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
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: getStatusColor().withOpacity(.15),
                          child: Icon(
                            Icons.analytics_rounded,
                            size: 45,
                            color: getStatusColor(),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 46,
                            fontWeight: FontWeight.bold,
                            color: getStatusColor(),
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          getStatusText(),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: getStatusColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
