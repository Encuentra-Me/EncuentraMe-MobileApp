import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/utils/db_helper_report.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as html_dom;

class AddReportProcess {
  final BuildContext context;
  final DbHelper _dbHelper = DbHelper();
  String? url;

  AddReportProcess({required this.context});

  // Método para iniciar el proceso de añadir reporte
  void startProcess() {
    _showPopup1();
  }

  // Pop-up 1: Validación del URL
  void _showPopup1() {
    TextEditingController urlController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("NOTA DE ALERTA"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Agregue el URL oficial"),
              TextField(
                controller: urlController,
                decoration: InputDecoration(
                  hintText:
                      "https://desaparecidosenperu.policia.gob.pe/Desaparecidos/nota_alerta_menor/...",
                ),
              ),
              Text(
                "*Nota: El URL debe ser de la página oficial del RENIPED, de lo contrario, no se validará.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                // Validar URL
                if (urlController.text.startsWith(
                    "https://desaparecidosenperu.policia.gob.pe/Desaparecidos/nota_alerta_menor/")) {
                  url = urlController.text;
                  Navigator.of(context).pop(); // Cerrar pop-up 1
                  _showPopup2(); // Ir al pop-up 2
                } else {
                  Navigator.of(context).pop();
                  _showPopup4(); // Mostrar error de URL incorrecta
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Pop-up 2: Agregar imágenes
  void _showPopup2() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("IMÁGENES ADICIONALES"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Agregue imágenes"),
              ElevatedButton(
                onPressed: () {},
                child: Text("Agregar Imagen"),
              ),
              Text(
                "*Nota: La imagen debe contener el rostro de la persona y ser lo más nítida posible, de lo contrario, no se agregará.",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar pop-up 2
                _showPopup3(); // Ir al pop-up 3
              },
            ),
          ],
        );
      },
    );
  }

  // Pop-up 3: Procesando y agregando a la base de datos
  void _showPopup3() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("PROCESANDO"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Esto puede tardar unos segundos"),
            ],
          ),
        );
      },
    );
    // Simular procesamiento y agregar a la base de datos
    await Future.delayed(Duration(seconds: 1));
    // Llamar a la función que obtiene los datos del URL
    try {
      final itemData = await fetchDataFromUrl(url!);
      if (itemData != null) {
        // Guardar en la base de datos
        await _dbHelper.addReport(
            itemData.name,
            itemData.lastName,
            itemData.status,
            itemData.age,
            itemData.bornCountry,
            itemData.lastSeen,
            itemData.placeLastSeen,
            itemData.url);
      }
    } catch (e) {
      print("Error al obtener datos: $e");
    }
    print("Número de elementos url: $url");

    Navigator.of(context).pop(); // Cerrar pop-up 3
    Navigator.of(context)
        .popUntil((route) => route.isFirst); // Regresar a inicio
  }

  // Función para obtener datos del URL
  Future<ReportMP?> fetchDataFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parsear el contenido HTML
        html_dom.Document document = html_parser.parse(response.body);

        // Buscar el contenedor principal con clase `detalle-desaparecidos-p1`
        //html_dom.Element? container = document.querySelector('p.detalle-desaparecidos-p1');

        // Buscar todos los elementos <p> con la clase `detalle-desaparecidos-p1`
        List<html_dom.Element> pElements =
            document.querySelectorAll('p.detalle-desaparecidos-p1');

        // Verificar que haya al menos dos elementos <p> y obtener el segundo
        if (pElements.length > 1) {
          html_dom.Element secondPElement =
              pElements[1]; // El segundo elemento <p>

          // Obtener todos los elementos <b> dentro del segundo <p>
          List<html_dom.Element> bElements =
              secondPElement.querySelectorAll('b');

          // Asegurarse de que haya suficientes elementos para acceder a las posiciones necesarias
          String? name = bElements.length > 3 ? bElements[3].text.trim() : null;
          String? lastName =
              bElements.length > 1 ? bElements[1].text.trim() : null;
          String? ageText =
              bElements.length > 5 ? bElements[5].text.trim() : null;
          String? bornCountry =
              bElements.length > 9 ? bElements[9].text.trim() : null;
          String? lastSeen =
              bElements.length > 11 ? bElements[11].text.trim() : null;
          String? placeLastSeen =
              bElements.length > 13 ? bElements[13].text.trim() : null;

          // Convertir la edad a un número si está en formato de texto
          //int age = int.tryParse(ageText ?? '0') ?? 0;

          // Imprimir la longitud de bElements para verificar cuántos elementos hay
          print("Número de elementos <b>: ${bElements.length}");

          // Imprimir los datos para ver si esta bien la info
          print("nombre: $name");
          print("apellido: $lastName");
          print("edad: $ageText");
          print("ciudad: $bornCountry");
          print("ultima ves visto: $lastSeen");
          print("ultimo lugar visto: $placeLastSeen");
          print("Número de elementos url: $url");

          // Verificar que todos los campos esenciales estén presentes
          if (name != null) {
            return ReportMP(
                name: name,
                lastName: lastName ?? "",
                status: "Desaparecido",
                age: ageText ?? "",
                bornCountry: bornCountry ?? "",
                lastSeen: lastSeen ?? "",
                placeLastSeen: placeLastSeen ?? "",
                url: url);
          } else {
            print("Datos incompletos en el HTML");
            return null;
          }
        } else {
          print("Contenedor no encontrado: ${response.statusCode}");
          return null;
        }
      } else {
        print("Error en la respuesta: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return null;
    }

    // Guardar en la base de datos
    //await _dbHelper.add(newItem.name, "Descripción de ejemplo");

    //Navigator.of(context).pop(); // Cerrar pop-up 3
    //Navigator.of(context).popUntil((route) => route.isFirst); // Regresar a inicio*/
  }

  // Función auxiliar para extraer texto de un selector en HTML
  String? _extractTextFromHtml(html_dom.Document document, String selector) {
    html_dom.Element? element = document.querySelector(selector);
    return element?.text.trim();
  }

  // Pop-up 4: URL incorrecta
  void _showPopup4() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("NO SE PUDO REGISTRAR"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error, size: 48, color: Colors.red),
              SizedBox(height: 16),
              Text("No se pudo registrar. Por favor, inténtelo nuevamente."),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
