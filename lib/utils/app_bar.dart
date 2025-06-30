import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/notification.dart';
import 'package:encuentrame_app/UI/perfil.dart';

class AppbarEncuentraMe extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isProfilePage;
  final bool isNotificationsPage;

  const AppbarEncuentraMe({
    super.key,
    required this.title,
    this.isProfilePage = false,
    this.isNotificationsPage = false
  });
  //AppbarEncuentraMe({Key? key, required this.title}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF2E7D32),
      elevation: 0,

      // Iconos blancos
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),

      title: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportListPage()));
        },
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          icon: Icon(isNotificationsPage ? Icons.home: Icons.notifications_none),
          onPressed: () {

            if(isNotificationsPage){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportListPage()));
            }else{
                Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage()));
            }
          },
        ),
        IconButton(
          icon: Icon(isProfilePage ? Icons.home : Icons.person),
          onPressed: () {
            if (isProfilePage) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportListPage()));
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const PerfilPage()));
            }
          },
        ),
      ],
    );
  }
}
