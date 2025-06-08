import 'dart:io';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/person_founded.dart';
import 'package:encuentrame_app/services/rekognition_http_service.dart';
import 'package:image/image.dart' as img;
import 'dart:convert';

class CameraPopupProcess {
  final BuildContext context;
  final List<String> imagePaths;

  CameraPopupProcess({
    required this.context,
    required this.imagePaths,
  });

  void startProcess() => _showPopup1();

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
                child: const Icon(Icons.close),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('NOTA ADICIONAL',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(ctx).pop(controller.text.trim()),
                child: const Icon(Icons.arrow_forward),
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
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (note != null) _showPopup2(note);
  }

  void _showPopup2(String note) async {
    print('[Popup2] Iniciando popup de procesamiento...');
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        title: Center(child: Text('PROCESANDO')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Estamos comparando la imagen...'),
          ],
        ),
      ),
    );

    final originalPath = imagePaths.first;
    final originalFile = File(originalPath);
    print('[Popup2] Ruta de imagen original: $originalPath');
    File imageToSend;

    try {
      imageToSend = await convertToJpegIfNeeded(originalFile);
      print('[Popup2] Imagen lista para enviar (path): ${imageToSend.path}');
    } catch (e) {
      Navigator.of(context).pop();
      final msg = 'Error al procesar la imagen: $e';
      print('[Popup2] ❌ $msg');
      _showError(msg);
      return;
    }

    try {
      print('[Popup2] Enviando imagen a Rekognition...');
      final matches = await RekognitionHttpService().searchFace(
        imageFile: imageToSend,
        collectionId: 'personas-desaparecidas',
      );
      print(
          '[Popup2] Respuesta de Rekognition recibida. Nº coincidencias: ${matches.length}');
      Navigator.of(context).pop();

      if (matches.isNotEmpty) {
        final top = matches.first;
        print(
            '[Popup2] Coincidencia principal -> externalId: ${top.externalId}, similarity: ${top.similarity}');
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => PersonFoundedPage(
            topMatch: top,
            additionalNote: note,
          ),
        ));
      } else {
        print('[Popup2] ❗ No se encontraron coincidencias');
        _showPopup3();
      }
    } catch (e) {
      Navigator.of(context).pop();
      String errorMessage = e.toString();
      print('[Popup2] ❌ Error detectado bruto: $errorMessage');

      // Intenta obtener el mensaje del backend si viene como JSON
      try {
        final err = e.toString();
        if (err.contains('{') && err.contains('message')) {
          final decoded = jsonDecode(err.replaceFirst('Exception: ', ''));
          errorMessage = decoded['message'] ?? err;
        }
      } catch (_) {
        // Ignora y deja el mensaje por defecto
      }

      if (errorMessage.contains('No se detectó')) {
        _showError(
          'No se detectó ningún rostro en la imagen. Asegúrate de que tu rostro esté visible y bien iluminado.',
        );
      } else if (errorMessage.contains('403')) {
        _showError(
          'Error de permisos al conectarse con el sistema de reconocimiento. Intenta nuevamente o contacta soporte.',
        );
      } else {
        _showError(
          'Ocurrió un error durante la comparación. Intenta con otra imagen o verifica tu conexión.',
        );
      }
    }
  }

  void _showPopup3() {
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
                child: const Icon(Icons.close),
              ),
            ),
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('GRACIAS !!',
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Tu aporte será de gran ayuda.\nSe te notificará el progreso del caso.',
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.call),
              label: const Text('Policía - Línea 114'),
              onPressed: () async {
                final uri = Uri(scheme: 'tel', path: '114');
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                }
                Navigator.of(ctx).pop();
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ReportListPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'))
        ],
      ),
    );
  }
}

Future<File> convertToJpegIfNeeded(File file) async {
  final extension = file.path.toLowerCase().split('.').last;
  print('[Convert] Formato de imagen detectado: .$extension');

  if (extension == 'jpg' || extension == 'jpeg') {
    print('[Convert] Imagen ya está en formato JPG, no se convierte.');
    return file;
  }

  final bytes = await file.readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) {
    print('[Convert] ❌ No se pudo decodificar la imagen.');
    throw Exception('No se pudo decodificar la imagen $extension');
  }

  final newPath = file.path.replaceAll(RegExp(r'\\.(heic|webp|png)\$'), '.jpg');
  final newFile = File(newPath);
  await newFile.writeAsBytes(img.encodeJpg(decoded, quality: 90));
  print('[Convert] Imagen convertida a JPG: ${newFile.path}');
  return newFile;
}
