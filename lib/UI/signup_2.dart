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
  final TextEditingController paternalLastNameController = TextEditingController();
  final TextEditingController maternalLastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final AuthService _authService = AuthService();
  String selectedDocumentType = 'DNI';
  String selectedCountryCode = '+51';
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
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff2E724F))),
              SizedBox(height: 20),
              Text('Paso 2 de 2', style: TextStyle(fontSize: 16)),
              SizedBox(height: 40),
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'Nombres', 
                        border: OutlineInputBorder()),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: paternalLastNameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido Paterno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maternalLastNameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido Materno',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedDocumentType,
                      decoration: InputDecoration(
                        labelText: 'Tipo Documento',
                        border: OutlineInputBorder(),
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
                    ), //flex: 2,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: documentNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número Documento',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ), //flex: 3,
                  ),
                ],
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthDateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                      value: selectedCountryCode,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        DropdownMenuItem(value: '+51', child: Text('+51')),
                        DropdownMenuItem(value: '+1', child: Text('+1')),
                        DropdownMenuItem(value: '+52', child: Text('+52')),
                        DropdownMenuItem(value: '+54', child: Text('+54')),
                        DropdownMenuItem(value: '+56', child: Text('+56')),
                        DropdownMenuItem(value: '+57', child: Text('+57')),
                        DropdownMenuItem(value: '+58', child: Text('+58')),
                        DropdownMenuItem(value: '+591', child: Text('+591')),
                        DropdownMenuItem(value: '+592', child: Text('+592')),
                        DropdownMenuItem(value: '+593', child: Text('+593')),
                        DropdownMenuItem(value: '+595', child: Text('+595')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedCountryCode = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Número de Celular',
                        border: OutlineInputBorder(),
                        hintText: '999999999',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                  ),
                ],
              ),
              CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text('He leído y acepto los Términos y Condiciones'),
                value: isChecked,
                onChanged: (bool? value) {
                  setState(() {
                    isChecked = value ?? false;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _isLoading ? null : _handleRegister,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                    decoration: BoxDecoration(
                      color: _isLoading ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text('Registrarse',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            )),
                  ),
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
