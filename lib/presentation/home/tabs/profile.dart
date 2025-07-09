import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../viewmodel/auth_viewmodel.dart';
import '../../../viewmodel/theme_viewmodel.dart';
import '../../common/common.dart';
import '../../profile/edit_profile.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<Map<String, String>> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "username": prefs.getString("username") ?? "",
      "firstName": prefs.getString("firstName") ?? "",
      "lastName": prefs.getString("lastName") ?? "",
      "profile": prefs.getString("profile") ?? "",
      "email": prefs.getString("email") ?? "",
      "bio": prefs.getString("bio") ?? "",
    };
  }

  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return FutureBuilder<Map<String, String>>(
      future: _loadUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!;
        final profileUrl = data['profile'] ?? "";

        return Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Card
                Container(
                  height: 300,
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Hero(
                            tag: 'profile-avatar',
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: profileUrl.isNotEmpty
                                  ? NetworkImage(profileUrl)
                                  : const NetworkImage("https://cdn-icons-png.flaticon.com/512/6897/6897018.png"),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditProfileScreen(data: data),
                                  ),
                                );
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${data['firstName']} ${data['lastName']}",
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.verified_outlined, color: Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Options
                profileOption(
                  label: "Personal Details",
                  icon: Icons.person_outline,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(data: data),
                      ),
                    );
                  },
                ),
                profileOption(
                  label: "Settings",
                  icon: Icons.settings_outlined,
                  onTap: () => print("Settings tapped"),
                ),
                profileOption(
                  label: "Dark Mode",
                  icon: Icons.dark_mode,
                  onTap: () {},
                  showSwitch: true,
                  switchValue: themeProvider.isDarkMode,
                  onSwitchChanged: (_) => themeProvider.toggleTheme(),
                ),
                profileOption(
                  label: "About App",
                  icon: Icons.info_outline,
                  onTap: () => print("About app"),
                ),

                const SizedBox(height: 40),

                ElevatedButton.icon(
                  onPressed: () => authViewModel.logout(context),
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
