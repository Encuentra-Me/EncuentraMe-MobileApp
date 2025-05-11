import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';

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
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {
                    // aqui va a mas opciones
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()));
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
