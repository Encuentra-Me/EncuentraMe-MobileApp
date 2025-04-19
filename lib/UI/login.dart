import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/signup_1.dart';
import 'package:encuentrame_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _authService.login(
        emailController.text,
        passwordController.text,
      );

      // If login is successful, navigate to the reports list page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportListPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al iniciar sesión: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 150,
              color: Colors.grey[300],
              child:
                  Center(child: Text('Logo', style: TextStyle(fontSize: 24))),
            ),
            SizedBox(height: 20),
            Text('Hola, Bienvenido de nuevo!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _isLoading ? null : _handleLogin,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                color: _isLoading ? Colors.grey : Colors.green,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Iniciar Sesión',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUp1Page()));
              },
              child: Text('¿No tienes cuenta? Regístrate',
                  style: TextStyle(color: Colors.blue)),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Lógica para "Contactanos"
              },
              child: Text('Contactanos', style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
