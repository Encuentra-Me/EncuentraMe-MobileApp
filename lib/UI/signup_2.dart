import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/login.dart';

class SignUp2Page extends StatelessWidget {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  bool isChecked = false;

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
            Text('Paso 2 de 2', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            TextField(
              controller: firstNameController,
              decoration: InputDecoration(labelText: 'Nombres'),
            ),
            TextField(
              controller: lastNameController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Celular'),
            ),
            TextField(
              controller: birthDateController,
              decoration: InputDecoration(labelText: 'Fecha de Nacimiento'),
            ),
            CheckboxListTile(
              title: Text('He leído y acepto los Términos y Condiciones'),
              value: isChecked,
              onChanged: (bool? value) {
                // Cambiar el estado del checkbox
              },
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                // Guardar datos en la base de datos estática
                /*user.add({
                  'email': emailController.text,
                  'password': passwordController.text,
                  'first_name': firstNameController.text,
                  'last_name': lastNameController.text,
                  'phone': phoneController.text,
                  'birth_date': birthDateController.text,
                });*/

                // Navegar a la página principal
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => ReportListPage()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: double.infinity,
                color: Colors.green,
                child: Text('Registrarse',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                // Regresa al Login
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
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
