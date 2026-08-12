import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SemesterScreen extends StatefulWidget {
  const SemesterScreen({super.key});

  @override
  State<SemesterScreen> createState() => _SemesterScreenState();
}

class _SemesterScreenState extends State<SemesterScreen> {
  final TextEditingController semesterController =
      TextEditingController();

  List departments = [];
  List semesters = [];

  int? selectedDepartmentId;

  final String semesterUrl =
      "http://localhost:5001/api/semesters";

  final String departmentUrl =
      "http://localhost:5001/api/departments";

  @override
  void initState() {
    super.initState();
    fetchDepartments();
    fetchSemesters();
  }

  Future<void> fetchDepartments() async {
    final response =
        await http.get(Uri.parse(departmentUrl));

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      setState(() {
        departments = data["departments"];
      });
    }
  }

  Future<void> fetchSemesters() async {
    final response =
        await http.get(Uri.parse(semesterUrl));

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      setState(() {
        semesters = data["semesters"];
      });
    }
  }

  Future<void> addSemester() async {
    if (semesterController.text.isEmpty ||
        selectedDepartmentId == null) {
      return;
    }

    final response = await http.post(
      Uri.parse("$semesterUrl/add"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "semester_no":
            int.parse(semesterController.text),
        "department_id":
            selectedDepartmentId,
      }),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      semesterController.clear();

      fetchSemesters();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Semester Added Successfully",
          ),
        ),
      );
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
          "Semesters",
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
                    "Semester Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Manage department semesters",
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [

                  DropdownButtonFormField<int>(
                    initialValue: selectedDepartmentId,
                    decoration: InputDecoration(
                      labelText: "Department",
                      prefixIcon: const Icon(
                        Icons.account_balance,
                      ),
                      filled: true,
                      fillColor:
                          const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                    items: departments.map((dept) {
                      return DropdownMenuItem<int>(
                        value:
                            dept["department_id"],
                        child: Text(
                          dept["department_name"],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedDepartmentId =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                        semesterController,
                    keyboardType:
                        TextInputType.number,
                    decoration: InputDecoration(
                      labelText:
                          "Semester Number",
                      prefixIcon: const Icon(
                        Icons.calendar_month,
                      ),
                      filled: true,
                      fillColor:
                          const Color(0xFFF8FAFC),
                      border: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                14),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addSemester,
                      icon:
                          const Icon(Icons.add),
                      label: const Text(
                        "Add Semester",
                      ),
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(
                                0xFF081F5C),
                        foregroundColor:
                            Colors.white,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: semesters.isEmpty
                  ? const Center(
                      child: Text(
                        "No Semesters Found",
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          semesters.length,
                      itemBuilder:
                          (context, index) {
                        final semester =
                            semesters[index];

                        return Container(
                          margin:
                              const EdgeInsets.only(
                            bottom: 12,
                          ),
                          decoration:
                              BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius
                                    .circular(
                                        18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors
                                    .black
                                    .withOpacity(
                                        .04),
                                blurRadius: 8,
                                offset:
                                    const Offset(
                                        0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading:
                                CircleAvatar(
                              backgroundColor:
                                  const Color(
                                      0xFF081F5C),
                              child: Text(
                                semester[
                                        "semester_no"]
                                    .toString(),
                                style:
                                    const TextStyle(
                                  color:
                                      Colors.white,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                            title: Text(
                              "Semester ${semester["semester_no"]}",
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                            subtitle: Text(
                              semester[
                                  "department_name"],
                            ),
                            trailing:
                                const Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              size: 18,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}