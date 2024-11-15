import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/UI/popups.dart';
import 'package:flutter/material.dart';

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
    print("Número de elementos url: ${reportMP.url}");

    // TODO: implement build
    return Scaffold(
      // Cabecera *es un beta
      appBar: AppBar(
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
      ),

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
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/profile_placeholder.png'),
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ${reportMP.propiedad}
                          Text("Tez: "),
                          Text("Sangre: "),
                          Text("Contextura: "),
                          Text("Estatura: m"),
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
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Cabello: "),
                          Text("Boca: "),
                          Text("Ojos: "),
                          Text("Nariz: "),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildPictureBox(),
                _buildPictureBox(),
                _buildPictureBox(),
              ],
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

  Widget _buildPictureBox() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: SizedBox(
        width: 80,
        height: 80,
        child: const Center(
          child: Text("Picture"),
        ),
      ),
    );
  }
}
