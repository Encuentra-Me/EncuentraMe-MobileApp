import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/person_founded.dart';
import 'package:encuentrame_app/services/rekognition_http_service.dart';
import 'package:encuentrame_app/services/s3_upload_service.dart';

class CameraPopupProcess {
  final BuildContext context;
  final List<String> imagePaths;
  final String? comment;

  CameraPopupProcess({
    required this.context,
    required this.imagePaths,
    this.comment,
  });

  void startProcess() => _showPopup1();

  // Popup 1: nota adicional
  void _showPopup1() async {
    final controller = TextEditingController();
    final note = await showDialog<String?>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                child: const Text(
                  'NOTA ADICIONAL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                child: Text('Agrega un comentario adicional'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Escribe aquí tu nota...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (note != null) {
      _showPopup2(note);
    }
  }

  // Popup 2: procesando + subida + llamada a Rekognition
  void _showPopup2(String note) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Center(
          child:
              Text('PROCESANDO', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SizedBox(height: 8),
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'Estamos subiendo tu imagen...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    /*uploadImageToS3(imagePaths.first).then((key) {
      identifyFaces(key).then((matches) {
        Navigator.of(context).pop(); // Cierra el diálogo de carga
        _showPopup3(note, matches);
      }).catchError((error) {
        Navigator.of(context).pop();
        _showErrorDialog('Error en Rekognition: $error');
      });
    }).catchError((error) {
      Navigator.of(context).pop();
      _showErrorDialog('Error subiendo a S3: $error');
    });*/
    // Simulamos la demora y luego creamos un resultado ficticio
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Cierra el diálogo de carga

      final simulatedMatch = RekognitionMatch(
        faceId: 'demo-face-id',
        externalImageId:
            'demo.jpg', // debe existir en tu bucket si quieres que se vea
        confidence: 50,
      );

      final person = PersonData(
        name: 'Josue Cartagena',
        age: 34,
        disappearanceDate: '12/03/2024',
        placeLastSeen: 'Callao, Lima',
        imageUrl:
            'https://encuentreme-bucket-rekognition/demo.jpg', // imagen visible públicamente
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PersonFoundedPage(
            topMatch: simulatedMatch,
            similarity: simulatedMatch.confidence / 100,
            person: person,
            additionalNote: note,
          ),
        ),
      );
    });
  }

  void _showPopup3(String note, List<RekognitionMatch> matches) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(),
                child: const Icon(Icons.close, size: 24),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text('RESULTADO',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Se encontraron ${matches.length} coincidencia(s).',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            // Botón Ciudadano
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  _showPopup4(note);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Ciudadano'),
              ),
            ),
            const SizedBox(height: 8),
            // Botón Policía
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (matches.isNotEmpty) {
                    final top = matches.first;
                    final person = PersonData(
                      name: 'Nombre obtenido de tu DB',
                      age: 30,
                      disappearanceDate: '01/01/2024',
                      placeLastSeen: 'Ciudad X',
                      imageUrl:
                          'https://encuentreme-bucket-rekognition/${top.externalImageId}.jpg',
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PersonFoundedPage(
                          topMatch: top,
                          similarity: top.confidence / 100,
                          person: person,
                          additionalNote: note,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('No se encontró ninguna coincidencia')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Policía / Renipéd'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPopup4(String note) {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titlePadding: EdgeInsets.zero,
        title: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(ctx).pop();
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
              'Tu aporte será de gran ayuda.\nSe te notificará el progreso del caso.',
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
                  final uri = Uri(scheme: 'tel', path: '114');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  }
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ReportListPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
