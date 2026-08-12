import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final rollController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();
  final semesterController = TextEditingController();

  List students = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadStudents();
  }

  Future<void> loadStudents() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5001/api/students"),
      );

      final data = jsonDecode(response.body);

      setState(() {
        students = data["students"] ?? [];
        loading = false;
      });

      print(data);
    } catch (e) {
      print("Load Students Error: $e");

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> addStudent() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5001/api/students/add"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "roll_no": rollController.text,
          "student_name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "department_id":
              int.parse(departmentController.text),
          "semester_id":
              int.parse(semesterController.text),
        }),
      );

      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data["message"] ?? "Student Added Successfully",
          ),
        ),
      );

      rollController.clear();
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      departmentController.clear();
      semesterController.clear();

      loadStudents();
    } catch (e) {
      print("Add Student Error: $e");
    }
  }

  @override
  void dispose() {
    rollController.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    super.dispose();
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
        "Students",
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    ),

    body: SingleChildScrollView(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Student Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage student records and enrollment",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  TextField(
                    controller: rollController,
                    decoration: InputDecoration(
                      labelText: "Roll No",
                      prefixIcon: const Icon(Icons.badge),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Student Name",
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: "Phone",
                      prefixIcon: const Icon(Icons.phone),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: departmentController,
                    decoration: InputDecoration(
                      labelText: "Department ID",
                      prefixIcon: const Icon(Icons.account_balance),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: semesterController,
                    decoration: InputDecoration(
                      labelText: "Semester ID",
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addStudent,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Student"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF081F5C),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 25),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Student Records",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF081F5C),
              ),
            ),
          ),

          const SizedBox(height: 15),

          loading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : students.isEmpty
                  ? const Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("No Students Found"),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student =
                            students[index];

                        return Card(
                          margin:
                              const EdgeInsets.only(
                                  bottom: 12),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                                    18),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color(
                                      0xFF081F5C),
                              child: Text(
                                "${index + 1}",
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                ),
                              ),
                            ),
                            title: Text(
                              student[
                                      "student_name"]
                                  .toString(),
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "${student["roll_no"]}\n"
                              "${student["email"]}\n"
                              "${student["department_name"]}\n"
                              "Semester ${student["semester_no"]}",
                            ),
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