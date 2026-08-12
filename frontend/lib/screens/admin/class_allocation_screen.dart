import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ClassAllocationScreen extends StatefulWidget {
  const ClassAllocationScreen({super.key});

  @override
  State<ClassAllocationScreen> createState() =>
      _ClassAllocationScreenState();
}

class _ClassAllocationScreenState
    extends State<ClassAllocationScreen> {
  final teacherController = TextEditingController();
  final subjectController = TextEditingController();
  final departmentController = TextEditingController();
  final semesterController = TextEditingController();

  List allocations = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadAllocations();
  }

  Future<void> loadAllocations() async {
    try {
      final response = await http.get(
        Uri.parse(
          "http://localhost:5001/api/allocations",
        ),
      );

      print(response.body);

      final data = jsonDecode(response.body);

      setState(() {
        allocations = data["allocations"] ?? [];
        loading = false;
      });
    } catch (e) {
      print("Load Allocation Error: $e");

      setState(() {
        loading = false;
      });
    }
  }

  Future<void> addAllocation() async {
    try {
      final response = await http.post(
        Uri.parse(
          "http://localhost:5001/api/allocations/add",
        ),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "teacher_id":
              int.parse(teacherController.text),
          "subject_id":
              int.parse(subjectController.text),
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
            data["message"] ??
                "Allocation Added Successfully",
          ),
        ),
      );

      teacherController.clear();
      subjectController.clear();
      departmentController.clear();
      semesterController.clear();

      loadAllocations();
    } catch (e) {
      print("Add Allocation Error: $e");
    }
  }

  Widget allocationCard(dynamic item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.assignment),
        ),
        title: Text(
          item["subject_name"].toString(),
        ),
        subtitle: Text(
          "${item["teacher_name"]}\n"
          "${item["department_name"]} - Semester ${item["semester_no"]}",
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
        "Class Allocation",
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
                  "Class Allocation",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Assign teachers to subjects and semesters",
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
                    controller: teacherController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Teacher ID",
                      prefixIcon:
                          const Icon(Icons.school),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: subjectController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Subject ID",
                      prefixIcon:
                          const Icon(Icons.book),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: departmentController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Department ID",
                      prefixIcon: const Icon(
                          Icons.account_balance),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: semesterController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Semester ID",
                      prefixIcon: const Icon(
                          Icons.calendar_month),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addAllocation,
                      icon: const Icon(Icons.add),
                      label:
                          const Text("Add Allocation"),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF081F5C),
                        foregroundColor:
                            Colors.white,
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
              "Allocation Records",
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
                  child:
                      CircularProgressIndicator(),
                )
              : allocations.isEmpty
                  ? const Card(
                      child: Padding(
                        padding:
                            EdgeInsets.all(20),
                        child: Text(
                            "No Allocations Found"),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount:
                          allocations.length,
                      itemBuilder:
                          (context, index) {
                        final item =
                            allocations[index];

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
                              item["subject_name"]
                                  .toString(),
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              "${item["teacher_name"]}\n"
                              "${item["department_name"]} - Semester ${item["semester_no"]}",
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