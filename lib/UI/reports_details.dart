import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/UI/popups.dart';
import 'package:flutter/material.dart';
import 'package:encuentrame_app/utils/app_bar.dart';

class ReportDetailPage extends StatelessWidget {
  final ReportMP reportMP;

  // Constructor que recibe el item seleccionado
  const ReportDetailPage({super.key, required this.reportMP});

  @override
  Widget build(BuildContext context) {
    // pruebas para ver la informacion obtenida era correcta
    print("Número de elementos <b>: ${reportMP.name}");
    print("nombre: ${reportMP.lastName}");
    print("apellido: ${reportMP.lastName}");
    print("edad: ${reportMP.age}");
    print("ciudad: ${reportMP.bornCountry}");
    print("ultima ves visto: ${reportMP.lastSeen}");
    print("ultimo lugar visto: ${reportMP.placeLastSeen}");
    print("Número de elementos url: ${reportMP.alertNoteUrl}");

    // TODO: implement build
    return Scaffold(
      // Cabecera *es un beta
      /*appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Desaparecido", style: TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // aqui va al perfil
              },
            ),
          ],
        ),
      ),*/
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),

      // Body: Detalle de la carta
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card con la información principal (nombre, estado, edad, país, etc.)
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Foto del desaparecido
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: reportMP.image1 != null
                          ? NetworkImage(reportMP.image1!)
                          : const AssetImage('assets/profile_placeholder.png')
                              as ImageProvider,
                      onBackgroundImageError: (_, __) {},
                    ),
                    const SizedBox(width: 16),
                    // Informacion Personal
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reportMP.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text('Estado: ${reportMP.status}'),
                        Text('Edad: ${reportMP.age}'),
                        Text('País de nacimiento: ${reportMP.bornCountry}'),
                        Text('Fecha del hecho: ${reportMP.lastSeen}'),
                        Text('Lugar del hecho: ${reportMP.placeLastSeen}'),
                      ],
                    )),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Características físicas en un Card

            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ${reportMP.propiedad}
                          Text("Tez: ${reportMP.tez ?? 'N/A'}"),
                          Text("Sangre: ${reportMP.sangre ?? 'N/A'}"),
                          Text("Contextura: ${reportMP.contextura ?? 'N/A'}"),
                          Text("Estatura: ${reportMP.estatura ?? 'N/A'}"),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cabello: ${reportMP.cabello ?? 'N/A'}"),
                          Text("Boca: ${reportMP.boca ?? 'N/A'}"),
                          Text("Ojos: ${reportMP.ojos ?? 'N/A'}"),
                          Text("Nariz: ${reportMP.nariz ?? 'N/A'}"),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Observaciones en un Card

            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Observaciones",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    //Text(item.observations ?? "No hay observaciones disponibles"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Galería de fotos en un Row
            // === Galería de fotos (aquí solo tienes image1, puedes duplicar si hay más) ===
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: SizedBox(
                height: 200,
                child: reportMP.image1 != null
                    ? Image.network(reportMP.image1!, fit: BoxFit.cover)
                    : Center(child: Text("Sin imagen disponible")),
              ),
            ),
          ],
        ),
      ),

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
                      onPressed: () {},
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
