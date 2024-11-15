import 'package:encuentrame_app/UI/reports_list.dart';
import 'package:encuentrame_app/UI/login.dart';
import 'package:flutter/material.dart';

void main() {
  /*WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [SystemUiOverlay.top],
  );*/
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EncuentraMe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: ReportListPage(),
      home: LoginPage(),
    );
  }
}
