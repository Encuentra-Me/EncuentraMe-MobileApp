import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/signup_1.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Lógica para iniciar sesión y navegar a la página principal
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportListPage()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                color: Colors.green,
                child: Text('Iniciar Sesión',
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
