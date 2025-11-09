import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool isLogin = true;

  final supabase = Supabase.instance.client;

  Future<void> handleAuth() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    try {
      if (isLogin) {
        // Sign In
        final res = await supabase.auth.signInWithPassword(email: email, password: password);
        if (!mounted) return;
        if (res.user != null) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      } else {
        // Sign Up
        final res = await supabase.auth.signUp(email: email, password: password);
        if (!mounted) return;
        if (res.user != null) {
          // ایجاد پروفایل در جدول profiles
          await supabase.from('profiles').insert({
            'user_id': res.user!.id,
            'name': name,
            'email': email,
          });
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Check your email for verification')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Login' : 'Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (!isLogin)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: handleAuth,
              child: Text(isLogin ? 'Login' : 'Sign Up'),
            ),
            TextButton(
              onPressed: () => setState(() => isLogin = !isLogin),
              child: Text(isLogin ? 'Create an account' : 'Have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}
