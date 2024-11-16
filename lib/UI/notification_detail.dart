import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  final String name;
  final String coincidencePercentage;

  // Recibimos solo el nombre y la coincidencia como parámetros
  NotificationDetailPage({
    required this.name,
    required this.coincidencePercentage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportListPage()));
              },
            ),
            const Text("Coincidencia", style: TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // aqui va al perfil
              },
            ),
          ],
        ),
        /*bottom: PreferredSize(
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
        ),*/
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card de Coincidencia
              Container(
                width: double
                    .infinity, // Esto hace que la Card ocupe todo el ancho
                margin: EdgeInsets.only(bottom: 20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Notificación de coincidencia',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        Text(
                          coincidencePercentage,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              /*Card(
                margin: EdgeInsets.only(bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Notificación de coincidencia',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(height: 10),
                      Text(
                        coincidencePercentage,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
*/

              // Dos columnas de información
              Row(
                children: [
                  // Columna 1
                  Expanded(
                    child: Card(
                      margin: EdgeInsets.only(right: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Estado: Localizado'),
                            Text('Nombre: $name'),
                            Text('Edad: 25 años'),
                            Text('Desaparición: 08/09/2024'),
                            Text('Ubicación: Arequipa, Arequipa'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Columna 2
                  Expanded(
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.only(bottom: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Picture',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: Center(child: Text('Image')),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nota adicional:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                Text(
                                    'Se vio un carro de placa ARF-457 dejarlo en una esquina'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Card con imagen de ubicación (Mapa)
              Card(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Localizado en:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: Center(child: Text('Mapa de la ubicación')),
                      ),
                    ],
                  ),
                ),
              ),

              // Botón de llamada a la policía (Siempre visible)
              ElevatedButton.icon(
                onPressed: () {
                  // Acción para llamar a la policía
                },
                icon: Icon(Icons.phone),
                label: Text('Policía - Línea 114',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.lightGreen, // Color verde para el botón
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
