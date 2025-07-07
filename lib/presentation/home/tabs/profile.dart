import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../viewmodel/auth_viewmodel.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  Future<Map<String, String>> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "username": prefs.getString("username") ?? "",
      "firstName": prefs.getString("firstName") ?? "",
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
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
        final data = snapshot.data!;
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Username: ${data['username']}", style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text("Email: ${data['email']}"),
              Text("Bio: ${data['bio']}"),
              const Spacer(),
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
        );
      },
    );
  }
}
