import 'package:flutter/material.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/perfil.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String currentPage;

  const AppHeader({
    super.key,
    this.showBackButton = false,
    this.currentPage = '',
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.lightGreen,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              if (currentPage != 'reports') {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportListPage()),
                );
              }
            },
          ),
          const Text("EncuentraMe!", style: TextStyle(color: Colors.white)),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              if (currentPage != 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PerfilPage()),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
} 