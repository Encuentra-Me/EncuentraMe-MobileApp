import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/login.dart';
import 'package:encuentrame_app/UI/signup_1.dart';
import 'package:encuentrame_app/services/auth_service.dart';
import 'package:encuentrame_app/models/role_resource.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter/services.dart' show LengthLimitingTextInputFormatter;
import 'package:markdown_widget/markdown_widget.dart';
import 'package:flutter/gestures.dart';

// Country Code model class
class CountryCode {
  final String codigo;
  final String iconoBandera;
  final String codigoCelular;

  CountryCode({
    required this.codigo,
    required this.iconoBandera,
    required this.codigoCelular,
  });

  factory CountryCode.fromJson(Map<String, dynamic> json) {
    return CountryCode(
      codigo: json['codigo'],
      iconoBandera: json['icono_bandera'],
      codigoCelular: json['codigo_celular'],
    );
  }
}

// Ubigeo model class
class UbigeoData {
  final String codigo;
  final String nombre;
  final String? codigoPadre;

  UbigeoData({
    required this.codigo,
    required this.nombre,
    this.codigoPadre,
  });

  factory UbigeoData.fromJson(Map<String, dynamic> json) {
    return UbigeoData(
      codigo: json['codigo'],
      nombre: json['nombre'],
      codigoPadre: json['codigo_padre'],
    );
  }
}

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
  final TextEditingController paternalLastNameController = TextEditingController();
  final TextEditingController maternalLastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  final TextEditingController documentNumberController = TextEditingController();
  final AuthService _authService = AuthService();
  String selectedDocumentType = 'DNI';
  bool isChecked = false;
  bool _isLoading = false;

  List<UbigeoData> todosLosUbigeos = [];

  // Ubigeo state variables
  List<UbigeoData> _departamentos = [];
  List<UbigeoData> _provincias = [];
  List<UbigeoData> _distritos = [];

  UbigeoData? _selectedDepartamento;
  UbigeoData? _selectedProvincia;
  UbigeoData? _selectedDistrito;

  // Country code state variables
  List<CountryCode> _countryCodes = [];
  CountryCode? _selectedCountryCode;

  // Update role state variables
  List<RoleResource> _roles = [];
  RoleResource? _selectedRole;

  @override
  void initState() {
    super.initState();
    _loadUbigeoData();
    _loadCountryCodes();
    _loadRoles();
  }

  Future<void> _loadUbigeoData() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/ubigeos.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      const departamentoCodigoDefecto = '15';

      setState(() {
        todosLosUbigeos = jsonList
          .map((item) => UbigeoData.fromJson(item))
          .toList();
        // Filter departamentos (those without codigoPadre)
        _departamentos = todosLosUbigeos.where((u) => u.codigoPadre == null).toList();
        _selectedDepartamento = _departamentos.firstWhere(
          (ubigeo) => ubigeo.codigo == departamentoCodigoDefecto,
          orElse: () => _departamentos.first,
        );
        _provincias = todosLosUbigeos.where((u) => u.codigoPadre == departamentoCodigoDefecto).toList();
      });
    } catch (e) {
      print('Error loading Ubigeo data: $e');
    }
  }

  Future<void> _loadCountryCodes() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/codigopaises.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final List<CountryCode> codes = jsonList
          .map((item) => CountryCode.fromJson(item))
          .toList();

      setState(() {
        _countryCodes = codes;
        // Set default country code (Peru)
        _selectedCountryCode = codes.firstWhere(
          (code) => code.codigoCelular == '+51',
          orElse: () => codes.first,
        );
      });
    } catch (e) {
      print('Error loading country codes: $e');
    }
  }

  Future<void> _loadRoles() async {
    try {
      final roles = await _authService.getRoles();
      setState(() {
        _roles = roles.map((role) => RoleResource.fromJson(role)).toList();
        if (_roles.isNotEmpty) {
          _selectedRole = _roles.first;
        }
      });
    } catch (e) {
      print('Error loading roles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar los roles')),
      );
    }
  }

  void _updateProvincias(UbigeoData departamento) {

    setState(() {
      _selectedDepartamento = departamento;
      _provincias = todosLosUbigeos
          .where((u) => u.codigoPadre == departamento.codigo)
          .toList();
      _selectedProvincia = null;
      _selectedDistrito = null;
      _distritos = [];
    });
  }

  void _updateDistritos(UbigeoData provincia) {
    setState(() {
      _selectedProvincia = provincia;
      _distritos = todosLosUbigeos
          .where((u) => u.codigoPadre == provincia.codigo)
          .toList();
      _selectedDistrito = null;
    });
  }

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
        maternalLastNameController.text.isEmpty ||
        paternalLastNameController.text.isEmpty ||
        documentNumberController.text.isEmpty ||
        birthDateController.text.isEmpty ||
        phoneController.text.isEmpty || 
        _selectedProvincia == null || 
        _selectedDistrito == null ||
        _selectedRole == null) {
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
        paternalLastName: paternalLastNameController.text,
        maternalLastName: maternalLastNameController.text,
        documentType: selectedDocumentType,
        documentNumber: documentNumberController.text,
        birthDate: birthDateController.text,
        countryCode: _selectedCountryCode?.codigoCelular,
        phone: phoneController.text,
        ubigeo: _selectedDistrito?.codigo,
        roleId: _selectedRole!.id,
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

  /*Future<void> _showMarkdownDialog(String title, String assetPath) async {
    try {
      final String markdownContent = await rootBundle.loadString(assetPath);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  Divider(),
                  Expanded(
                    child: SingleChildScrollView(
                      child: MarkdownWidget(
                        data: markdownContent,
                        styleConfig: StyleConfig(
                          commonStyle: TextStyle(fontSize: 16),
                          h1Style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          h2Style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      print('Error loading markdown file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar el contenido')),
      );
    }
  }
  */
  
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
      body: Column (
        children: [
          Expanded (
            child:  SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Crear Cuenta',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xff2E724F))),
              SizedBox(height: 20),

                    // ================== PASO 2 DE 2
                    Align(alignment: Alignment.centerLeft, 
                      child:RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 18), // Estilo base
                          children: [
                            TextSpan(text: 'Paso '),
                            TextSpan(
                              text: '2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(text: ' de '),
                            TextSpan(
                              text: '2',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ),
              SizedBox(height: 40),

                    // ================== NOMBRES Y APELLIDOS
              TextField(
                controller: firstNameController,
                decoration: InputDecoration(
                  labelText: 'Nombres', 
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0))),
                onSubmitted: (_) => _handleRegister(),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: paternalLastNameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido Paterno',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onSubmitted: (_) => _handleRegister(),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: maternalLastNameController,
                      decoration: InputDecoration(
                        labelText: 'Apellido Materno',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onSubmitted: (_) => _handleRegister(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
                    
                    // ================== DOCUMENTO IDENTIDAD
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedDocumentType,
                      decoration: InputDecoration(
                        labelText: 'Tipo Documento',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
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
                    child: TextField(
                      controller: documentNumberController,
                      decoration: InputDecoration(
                        labelText: 'Número Documento',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                      keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(8)
                            ],
                      onSubmitted: (_) => _handleRegister(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

                    // ================== FECHA NACIMIENTO
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Fecha de nacimiento',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
                    controller: birthDateController,
                    decoration: InputDecoration(
                      labelText: 'Fecha de Nacimiento',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                    ),
                    onSubmitted: (_) => _handleRegister(),
                  ),
                ),
              ),
              SizedBox(height: 10),
                    
                    // ================== CELULAR
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Celular',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    ),
              Row(
                children: [
                  Expanded(
                          flex: 3,
                          child: DropdownButtonFormField<CountryCode>(
                            value: _selectedCountryCode,
                      decoration: InputDecoration(
                        labelText: 'Código',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                            items: _countryCodes.map((CountryCode countryCode) {
                              return DropdownMenuItem<CountryCode>(
                                value: countryCode,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.network(
                                      countryCode.iconoBandera,
                                      width: 24,
                                      height: 16,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Icon(Icons.flag, size: 24);
                                      },
                                    ),
                                    SizedBox(width: 8),
                                    Text(countryCode.codigoCelular),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (CountryCode? newValue) {
                              if (newValue != null) {
                        setState(() {
                                  _selectedCountryCode = newValue;
                        });
                              }
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                          flex: 5,
                    child: TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: 'Número de Celular',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                        hintText: '999999999',
                      ),
                      keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              LengthLimitingTextInputFormatter(9)
                            ],
                      onSubmitted: (_) => _handleRegister(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
                    
                    // ================== UBICACION ACTUAL
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                    child: Text(
                          'Ubicación actual',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                          ),
                        )
                      ),
                    ),
                    DropdownButtonFormField<UbigeoData>(
                        value: _selectedDepartamento,
                          decoration: InputDecoration(
                            labelText: 'Departamento',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                          ),
                        items: _departamentos.map((UbigeoData departamento) {
                          return DropdownMenuItem<UbigeoData>(
                              value: departamento,
                            child: Text(departamento.nombre),
                            );
                          }).toList(),
                        onChanged: (UbigeoData? newValue) {
                            if (newValue != null) {
                              _updateProvincias(newValue);
                            }
                          },
                        ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<UbigeoData>(
                      value: _selectedProvincia,
                          decoration: InputDecoration(
                            labelText: 'Provincia',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                          ),
                      items: _provincias.map((UbigeoData provincia) {
                        return DropdownMenuItem<UbigeoData>(
                              value: provincia,
                          child: Text(provincia.nombre),
                            );
                          }).toList(),
                      onChanged: (UbigeoData? newValue) {
                            if (newValue != null) {
                              _updateDistritos(newValue);
                            }
                          },
                        ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<UbigeoData>(
                      value: _selectedDistrito,
                          decoration: InputDecoration(
                            labelText: 'Distrito',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                          ),
                      items: _distritos.map((UbigeoData distrito) {
                        return DropdownMenuItem<UbigeoData>(
                              value: distrito,
                          child: Text(distrito.nombre),
                            );
                          }).toList(),
                      onChanged: (UbigeoData? newValue) {
                            setState(() {
                          _selectedDistrito = newValue;
                            });
                          },
                    ),
                    SizedBox(height: 10),

                    // ================== ROL DE USUARIO
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, bottom: 8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Rol de usuario',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    DropdownButtonFormField<RoleResource>(
                      value: _selectedRole,
                      decoration: InputDecoration(
                        labelText: 'Rol de usuario',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                      items: _roles.map((role) => DropdownMenuItem(
                        value: role,
                        child: Text(role.name),
                      )).toList(),
                      onChanged: (RoleResource? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedRole = newValue;
                          });
                        }
                      },
                    ),
                    SizedBox(height: 10),

                    // ================== TERMINOS Y CONDICIONES
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: RichText(
                        text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 18),
                          children: [
                            TextSpan(text: 'He leído y acepto los '),
                            TextSpan(
                              text: 'Términos y Condiciones',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                            ),
                              /*recognizer: TapGestureRecognizer()
                                ..onTap = () => _showMarkdownDialog(
                                      'Términos y Condiciones',
                                      'assets/terminos_condiciones.md',
                                    ),*/
                            ),
                            TextSpan(text: '  y la  '),
                            TextSpan(
                              text: 'Política de Privacidad',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                              /*recognizer: TapGestureRecognizer()
                                ..onTap = () => _showMarkdownDialog(
                                      'Política de Privacidad',
                                      'assets/politica_privacidad.md',
                        ),*/
                            ),
                          ],
                        ),
                      ),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    

                    // ================== BOTÓN REGISTRARSE
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
        ]
      )
    );
  
  }

}
