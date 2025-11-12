import 'package:finview_lite/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final userController = TextEditingController();
  final passController = TextEditingController();
  bool isLoading = false;
  
  Future<void> login() async {
    final username = userController.text.trim();
    final password = passController.text.trim();

    if(username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("please fill all fields")),
      );
      return;
    }

    if (username == 'Celsa' && password == '1234'){
      setState(() =>
        isLoading = true);

        await Future.delayed(const Duration(seconds: 1));

        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('username', username);

         if (mounted) {
            setState(() => isLoading = false);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Dashboard()),
      );
    }
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("incorrect fields"),
        backgroundColor: Colors.red,
        )
      );     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade400,
      body: Center(
        child: Padding(padding: const EdgeInsets.all(20),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Finview Lite Login",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20,),
                TextField(
                    controller: userController,
                    decoration: const InputDecoration(
                      labelText: "Username",
                      border: OutlineInputBorder(),
                    ),
                ),

                const SizedBox(height: 12),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: isLoading ? null : login,
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),
              ],
            ),
            ),
        ),
        ),
      ),
    );
  }
}