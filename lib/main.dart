// Лабораторна робота №13. Взаємодія із бекендом за допомогою пакету dio
// Дані форм Login, Sign up та Reset Password надсилаються на requestcatcher.com

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

// Адреса, куди надсилаються запити.
// Відкрий її в браузері, щоб бачити запити, які приходять.
const String baseUrl = 'https://lab13-lunya.requestcatcher.com';

// Один об'єкт Dio на весь застосунок
final dio = Dio(BaseOptions(baseUrl: baseUrl));

// Функція, яка надсилає POST-запит і показує результат
Future<void> sendData(
    BuildContext context,
    String path,
    Map<String, dynamic> data,
    ) async {
  try {
    final response = await dio.post(path, data: data);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Дані надіслано! Код відповіді: ${response.statusCode}')),
    );
  } on DioException catch (e) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Помилка: ${e.message}'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const LoginPage(),
    );
  }
}

// ----- Екран Login -----

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login() async {
    setState(() => isLoading = true);

    await sendData(context, '/login', {
      'email': emailController.text,
      'password': passwordController.text,
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : login,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Login'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            },
            child: const Text('Немає акаунту? Sign up'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResetPage()),
              );
            },
            child: const Text('Забули пароль?'),
          ),
        ],
      ),
    );
  }
}

// ----- Екран Sign up -----

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> signUp() async {
    setState(() => isLoading = true);

    await sendData(context, '/signup', {
      'name': nameController.text,
      'email': emailController.text,
      'password': passwordController.text,
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : signUp,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Sign up'),
          ),
        ],
      ),
    );
  }
}

// ----- Екран Reset Password -----

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final emailController = TextEditingController();
  bool isLoading = false;

  Future<void> reset() async {
    setState(() => isLoading = true);

    await sendData(context, '/reset', {
      'email': emailController.text,
    });

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : reset,
            child: isLoading
                ? const CircularProgressIndicator()
                : const Text('Reset Password'),
          ),
        ],
      ),
    );
  }
}