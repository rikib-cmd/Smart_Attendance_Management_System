import 'package:flutter/material.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Widget roleCard({
    required BuildContext context,
    required String title,
    required String role,
    required IconData icon,
    required Color iconColor,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => LoginScreen(
                role: role,
              ),
            ),
          );
        },
        child: Container(
          height: 330,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.12),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
            children: [

              CircleAvatar(
                radius: 45,
                backgroundColor:
                    iconColor.withOpacity(.15),
                child: Icon(
                  icon,
                  size: 50,
                  color: iconColor,
                ),
              ),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF081F5C),
                ),
              ),

              Text(
                title == "Administrator"
                    ? "Manage system users and academic records"
                    : title == "Teacher Portal"
                        ? "Manage classes and attendance"
                        : "View attendance and reports",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            LoginScreen(
                          role: role,
                        ),
                      ),
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFFFFC107),
                    foregroundColor:
                        Colors.black,
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                              16),
                    ),
                  ),
                  child: const Text(
                    "Access Portal",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF081F5C),
              Color(0xFF0F4CFF),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.all(30),
                child: Column(
                  children: [

                    Container(
                      width: 140,
                      height: 140,
                      decoration:
                          BoxDecoration(
                        color: Colors.white
                            .withOpacity(.15),
                        shape:
                            BoxShape.circle,
                        border: Border.all(
                          color:
                              Colors.white24,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.school_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(
                        height: 25),

                    const Text(
                      "Smart Attendance\nManagement System",
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight:
                            FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    const Text(
                      "Select Your Portal",
                      style: TextStyle(
                        color:
                            Colors.white70,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(
                        height: 50),

                    LayoutBuilder(
                      builder:
                          (context, c) {

                        if (c.maxWidth >
                            900) {
                          return Row(
                            children: [

                              roleCard(
                                context:
                                    context,
                                title:
                                    "Administrator",
                                role:
                                    "Admin",
                                icon: Icons
                                    .admin_panel_settings_rounded,
                                iconColor:
                                    Colors.blue,
                              ),

                              const SizedBox(
                                  width:
                                      25),

                              roleCard(
                                context:
                                    context,
                                title:
                                    "Teacher Portal",
                                role:
                                    "Teacher",
                                icon: Icons
                                    .person,
                                iconColor:
                                    Colors.green,
                              ),

                              const SizedBox(
                                  width:
                                      25),

                              roleCard(
                                context:
                                    context,
                                title:
                                    "Student Portal",
                                role:
                                    "Student",
                                icon: Icons
                                    .school,
                                iconColor:
                                    Colors.orange,
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [

                            SizedBox(
                              width: 450,
                              child:
                                  roleCard(
                                context:
                                    context,
                                title:
                                    "Administrator",
                                role:
                                    "Admin",
                                icon: Icons
                                    .admin_panel_settings_rounded,
                                iconColor:
                                    Colors.blue,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    20),

                            SizedBox(
                              width: 450,
                              child:
                                  roleCard(
                                context:
                                    context,
                                title:
                                    "Teacher Portal",
                                role:
                                    "Teacher",
                                icon: Icons
                                    .person,
                                iconColor:
                                    Colors.green,
                              ),
                            ),

                            const SizedBox(
                                height:
                                    20),

                            SizedBox(
                              width: 450,
                              child:
                                  roleCard(
                                context:
                                    context,
                                title:
                                    "Student Portal",
                                role:
                                    "Student",
                                icon: Icons
                                    .school,
                                iconColor:
                                    Colors.orange,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}