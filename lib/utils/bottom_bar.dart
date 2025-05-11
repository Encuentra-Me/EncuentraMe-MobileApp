import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/login.dart';
import 'package:encuentrame_app/services/auth_service.dart';

class CustomBottomBar extends StatelessWidget {
  const CustomBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // 1. Home
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReportListPage()));
              },
            ),
            // 2. Guardados
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()));
              },
            ),

            // 3. Espacio reservado para el FAB (vacío)
            const SizedBox(width: 48),

            // Derecha: Contribuciones y Más
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.upload_outlined),
                  onPressed: () {
                    // aqui va a contribuciones
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()));
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    // Show confirmation dialog
                    final shouldLogout = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Cerrar Sesión'),
                          content: const Text('¿Estás seguro que deseas cerrar sesión?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldLogout == true) {
                      try {
                        final authService = AuthService();
                        await authService.logout();
                        
                        // Navigate to login page and clear the navigation stack
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
                          );
                        }
                      }
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Construye el FloatingActionButton de cámara,
  /// centrado sobre el notch del BottomAppBar.
  static FloatingActionButton buildCameraFab({
    VoidCallback? onPressed,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF2E7D32),
      child: const Icon(Icons.camera_alt, size: 32, color: Colors.white),
    );
  }
}
