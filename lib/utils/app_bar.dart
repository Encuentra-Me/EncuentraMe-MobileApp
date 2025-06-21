import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/notification.dart';
import 'package:encuentrame_app/UI/perfil.dart';

class AppbarEncuentraMe extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const AppbarEncuentraMe({
    super.key,
    required this.title,
  });
  //AppbarEncuentraMe({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  /*Widget build(BuildContext context) {
      return AppBar(
        backgroundColor: Colors.lightGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                //_loadReports();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportListPage()));
              },
            ),
            Text(title, style: TextStyle(color: Colors.white)),
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // aqui va al perfil
                //Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()));
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
      );
    }

    @override
    Size get preferredSize => Size.fromHeight(kToolbarHeight);*/

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 0,

      // Iconos blancos
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),

      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            // aqui va a las notificaciones
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => NotificationsPage()));
          },
        ),
        IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => PerfilPage()));
          },
        ),
      ],
    );
  }
}
