import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../model/user_model.dart';
import '../../../viewmodel/auth_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, String> data;

  const EditProfileScreen({super.key, required this.data});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    firstNameController = TextEditingController(text: widget.data['firstName']);
    lastNameController = TextEditingController(text: widget.data['lastName']);
    emailController = TextEditingController(text: widget.data['email']);
    bioController = TextEditingController(text: widget.data['bio']);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<AuthViewModel>(context);
    final currentProfile = viewModel.uploadedImageUrl ??
        (widget.data['profile'] != null && widget.data['profile']!.isNotEmpty
            ? widget.data['profile']
            : null);

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  await viewModel.pickAndUploadProfileImage();
                },
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Hero(
                      tag: 'profile-avatar',
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: currentProfile != null
                            ? NetworkImage(currentProfile)
                            : const NetworkImage("https://cdn-icons-png.flaticon.com/512/6897/6897018.png"),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.edit, size: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: firstNameController,
              decoration: const InputDecoration(labelText: "First Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: lastNameController,
              decoration: const InputDecoration(labelText: "Last Name"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(labelText: "Bio"),
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: widget.data['username'],
              decoration: const InputDecoration(labelText: "Username"),
              enabled: false,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final updatedUser = UserModel(
                  username: widget.data['username']!,
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  email: emailController.text.trim(),
                  bio: bioController.text.trim(),
                  profile: viewModel.uploadedImageUrl ?? "https://cdn-icons-png.flaticon.com/512/6897/6897018.png",
                  token: widget.data['token'] ?? "",
                );

                final success = await viewModel.updateProfile(updatedUser);

                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(success ? "✅ Profile updated!" : "❌ Failed to update"),
                ));

                if (success) Navigator.pop(context);
              },
              child: viewModel.isUpdating
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
