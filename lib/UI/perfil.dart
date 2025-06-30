import 'package:encuentrame_app/UI/camera_view.dart';
import 'package:encuentrame_app/models/user.dart';
import 'package:encuentrame_app/services/auth_service.dart';
import 'package:encuentrame_app/services/user_service.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/utils/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:encuentrame_app/components/app_header.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  _PerfilPage createState() => _PerfilPage();
}

class _PerfilPage extends State<PerfilPage> {

  final AuthService _authService = AuthService();
  final UserService _userService = UserService(); 
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    
    final userId = await _authService.getUserId();

    if (userId != null) {
      try {
        print("_userId: $userId");
        final user = await _userService.getUserById(userId);
        print("user: ${user.email}");
        setState(() {
          _user = user;
          _isLoading = false;
        });
      } catch (e) {
        // handle error, e.g. show snackbar
        print('Error loading user: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!', isProfilePage: true),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    // Profile Picture
                    CircleAvatar(
                      radius: 75,
                      backgroundColor: Colors.grey.shade200,
                      child: const Icon(
                        Icons.person,
                        size: 150,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Profile Information
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      )
                    else if (_user != null)
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              _buildProfileField('Email', _user!.email),
                              _buildProfileField('Rol', _user!.roleName),
                              _buildProfileField('Nombres', _user!.firstName),
                              _buildProfileField('Apellido Paterno', _user!.paternalLastName),
                              _buildProfileField('Apellido Materno', _user!.maternalLastName),
                              _buildProfileField(_user!.documentType, _user!.documentNumber),
                              _buildProfileField('Fecha de Nacimiento', _user!.birthDate),
                              _buildProfileField('Celular', '${_user!.countryCode} ${_user!.phone}'),
                              _buildProfileField('Ubigeo', _user!.ubigeo),
                            ],
                          ),
                        ),
                      )
                    else
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            'Error al cargar el perfil del usuario',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomBottomBar.buildCameraFab(
        onPressed: () {
          // Aquí va a la camara para iniciar el proceso de reconocimiento facial
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CameraView()));
        },
      ),
    );
  }

  Widget _buildProfileField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
          text,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightGreen,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
