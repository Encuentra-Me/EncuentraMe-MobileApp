import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/signup_2.dart';
import 'package:encuentrame_app/services/auth_service.dart';

class SignUp1Page extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const SignUp1Page({
    Key? key,
    this.initialEmail,
    this.initialPassword,
  }) : super(key: key);

  @override
  _SignUp1PageState createState() => _SignUp1PageState();
}

class _SignUp1PageState extends State<SignUp1Page> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repeatPasswordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  bool _isEmailValid = true;
  String? _emailError;
  bool _isPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with initial values if provided
    if (widget.initialEmail != null) {
      emailController.text = widget.initialEmail!;
    }
    if (widget.initialPassword != null) {
      passwordController.text = widget.initialPassword!;
      repeatPasswordController.text = widget.initialPassword!;
    }
    emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateEmail);
    emailController.dispose();
    passwordController.dispose();
    repeatPasswordController.dispose();
    super.dispose();
  }

  Future<void> _validateEmail() async {
    final email = emailController.text;
    if (email.isEmpty) {
      setState(() {
        _isEmailValid = true;
        _emailError = null;
      });
      return;
    }

    // Basic email format validation
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _isEmailValid = false;
        _emailError = 'Por favor ingrese un email válido';
      });
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final isUnique = await _authService.isEmailUnique(email);
      setState(() {
        _isEmailValid = isUnique;
        _emailError = isUnique ? null : 'Este email ya está registrado';
      });
    } catch (e) {
      setState(() {
        _isEmailValid = false;
        _emailError = 'Error al validar el emailowo';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleNext() async {
    // Validate fields
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        repeatPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor complete todos los campos')),
      );
      return;
    }

    // Validate email
    if (!_isEmailValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_emailError ?? 'Email inválido')),
      );
      return;
    }

    // Validate passwords match
    if (passwordController.text != repeatPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Las contraseñas no coinciden')),
      );
      return;
    }

    // Navigate to the next step with the data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUp2Page(
          email: emailController.text,
          password: passwordController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[50],
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text('Crear Cuenta',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Color(0xff2E724F))),
                    SizedBox(height: 20),
                    Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16), // Puedes ajustar el valor
                    child: Text('Gracias a tu ayuda, más familias podrán reencontrarse',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20))),

                    SizedBox(height: 50),
                      Align(alignment: Alignment.centerLeft, 
                      child:RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 18), // Estilo base
                          children: [
                            TextSpan(text: 'Paso '),
                            TextSpan(
                              text: '1',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' de '),
                            TextSpan(
                              text: '2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                    SizedBox(height: 40),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: _emailError,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        suffixIcon: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : _isEmailValid && emailController.text.isNotEmpty
                                ? Icon(Icons.check_circle, color: Colors.green)
                                : null,
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: repeatPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Repetir contraseña',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isRepeatPasswordVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isRepeatPasswordVisible,
                    ),


                    SizedBox(height: 35),
                    Center(
                      child: GestureDetector(
                        onTap: _isLoading ? null : _handleNext,
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
                              : Text('Siguiente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Footer
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1.0,
                ),
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¿Ya tienes cuenta?',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Inicia sesión',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
