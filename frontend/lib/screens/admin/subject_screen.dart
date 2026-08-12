import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SubjectScreen extends StatefulWidget {
  const SubjectScreen({super.key});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  List subjects = [];
  bool loading = true;

  final TextEditingController subjectController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadSubjects();
  }

  Future<void> loadSubjects() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:5001/api/subjects"),
      );

      final data = jsonDecode(response.body);

      setState(() {
        subjects = data["subjects"];
        loading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> addSubject() async {
    if (subjectController.text.isEmpty) return;

    await http.post(
      Uri.parse(
        "http://localhost:5001/api/subjects/add",
      ),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "subject_name": subjectController.text,
        "department_id": 1,
        "semester_id": 1
      }),
    );

    subjectController.clear();
    loadSubjects();
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
          "Subjects",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                      borderRadius:
                          BorderRadius.circular(24),
                    ),
                    child: const Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Subject Management",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Manage all academic subjects",
                          style: TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    padding:
                        const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(.05),
                          blurRadius: 10,
                          offset:
                              const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [

                        TextField(
                          controller:
                              subjectController,
                          decoration:
                              InputDecoration(
                            labelText:
                                "Subject Name",
                            prefixIcon:
                                const Icon(
                              Icons.book,
                            ),
                            filled: true,
                            fillColor:
                                const Color(
                                    0xFFF8FAFC),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          14),
                              borderSide:
                                  BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(
                            height: 15),

                        SizedBox(
                          width:
                              double.infinity,
                          height: 55,
                          child:
                              ElevatedButton.icon(
                            onPressed:
                                addSubject,
                            icon: const Icon(
                                Icons.add),
                            label: const Text(
                              "Add Subject",
                            ),
                            style:
                                ElevatedButton
                                    .styleFrom(
                              backgroundColor:
                                  const Color(
                                      0xFF081F5C),
                              foregroundColor:
                                  Colors.white,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
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
                    child: subjects.isEmpty
                        ? const Center(
                            child: Text(
                              "No Subjects Found",
                            ),
                          )
                        : ListView.builder(
                            itemCount:
                                subjects.length,
                            itemBuilder:
                                (context,
                                    index) {
                              final subject =
                                  subjects[
                                      index];

                              return Container(
                                margin:
                                    const EdgeInsets
                                        .only(
                                  bottom: 12,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.white,
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
                                      blurRadius:
                                          8,
                                      offset:
                                          const Offset(
                                              0,
                                              4),
                                    ),
                                  ],
                                ),
                                child:
                                    ListTile(
                                  leading:
                                      CircleAvatar(
                                    backgroundColor:
                                        const Color(
                                            0xFF081F5C),
                                    child: Text(
                                      "${subject["subject_id"]}",
                                      style:
                                          const TextStyle(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    subject[
                                        "subject_name"],
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),
                                  subtitle:
                                      Text(
                                    "${subject["department_name"]} • Semester ${subject["semester_no"]}",
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