import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../../viewmodel/auth_viewmodel.dart';
import '../../common.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<Map<String, String>> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "username": prefs.getString("username") ?? "",
      "firstName": prefs.getString("firstName") ?? "",
      "lastName" : prefs.getString("lastName") ?? "",
      "email": prefs.getString("email") ?? "",
      "bio": prefs.getString("bio") ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);

    return FutureBuilder(
      future: _loadUser(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 300,
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300, width: 1),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            width: 120.0,
                            height: 120.0,
                            child: Image.network(
                              "https://cdn-icons-png.flaticon.com/512/3607/3607444.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${data['firstName']} ${data['lastName']}",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.verified_outlined),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                profileOption(
                  label: "Personal Details",
                  icon: Icons.person_outline,
                  onTap: () => print("Personal Details tapped"),
                ),
                profileOption(
                  label: "Settings",
                  icon: Icons.settings_outlined,
                  onTap: () => print("Settings tapped"),
                ),
                profileOption(
                  label: "Toggle Theme",
                  icon: Icons.dark_mode_outlined,
                  onTap: () => print("Toggle theme tapped"),
                ),
                profileOption(
                  label: "Privacy & Policy",
                  icon: Icons.privacy_tip_outlined,
                  onTap: () => print("Privacy & Policy tapped"),
                ),

                const SizedBox(height: 40), // Add space before button if needed

                // 🔻 Logout button always last
                ElevatedButton.icon(
                  onPressed: () => viewModel.logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}
