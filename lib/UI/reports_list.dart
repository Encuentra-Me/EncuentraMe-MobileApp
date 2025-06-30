//import 'dart:convert';
//import 'package:flutter/services.dart' show rootBundle;

//import 'package:encuentrame_app/utils/db_helper_report.dart';
import 'package:encuentrame_app/services/report_api_service.dart';
import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/UI/reports_details.dart';
//import 'package:encuentrame_app/UI/popups.dart';
import 'package:encuentrame_app/UI/popup_share_v1.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/utils/bottom_bar.dart';
//import 'package:encuentrame_app/UI/notification.dart';
import 'package:encuentrame_app/UI/camera_view.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  _ReportListPage createState() => _ReportListPage();
}

class _ReportListPage extends State<ReportListPage> {
  //final DbHelper _dbHelper = DbHelper();
  final ReportApiService _apiService = ReportApiService();
  List<ReportMP> _reportsMP = [];
  String _selectedGroup = 'menores'; // 'adultos' o 'menores'
  String _searchQuery = '';
  bool isSaved = false;

  @override
  void initState() {
    super.initState();
    //_addInitialReport(); // Agrega un valor a la DB antes de cargar los reportes
    //_loadReportsFromDb();
    //_seedDatabase().then((_) => _loadReportsFromDb());
    _fetchReports();
  }
  
  Future<void> _fetchReports() async {
    try {
      final reports = await _apiService.getAllReports();
      setState(() => _reportsMP = reports);
    } catch (e) {
      print('Error al cargar reportes: $e');
    }
  }

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved;
    }); // Cambia el estado

    // Muestra un SnackBar
    final snackBar = SnackBar(
      content: Text(isSaved ? 'Guardado' : 'No guardado'),
      duration: Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    // Genera la lista filtrada según grupo y búsqueda
    final displayed = _reportsMP.where((r) {
      final inGroup = _selectedGroup == 'adultos' ? r.age >= 18 : r.age < 18;
      final query = _searchQuery.toLowerCase();
      final matchesSearch = r.name.toLowerCase().contains(query) ||
          r.lastName.toLowerCase().contains(query);
      return inGroup && matchesSearch;
    }).toList();


    return Scaffold(
      //AppBar: EncuentraMe! - User
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),

      // Body: Lista de Reportes de desaparecidos
      body: Column(
        children: [
          // 1) Selector de grupo etario
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedGroup == 'menores'
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade300,
                    ),
                    onPressed: () {
                      setState(() => _selectedGroup = 'menores');
                    },
                    child: Text(
                      '0–17 años',
                      style: TextStyle(
                        color: _selectedGroup == 'menores'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedGroup == 'adultos'
                          ? const Color(0xFF2E7D32)
                          : Colors.grey.shade300,
                    ),
                    onPressed: () {
                      setState(() => _selectedGroup = 'adultos');
                    },
                    child: Text(
                      '18 años a más',
                      style: TextStyle(
                        color: _selectedGroup == 'adultos'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 2) Campo de búsqueda
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Buscar',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (text) => setState(() => _searchQuery = text),
            ),
          ),

          // 3) Contador de resultados
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text('${displayed.length} resultados'),
          ),

          // 4) Listado
          Expanded(
            child: ListView.builder(
              itemCount: displayed.length,
              itemBuilder: (context, index) {
                final reportmp = displayed[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ReportDetailPage(reportMP: reportmp),
                      ),
                    );
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: reportmp.image1Url != null
                                ? Image.network(
                                    reportmp.image1Url!,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) =>
                                        _placeholderImage(),
                                  )
                                : _placeholderImage(),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nombre: ${reportmp.name}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Edad: ${reportmp.age} años',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fecha del hecho: ${reportmp.lastSeen}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Lugar del hecho: ${reportmp.placeLastSeen}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                icon: Icon(
                                  isSaved
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                  color: isSaved ? Colors.cyan : null,
                                ),
                                onPressed: _toggleSave,
                              ),
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () => sharePopUpV1(
                                    context, reportmp.alertNoteUrl),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // Bottom:
      bottomNavigationBar: const CustomBottomBar(),
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

  // Métodos auxiliares al final de la clase:
  Widget _placeholderImage() {
    return Container(
      width: 60,
      height: 60,
      color: Colors.grey.shade200,
      child: Icon(
        Icons.person,
        size: 40,
        color: Colors.grey,
      ),
    );
  }
}
