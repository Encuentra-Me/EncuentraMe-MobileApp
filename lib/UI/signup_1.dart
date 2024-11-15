import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/signup_2.dart';

class SignUp1Page extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Crear Cuenta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Text('Gracias a tu ayuda, más familias podrán reencontrarse',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextField(
              controller: repeatPasswordController,
              decoration: InputDecoration(labelText: 'Repetir Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Al presionar la flecha, se va al segundo paso
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SignUp2Page()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                color: Colors.green,
                child: Text('Siguiente',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Regresa al Login
                Navigator.pop(context);
              },
              child: Text('¿Ya tienes cuenta? Inicia sesión',
                  style: TextStyle(color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
