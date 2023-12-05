// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:basri_task_1/screens/page_after_login.dart';
import 'package:flutter/material.dart';
import '/login_service/login_service.dart';

final LoginService loginService = LoginService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return const TabBarDemo();
  }
}

class TabBarDemo extends StatefulWidget {
  const TabBarDemo({super.key});

  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.exit_to_app_outlined),
        title: const Text('Login or Sign Up'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Log in'),
            Tab(text: 'Sign Up'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          LoginTab(),
          SignUpTab(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class LoginTab extends StatefulWidget {
  const LoginTab({super.key});

  @override
  State<LoginTab> createState() => _LoginTabState();
}

class _LoginTabState extends State<LoginTab> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Login", style: TextStyle(fontSize: 40)),
          ),
          Card(
              child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          )),
          Card(
              child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          )),
          ElevatedButton(
            onPressed: () async {
              String userName = usernameController.text.trim();
              String password = passwordController.text.trim();
              final result =
                  await loginService.isLoginValid(userName, password);
              if (result == true) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return const EmptyScreen();
                    },
                  ),
                );
              } else {
                DialogPop(context);
              }
            },
            child: const Text('Log in'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> DialogPop(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Failed'),
          content: const Text('Wrong username or password. Please try again.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class SignUpTab extends StatefulWidget {
  const SignUpTab({super.key});

  @override
  State<SignUpTab> createState() => _SignUpTabState();
}

class _SignUpTabState extends State<SignUpTab> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Text("Sign Up", style: TextStyle(fontSize: 40)),
          ),
          Card(
              child: TextField(
            controller: usernameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username',
            ),
          )),
          Card(
              child: TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
            ),
          )),
          Card(
              child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
          )),
          Card(
              child: TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Confirm Password',
            ),
          )),
          ElevatedButton(
            onPressed: () async {
              String username = usernameController.text;
              String email = emailController.text;
              String password = passwordController.text;
              String confirmPassword = confirmPasswordController.text;
              if (password == confirmPassword) {
                final result =
                    await loginService.isSignValuesValid(username, email);
                if (result.toString() == "a") {
                  loginService.saveUser(username, password, email);
                  DialogPop(context, "Sign Up Completed", "Go to Login Page");
                } else {
                  DialogPop(context, "Sign Up Failed", result.toString());
                }
              } else {
                DialogPop(context, "Sign Up Failed",
                    "Password and Confirm Password must match");
              }
            },
            child: const Text('Sign up'),
          ),
        ],
      ),
    );
  }

  Future<dynamic> DialogPop(
      BuildContext context, String message, String message1) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: Text(message1),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
