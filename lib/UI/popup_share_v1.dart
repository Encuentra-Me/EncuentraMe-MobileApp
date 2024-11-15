import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void sharePopUpV1(BuildContext context, String url) {
  print("Número de elementos URL: $url");

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.public),
                        onPressed: () async {
                          final Uri uri = Uri.parse(
                              url); // Convierte la URL en un objeto Uri

                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          } else {
                            throw 'No se pudo abrir $url';
                          }
                          Navigator.pop(context);
                        },
                      ),
                      Text("RENIPED"),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {
                          // Acción para compartir
                          Navigator.pop(context);
                        },
                      ),
                      Text("Compartir"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
