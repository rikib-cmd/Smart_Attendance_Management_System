import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'mark_attendance_screen.dart';

class MyClassesScreen extends StatefulWidget {
  final int teacherId;

  const MyClassesScreen({super.key, required this.teacherId});

  @override
  State<MyClassesScreen> createState() => _MyClassesScreenState();
}

class _MyClassesScreenState extends State<MyClassesScreen> {
  List classes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadClasses();
  }

  Future<void> loadClasses() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:5001/api/teachers/classes/${widget.teacherId}",
        ),
      );

      final data = jsonDecode(response.body);

      setState(() {
        classes = data["classes"] ?? [];
        loading = false;
      });
    } catch (e) {
      print(e);

      setState(() {
        loading = false;
      });
    }
  }

  Widget classCard(dynamic item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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

        leading: Container(
          width: 55,
          height: 55,
          decoration: BoxDecoration(
            color: const Color(0xFF081F5C).withOpacity(.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.class_, color: Color(0xFF081F5C)),
        ),

        title: Text(
          item["subject_name"].toString(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),

        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Text(
            "${item["department_name"]} • Semester ${item["semester_no"]}",
          ),
        ),

        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MarkAttendanceScreen(
                allocationId: item["allocation_id"],
                teacherId: widget.teacherId,
                subjectName: item["subject_name"],
              ),
            ),
          );
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
        title: const Text(
          "My Classes",
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.class_, color: Colors.white, size: 40),

                        const SizedBox(height: 12),

                        const Text(
                          "Assigned Classes",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          "${classes.length} Classes Assigned",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  if (classes.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(child: Text("No Classes Assigned")),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: classes.length,
                      itemBuilder: (context, index) {
                        return classCard(classes[index]);
                      },
                    ),
                ],
              ),
            ),
    );
  }
}
