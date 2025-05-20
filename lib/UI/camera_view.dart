import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/UI/camera_popups.dart';

class CameraView extends StatefulWidget {
  const CameraView({Key? key}) : super(key: key);

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  final ImagePicker _picker = ImagePicker();

  // Aquí guardamos las rutas de todas las imágenes (cámara + galería)
  final List<String> _imagePaths = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras.first,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // Toma una foto y la añade al carousel
  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    final XFile file = await _controller!.takePicture();
    setState(() {
      _imagePaths.add(file.path);
    });
  }

  // Selecciona múltiples imágenes de la galería
  Future<void> _pickFromGallery() async {
    final List<XFile>? files = await _picker.pickMultiImage();
    if (files != null && files.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(files.map((f) => f.path));
      });
    }
  }

  // Al presionar "siguiente", mostramos la cadena de popups
  void _onNextPressed() {
    if (_imagePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debe tomar o escoger al menos una foto')),
      );
      return;
    }
    CameraPopupProcess(
      context: context,
      imagePaths: _imagePaths,
    ).startProcess();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller!);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),

      // Carousel de miniaturas justo encima del BottomAppBar
      bottomSheet: _imagePaths.isEmpty
          ? const SizedBox(height: 0)
          : SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _imagePaths.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_imagePaths[i]),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Botón para eliminar la miniatura
                        Positioned(
                          top: -4,
                          right: -4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _imagePaths.removeAt(i));
                            },
                            child: const Icon(Icons.close,
                                size: 18, color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

      bottomNavigationBar: BottomAppBar(
        elevation: 8,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón galería
              IconButton(
                icon: const Icon(Icons.photo_library, size: 30),
                onPressed: _pickFromGallery,
              ),

              // Botón cámara central
              FloatingActionButton(
                onPressed: _takePicture,
                backgroundColor: const Color(0xFF2E7D32),
                child:
                    const Icon(Icons.camera_alt, size: 32, color: Colors.white),
              ),

              // Botón siguiente
              IconButton(
                icon: const Icon(Icons.arrow_forward, size: 30),
                onPressed: _onNextPressed,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
