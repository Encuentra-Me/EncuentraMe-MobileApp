import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/utils/app_bar.dart';
import 'package:flutter/material.dart';
import 'notification_detail.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Ejemplo de notificaciones, luego se cambiara
  List<Map<String, dynamic>> notifications = [
    {
      'name': 'Albert Einstein',
      'coincidencePercentage': '98%',
      'tiempo': '10 min',
      'isNew': true,
    },
    {
      'name': 'Isaac Newton',
      'coincidencePercentage': '91%',
      'tiempo': '10 min',
      'isNew': true,
    },
    {
      'name': 'Isaac Newton',
      'coincidencePercentage': '91%',
      'tiempo': '10 min',
      'isNew': false,
    },
    {
      'name': 'Isaac Newton',
      'coincidencePercentage': '91%',
      'tiempo': '10 min',
      'isNew': false,
    },
  ];

  // Función para navegar a la vista de detalles
  void navigateToDetailPage(Map<String, dynamic> notification) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NotificationDetailPage(
          name: notification['name'],
          coincidencePercentage: notification['coincidencePercentage'],
        ),
      ),
    ).then((_) {
      // Después de regresar de la página de detalles, mover la notificación si es nueva
      setState(() {
        notification['isNew'] =
            false; // Cambiar el estado de la notificación a antigua
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: const AppbarEncuentraMe(title: 'EncuentraMe!'),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nuevas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Sección de Nuevas Notificaciones
          for (var notification in notifications)
            if (notification['isNew'])
              GestureDetector(
                onTap: () => navigateToDetailPage(notification),
                child: Card(
                  color: Colors.green,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'Se ha localizado a ${notification['name']} con una coincidencia del ${notification['coincidencePercentage']}%',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      'Hace ${notification['tiempo']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Anteriores',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Sección de Notificaciones Antiguas
          for (var notification in notifications)
            if (!notification['isNew'])
              GestureDetector(
                onTap: () => navigateToDetailPage(notification),
                child: Card(
                  color: Colors.green.shade200,
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: ListTile(
                    leading: Icon(Icons.person, color: Colors.white),
                    title: Text(
                      'Se ha localizado a ${notification['name']} con una coincidencia del ${notification['coincidencePercentage']}%',
                      style: TextStyle(color: Colors.black),
                    ),
                    subtitle: Text(
                      'Hace ${notification['tiempo']}',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
