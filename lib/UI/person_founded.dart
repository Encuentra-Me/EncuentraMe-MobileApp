import 'package:flutter/material.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/utils/bottom_bar.dart';
import 'package:encuentrame_app/UI/camera_view.dart';
import 'package:encuentrame_app/services/rekognition_http_service.dart';

class PersonData {
  final String name;
  final int age;
  final String disappearanceDate;
  final String placeLastSeen;
  final String imageUrl;

  PersonData({
    required this.name,
    required this.age,
    required this.disappearanceDate,
    required this.placeLastSeen,
    required this.imageUrl,
  });
}

class PersonFoundedPage extends StatelessWidget {
  final RekognitionMatch topMatch;
  final PersonData person;
  final String additionalNote;
  final double similarity;

  const PersonFoundedPage({
    Key? key,
    required this.topMatch,
    required this.person,
    required this.additionalNote,
    required this.similarity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final percentText = '${(similarity * 100).toStringAsFixed(0)}%';
    final percentColor = (similarity * 100).toStringAsFixed(0) == '50'
        ? Colors.amber
        : Colors.green;

    return Scaffold(
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Card de coincidencia
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    const Text(
                      'Notificación de coincidencia',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      percentText,
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: percentColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Fila de datos e imagen
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Datos personales (izquierda)
                Expanded(
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Estado: Localizado',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          Text('Nombre: ${person.name}'),
                          Text('Edad: ${person.age} años'),
                          Text('Desaparición: ${person.disappearanceDate}'),
                          Text('Lugar: ${person.placeLastSeen}'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Imagen enviada (derecha)
                Expanded(
                  child: SizedBox(
                    height: 180,
                    child: PageView(
                      children: [
                        Image.asset(
                          'assets/images/demo.jpg',
                          fit: BoxFit.cover,
                        ),
                        const Icon(Icons.image_not_supported,
                            size: 64, color: Colors.grey),
                        const Icon(Icons.image_not_supported,
                            size: 64, color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 3. Nota adicional (ancho completo)
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Nota adicional',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(additionalNote.isNotEmpty ? additionalNote : '—'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 4. Mapa (como Card con imagen local)
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Text('Localizado en:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  Image.asset(
                    'assets/images/map.jpg',
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 5. Botón centrado
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Ubicado - 114',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomBottomBar.buildCameraFab(onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CameraView()),
        );
      }),
    );
  }
}
