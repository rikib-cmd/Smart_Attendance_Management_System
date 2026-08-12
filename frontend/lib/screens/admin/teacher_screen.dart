import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final departmentController = TextEditingController();

  List teachers = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadTeachers();
  }

  Future<void> loadTeachers() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5001/api/teachers"),
      );

      print(response.body);

      final data = jsonDecode(response.body);

      setState(() {
        teachers = data["teachers"] ?? [];
        loading = false;
      });
    } catch (e) {
      print("Teacher Error: $e");

      setState(() {
        loading = false;
        teachers = [];
      });
    }
  }

  Future<void> addTeacher() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:5001/api/teachers/add"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "teacher_code": codeController.text,
          "name": nameController.text,
          "email": emailController.text,
          "phone": phoneController.text,
          "department_id": int.parse(
            departmentController.text,
          ),
        }),
      );

      final data = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            data["message"] ?? "Teacher Added",
          ),
        ),
      );

      codeController.clear();
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      departmentController.clear();

      loadTeachers();
    } catch (e) {
      print("Add Teacher Error: $e");
    }
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
        "Teachers",
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
                  "Teacher Management",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Manage faculty information and records",
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
                    controller: codeController,
                    decoration: InputDecoration(
                      labelText: "Teacher Code",
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
                      labelText: "Teacher Name",
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
                      labelText: "Phone Number",
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

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addTeacher,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Teacher"),
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
              "Faculty Members",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF081F5C),
              ),
            ),
          ),

          const SizedBox(height: 15),

          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else if (teachers.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("No Teachers Found"),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics:
                  const NeverScrollableScrollPhysics(),
              itemCount: teachers.length,
              itemBuilder: (context, index) {
                final teacher = teachers[index];

                return Card(
                  margin:
                      const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          const Color(0xFF081F5C),
                      child: Text(
                        "${index + 1}",
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(
                      teacher["name"]?.toString() ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      "${teacher["teacher_code"] ?? ""}\n"
                      "${teacher["email"] ?? ""}\n"
                      "${teacher["department_name"] ?? ""}",
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