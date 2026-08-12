import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DepartmentScreen extends StatefulWidget {
  const DepartmentScreen({super.key});

  @override
  State<DepartmentScreen> createState() => _DepartmentScreenState();
}

class _DepartmentScreenState extends State<DepartmentScreen> {
  final TextEditingController departmentController =
      TextEditingController();

  List departments = [];

  final String baseUrl =
      "http://localhost:5001/api/departments";

  @override
  void initState() {
    super.initState();
    fetchDepartments();
  }

  Future<void> fetchDepartments() async {
    final response = await http.get(
      Uri.parse(baseUrl),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      setState(() {
        departments = data["departments"];
      });
    }
  }

  Future<void> addDepartment() async {
    if (departmentController.text.isEmpty) return;

    final response = await http.post(
      Uri.parse("$baseUrl/add"),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "department_name":
            departmentController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
      departmentController.clear();

      fetchDepartments();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Department Added Successfully",
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
          "Departments",
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
                    "Department Management",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Create and manage academic departments",
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

                  TextField(
                    controller: departmentController,
                    decoration: InputDecoration(
                      labelText:
                          "Department Name",
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
                  ),

                  const SizedBox(height: 15),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: addDepartment,
                      icon: const Icon(
                        Icons.add,
                      ),
                      label: const Text(
                        "Add Department",
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
              child: departments.isEmpty
                  ? const Center(
                      child: Text(
                        "No Departments Found",
                      ),
                    )
                  : ListView.builder(
                      itemCount:
                          departments.length,
                      itemBuilder:
                          (context, index) {
                        final dept =
                            departments[index];

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
                            contentPadding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),

                            leading:
                                CircleAvatar(
                              backgroundColor:
                                  const Color(
                                      0xFF081F5C),
                              child: Text(
                                dept[
                                        "department_id"]
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
                              dept[
                                  "department_name"],
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),

                            subtitle:
                                const Text(
                              "Department",
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