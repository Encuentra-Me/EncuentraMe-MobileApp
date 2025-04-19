import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/login.dart';
import 'package:encuentrame_app/UI/signup_1.dart';
import 'package:encuentrame_app/services/auth_service.dart';
import 'package:intl/intl.dart';

class SignUp2Page extends StatefulWidget {
  final String email;
  final String password;

  const SignUp2Page({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  _SignUp2PageState createState() => _SignUp2PageState();
}

class _SignUp2PageState extends State<SignUp2Page> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final AuthService _authService = AuthService();
  String selectedDocumentType = 'DNI';
  bool isChecked = false;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: Locale('es', 'ES'),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        birthDateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _handleBack() {
    // Return to SignUp1Page with the current data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp1Page(
          initialEmail: widget.email,
          initialPassword: widget.password,
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    // Validate fields
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        documentNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    if (!isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Debe aceptar los términos y condiciones')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Register with all data
      await _authService.registerComplete(
        email: widget.email,
        password: widget.password,
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        phone: phoneController.text,
        birthDate: birthDateController.text,
        documentType: selectedDocumentType,
        documentNumber: documentNumberController.text,
      );

      // If registration is successful, navigate to the reports list page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ReportListPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al registrarse: ${e.toString()}')),
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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: _handleBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                keyboardType: TextInputType.phone,
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthDateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: selectedDocumentType,
                      decoration: InputDecoration(
                        labelText: 'Tipo de Documento',
                      ),
                      items: ['DNI', 'Pasaporte']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDocumentType = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: documentNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número de Documento',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                title: Text('He leído y acepto los Términos y Condiciones'),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _isLoading ? null : _handleRegister,
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
                      : Text('Registrarse',
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
      ),
    );
  }
}
