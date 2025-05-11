import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import 'package:encuentrame_app/utils/db_helper_report.dart';
import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/UI/reports_details.dart';
import 'package:encuentrame_app/UI/popups.dart';
import 'package:encuentrame_app/UI/popup_share_v1.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:encuentrame_app/utils/bottom_bar.dart';
import 'package:encuentrame_app/UI/notification.dart';
import 'package:encuentrame_app/components/app_header.dart';
//import 'package:encuentrame_app/UI/Camera_Capture.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  _ReportListPage createState() => _ReportListPage();
}

class _ReportListPage extends State<ReportListPage> {
  final DbHelper _dbHelper = DbHelper();
  List<ReportMP> _reportsMP = [];
  String _selectedGroup = 'menores'; // 'adultos' o 'menores'
  String _searchQuery = '';

  // ── AUXILIAR: carga desde JSON
  Future<List<ReportMP>> _loadReportsFromJson(String filename) async {
    final jsonStr = await rootBundle.loadString('assets/$filename.json');
    final List<dynamic> jsonList = json.decode(jsonStr);
    return jsonList
        .map((item) => ReportMP.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // ── AUXILIAR: llena BD si está vacía
  Future<void> _seedDatabase() async {
    final existing = await _dbHelper.getReports();
    if (existing.isEmpty) {
      //final jsonList = await _loadReportsFromJson('menores');

      // 1) Sembrar menores.json
      final minors = await _loadReportsFromJson('menores');
      for (var r in minors) {
        await _dbHelper.addReport(
          name: r.name,
          lastName: r.lastName,
          status: r.status,
          age: r.age.toString(),
          bornCountry: r.bornCountry,
          lastSeen: r.lastSeen,
          placeLastSeen: r.placeLastSeen,
          tez: r.tez,
          sangre: r.sangre,
          contextura: r.contextura,
          estatura: r.estatura,
          cabello: r.cabello,
          boca: r.boca,
          ojos: r.ojos,
          nariz: r.nariz,
          alertNoteUrl: r.alertNoteUrl,
          image1: r.image1,
        );
      }
      // 2) Sembrar adultos.json
      final adults = await _loadReportsFromJson('adultos');
      for (var r in adults) {
        await _dbHelper.addReport(
          name: r.name,
          lastName: r.lastName,
          status: r.status,
          age: r.age.toString(),
          bornCountry: r.bornCountry,
          lastSeen: r.lastSeen,
          placeLastSeen: r.placeLastSeen,
          tez: r.tez,
          sangre: r.sangre,
          contextura: r.contextura,
          estatura: r.estatura,
          cabello: r.cabello,
          boca: r.boca,
          ojos: r.ojos,
          nariz: r.nariz,
          alertNoteUrl: r.alertNoteUrl,
          image1: r.image1,
        );
      }
    }
  }

  // Método para cargar los elementos desde la base de datos
  Future<void> _loadReportsFromDb() async {
    final reports = await _dbHelper.getReports();
    setState(() {
      _reportsMP = reports.map((e) => ReportMP.fromMap(e)).toList();
    });

    print("Número de elementos <b>: ${_reportsMP.length}");
  }

  @override
  void initState() {
    super.initState();
    //_addInitialReport(); // Agrega un valor a la DB antes de cargar los reportes
    //_loadReportsFromDb();
    _seedDatabase().then((_) => _loadReportsFromDb());
  }

  bool isSaved = false;

  void _toggleSave() {
    setState(() {
      isSaved = !isSaved; // Cambia el estado
    });

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
      final age = int.tryParse(r.age) ?? 0;
      final inGroup = _selectedGroup == 'adultos' ? age >= 18 : age < 18;
      final query = _searchQuery.toLowerCase();
      final matchesSearch = r.name.toLowerCase().contains(query) ||
          r.lastName.toLowerCase().contains(query);
      return inGroup && matchesSearch;
    }).toList();

    return Scaffold(
      //AppBar: Home - EncuentraMe! - User
      /*appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _loadReportsFromDb();
              },
            ),
            const Text("EncuentraMe!", style: TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // aqui va al perfil
              },
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Buscar",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),*/
      //appBar: AppHeader(currentPage: 'reports'),
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
                          ? Colors.grey.shade300
                          : const Color(0xFF2E7D32),
                    ),
                    onPressed: () {
                      setState(() => _selectedGroup = 'menores');
                    },
                    child: Text(
                      '0–17 años',
                      style: TextStyle(
                        color: _selectedGroup == 'menores'
                            ? Colors.black
                            : Colors.white,
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
                            child: reportmp.image1 != null
                                ? Image.network(
                                    reportmp.image1!,
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
      /*body: ListView.builder(
        itemCount: _reportsMP.length,
        itemBuilder: (context, index) {
          final reportmp = _reportsMP[index];
          return GestureDetector(
            onTap: () {
              // Navegar a la pantalla de detalles pasando el item seleccionado
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportDetailPage(reportMP: reportmp),
                ),
              );
            },
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto del desaparecido
                    /*ClipRRect(

                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/profile_placeholder.jpg',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),*/

                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: reportmp.image1 != null
                          ? Image.network(
                              reportmp.image1!,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              // Si la URL falla, muestra el placeholder:
                              errorBuilder: (_, __, ___) => _placeholderImage(),
                            )
                          : _placeholderImage(),
                    ),

                    const SizedBox(width: 16),
                    // Información del desaparecido
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

                    // Ícono de marcador y opciones
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            isSaved ? Icons.bookmark : Icons.bookmark_border,
                            color: isSaved ? Colors.cyan : null,
                          ),
                          onPressed: () {
                            // Acción para guardar como favorito

                            setState(() {
                              isSaved = !isSaved; // Cambia el estado
                            });
                          },
                        ),
                        IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              sharePopUpV1(context, reportmp.alertNoteUrl);
                            }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      */
      // Bottom: Notificacion - Camera - Add report
      /*bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: SizedBox(
            height: 60.0,
            //child: Padding(
            //padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            //child: Padding(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications),
                      iconSize: 40.0,
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NotificationsPage()));
                      },
                    ),
                    //const Text("Notificación"),
                  ],
                ),

                const SizedBox(
                  width: 60,
                  height: 80,
                ), // Espacio para el botón de la cámara

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add),
                      iconSize: 40.0,
                      onPressed: () {
                        AddReportProcess(context: context).startProcess();
                        //print("Agregar Reporte presionado");
                      },
                    ),
                    //Text("Agregar Reporte"),
                  ],
                ),
              ],
            ),
          )),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print("Cámara presionada");

          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CameraCapturePage()),
          );
        },
        backgroundColor: Colors.lightGreen,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt,
          size: 40.0,
          color: Colors.white,
        ),
      ),
    */

      bottomNavigationBar: const CustomBottomBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CustomBottomBar.buildCameraFab(
        onPressed: () {
          // Aquí va la acción de reconocimiento facial
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
