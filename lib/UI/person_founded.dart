import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/utils/bottom_bar.dart';
import 'package:encuentrame_app/UI/camera_view.dart';
import 'package:encuentrame_app/services/rekognition_http_service.dart';
import '../config.dart';

class PersonFoundedPage extends StatefulWidget {
  final RekognitionMatch topMatch;
  final String additionalNote;

  const PersonFoundedPage({
    Key? key,
    required this.topMatch,
    required this.additionalNote,
  }) : super(key: key);

  @override
  State<PersonFoundedPage> createState() => _PersonFoundedPageState();
}

class _PersonFoundedPageState extends State<PersonFoundedPage> {
  Map<String, dynamic>? report;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchReport();
  }

  Future<void> fetchReport() async {
    try {
      final response = await http.get(Uri.parse(
        '${AppConfig.baseUrl}/v1/reports/${widget.topMatch.externalId}',
      ));

      if (response.statusCode == 200) {
        setState(() {
          report = jsonDecode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (_) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final truncatedSimilarity =
        (widget.topMatch.similarity * 100).truncateToDouble() / 100;
    final percentText = '${truncatedSimilarity.toStringAsFixed(2)}%';
    final percentColor =
        widget.topMatch.similarity == 50 ? Colors.amber : Colors.green;

    return Scaffold(
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError || report == null
              ? const Center(child: Text('Error cargando los datos.'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 1. Coincidencia
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          child: Column(
                            children: [
                              const Text('Notificación de coincidencia',
                                  style: TextStyle(fontSize: 16)),
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

                      // 2. Datos personales + imagen
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Text(
                                        'Nombre: ${report!['name']} ${report!['lastName']}'),
                                    Text('Edad: ${report!['age']} años'),
                                    Text(
                                        'Desaparición: ${report!['lastSeen']}'),
                                    Text('Lugar: ${report!['placeLastSeen']}'),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 180,
                              child: PageView(
                                children: [
                                  if (report!['image1Url'] != null)
                                    Image.network(report!['image1Url'],
                                        fit: BoxFit.cover)
                                  else
                                    const Icon(Icons.image_not_supported,
                                        size: 64, color: Colors.grey),
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

                      // 3. Nota adicional
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text(widget.additionalNote.isNotEmpty
                                  ? widget.additionalNote
                                  : '—'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // 4. Mapa
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
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

                      // 5. Botón
                      Center(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Ubicado - 114',
                              style: TextStyle(color: Colors.white)),
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
