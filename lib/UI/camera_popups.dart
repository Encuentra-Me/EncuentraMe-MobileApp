import 'dart:async';
import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:url_launcher/url_launcher.dart';

class CameraPopupProcess {
  final BuildContext context;
  final List<String> imagePaths;
  final String? comment;

  CameraPopupProcess({
    required this.context,
    required this.imagePaths,
    this.comment,
  });

  /// Inicia la secuencia de popups
  void startProcess() {
    _showPopup1();
  }

  // --- Popup 1: Nota adicional ---
  void _showPopup1() async {
    final TextEditingController controller = TextEditingController();

    // barrierDismissible: true permite cerrar tocando fuera
    final comment = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: EdgeInsets.zero,
          title: Stack(
            children: [
              Positioned(
                left: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(null),
                  child: const Icon(Icons.close, size: 24),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text('NOTA ADICIONAL',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () => Navigator.of(ctx).pop(controller.text.trim()),
                  child: const Icon(Icons.arrow_forward, size: 24),
                ),
              ),
            ],
          ),
          content: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Agrega un comentario adicional')),
                const SizedBox(height: 8),
                TextField(
                  controller: controller,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Escribe aquí tu nota...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (comment != null) {
      _showPopup2(comment);
    }
    // si comment es null, el usuario cerró el popup → no seguimos
  }

  // --- Popup 2: Procesando ---
  void _showPopup2(String comment) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: const Center(
            child: Text('PROCESANDO',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              SizedBox(height: 8),
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Estamos procesando tu(s) imagen(es)...',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );

    // Simula un proceso de 2 segundos
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // cierra el dialog de procesamiento
      _showPopup3(comment);
    });
  }

  // --- Popup 3: Gracias y redirección ---
  void _showPopup3(String comment) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          titlePadding: EdgeInsets.zero,
          title: Stack(
            children: [
              Positioned(
                left: 8,
                top: 8,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(ctx).pop();
                    // Navegar a listado de reportes
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ReportListPage()),
                    );
                  },
                  child: const Icon(Icons.close, size: 24),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Text('GRACIAS !!',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Tu aporte será de gran ayuda. \nSe te notificará el progreso del caso..',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call),
                  label: const Text('Policía - Línea 114'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E7D32),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () async {
                    // (Opcional) lanzar llamada
                    // Lanza la app de teléfono con el número 114 marcado
                    final uri = Uri(scheme: 'tel', path: '114');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                    // Luego, opcionalmente, cierra el popup y va a report list:
                    Navigator.of(ctx).pop();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const ReportListPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
