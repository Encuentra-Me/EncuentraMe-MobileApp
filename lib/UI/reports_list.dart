import 'package:encuentrame_app/utils/db_helper_report.dart';
import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/UI/reports_details.dart';
import 'package:encuentrame_app/UI/popups.dart';
import 'package:encuentrame_app/UI/popup_share_v1.dart';
import 'package:encuentrame_app/UI/notification.dart';
import 'package:flutter/material.dart';

class ReportListPage extends StatefulWidget {
  const ReportListPage({super.key});

  @override
  _ReportListPage createState() => _ReportListPage();
}

class _ReportListPage extends State<ReportListPage> {
  final DbHelper _dbHelper = DbHelper();
  List<ReportMP> _reportsMP = [];

  @override
  void initState() {
    super.initState();
    //_addInitialReport(); // Agrega un valor a la DB antes de cargar los reportes
    _loadReports();
  }

  // Función para agregar un valor inicial a la base de datos
  /*Future<void> _addInitialReport() async {
    await _dbHelper.addReport('Josue A.', 'Cartagena Quipas', 'Desaparecido',
        '28', 'Peru', '21/12/2024', 'Lima');
  }*/

  // Método para cargar los elementos desde la base de datos
  Future<void> _loadReports() async {
    final reports = await _dbHelper.getReports();
    setState(() {
      _reportsMP = reports.map((e) => ReportMP.fromMap(e)).toList();
    });

    print("Número de elementos <b>: ${_reportsMP.length}");
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
    return Scaffold(
      //AppBar: Home - EncuentraMe! - User
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                _loadReports();
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
      ),

      // Body: Lista de Reportes de desaparecidos
      body: ListView.builder(
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
                      child: Container(
                        width: 60,
                        height: 60,
                        color: Colors
                            .grey.shade200, // Color de fondo del contenedor
                        child: Icon(
                          Icons.person,
                          size: 40, // Tamaño del icono dentro del contenedor
                          color: Colors.grey,
                        ),
                      ),
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
                              sharePopUpV1(context, reportmp.url);
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

      // Bottom: Notificacion - Camera - Add report
      bottomNavigationBar: BottomAppBar(
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
        },
        backgroundColor: Colors.lightGreen,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.camera_alt,
          size: 40.0,
          color: Colors.white,
        ),
      ),
    );
  }
}
