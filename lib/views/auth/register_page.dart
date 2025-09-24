// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/shared/dialog_loading.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool isLoading = false;

  Future<void> _register() async {
    if (isLoading) return; // Prevent multiple taps
    showDialog(context: context, builder: (context) => const DialogLoading());
    try {
      setState(() {
        isLoading = true;
      });
      await AuthService().register(
        _emailController.text,
        _passwordController.text,
      );
      await AuthService().updateProfile(displayName: _nameController.text);
      if (!mounted) return;
      Navigator.of(context).pop(); // Close the loading dialogc
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration failed')));
      Navigator.of(context).pop(); // Close the loading dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SizedBox(
                height: 140,
                child: Center(
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_add_alt_1_rounded,
                      size: 60,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Buat Akun Baru',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade900,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12),
              Text(
                'Daftar untuk mulai mengatur keuanganmu.',
                style: TextStyle(fontSize: 16, color: Colors.teal.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 28),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        labelStyle: TextStyle(color: Colors.teal),
                        prefixIcon: Icon(Icons.person, color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Colors.teal),
                        prefixIcon: Icon(Icons.email, color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email tidak boleh kosong';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Email tidak valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: Colors.teal),
                        prefixIcon: Icon(Icons.lock, color: Colors.teal),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal.shade200),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.95),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password tidak boleh kosong';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal.shade900,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 2,
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _register();
                    }
                  },
                  child: Text('Daftar'),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.teal.shade900,
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                child: Text('Sudah punya akun? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
