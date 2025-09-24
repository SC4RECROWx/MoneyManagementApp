// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:money_management_app/views/settings/avatars_picker.dart';
import 'package:provider/provider.dart';
import 'package:money_management_app/core/theme/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _photoUrlController = TextEditingController();

  String? _selectedAvatar;

  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = user?.displayName ?? '';
    _photoUrlController.text = user?.photoURL ?? '';
    _selectedAvatar = user?.photoURL;
  }

  _onAvatarSelected(String avatar) {
    setState(() {
      _selectedAvatar = avatar;
      _photoUrlController.text = avatar;
    });
  }

  _submit() async {
    if (_formKey.currentState!.validate()) {
      // Update user profile
      showDialog(
        context: context,
        builder: (_) {
          return Center(child: CircularProgressIndicator());
        },
      );
      await user!.updateProfile(
        displayName: _nameController.text,
        photoURL: _photoUrlController.text,
      );

      // Show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ThemeMode themeMode = themeProvider.themeMode;

    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            // --- Edit Profile Section ---
            const Text(
              'Profil Pengguna',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Nama tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    initialValue: user?.email ?? "-",
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AvatarsPicker(
                    avatars: [
                      'assets/avatars/avatar-1.png',
                      'assets/avatars/avatar-2.png',
                    ],
                    selectedAvatar: _selectedAvatar,
                    onAvatarSelected: _onAvatarSelected,
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // --- Theme Section ---
            const Text(
              'Tema Aplikasi',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            ListTile(
              title: const Text('Terang'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
            ListTile(
              title: const Text('Gelap'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
            ListTile(
              title: const Text('Sistem'),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: (mode) {
                  themeProvider.setThemeMode(mode!);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
