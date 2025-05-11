import 'package:encuentrame_app/models/report.dart';
import 'package:encuentrame_app/utils/db_helper_report.dart';
import 'package:encuentrame_app/UI/reports_list.dart';
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
    bool isLoading = false;
    String? errorMessage;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
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
                    hintStyle: TextStyle(color: Colors.grey),
                    suffixIcon: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : null,
                  ),
                ),
                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
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
                onPressed: isLoading
                    ? null
                    : () async {
                        // Validar formato de URL
                        if (urlController.text.startsWith(
                            "https://desaparecidosenperu.policia.gob.pe/Desaparecidos/nota_alerta_menor/")) {
                          // Mostrar indicador de carga
                          setState(() {
                            isLoading = true;
                            errorMessage = null;
                          });

                          try {
                            // Verificar si la URL está activa
                            final response =
                                await http.get(Uri.parse(urlController.text));

                            print(
                                "============================ ${response.statusCode}");
                            if (response.statusCode == 200) {
                              // La URL es válida y está activa
                              url = urlController.text;
                              if (context.mounted)
                                Navigator.of(context).pop(); // Cerrar pop-up 1
                              _showPopup2(); // Ir al pop-up 2
                            } else {
                              // La URL no está activa
                              setState(() {
                                isLoading = false;
                                errorMessage =
                                    "El enlace no está activo. Por favor, verifique el URL e intente nuevamente.";
                              });
                            }
                          } catch (e) {
                            print("============================ $e");
                            // Error al verificar la URL
                            setState(() {
                              isLoading = false;
                              errorMessage =
                                  "Error al verificar el enlace. Por favor, intente nuevamente.";
                            });
                          }
                        } else {
                          // Formato de URL incorrecto
                          setState(() {
                            errorMessage =
                                "El formato del URL no es válido. Debe comenzar con 'https://desaparecidosenperu.policia.gob.pe/Desaparecidos/nota_alerta_menor/'";
                          });
                        }
                      },
              ),
            ],
          );
        });
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
        /*await _dbHelper.addReport(
            itemData.name,
            itemData.lastName,
            itemData.status,
            itemData.age,
            itemData.bornCountry,
            itemData.lastSeen,
            itemData.placeLastSeen,
            itemData.alertNoteUrl
            );*/
      }
    } catch (e) {
      print("Error al obtener datos: $e");
    }
    print("Número de elementos url: $url");

    Navigator.of(context).pop(); // Cerrar pop-up 3
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReportListPage())); // Regresar a inicio
  }

  // Función para obtener datos del URL
  Future<ReportMP?> fetchDataFromUrl(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parsear el contenido HTML
        html_dom.Document document = html_parser.parse(response.body);

        // Imprimir el HTML para depuración (comentado para producción)
        // print("HTML recibido: ${response.body}");

        // Buscar todos los elementos <p> con la clase `detalle-desaparecidos-p1`
        List<html_dom.Element> pElements =
            document.querySelectorAll('p.detalle-desaparecidos-p1');

        print("Número de elementos p encontrados: ${pElements.length}");

        // Verificar que haya al menos dos elementos <p> y obtener el segundo
        if (pElements.length > 1) {
          html_dom.Element secondPElement =
              pElements[1]; // El segundo elemento <p>

          // Obtener todos los elementos <b> dentro del segundo <p>
          List<html_dom.Element> bElements =
              secondPElement.querySelectorAll('b');

          print("Número de elementos <b> encontrados: ${bElements.length}");

          // Imprimir todos los elementos <b> para depuración
          for (int i = 0; i < bElements.length; i++) {
            print("Elemento <b> $i: ${bElements[i].text.trim()}");
          }

          // Extraer datos con índices más flexibles
          Map<String, String> extractedData = {};

          // Buscar patrones específicos en el texto
          for (int i = 0; i < bElements.length; i++) {
            String text = bElements[i].text.trim();

            // Buscar patrones para cada campo
            if (text.contains("NOMBRES:")) {
              extractedData["name"] = text.replaceAll("NOMBRES:", "").trim();
            } else if (text.contains("APELLIDOS:")) {
              extractedData["lastName"] =
                  text.replaceAll("APELLIDOS:", "").trim();
            } else if (text.contains("EDAD:")) {
              extractedData["age"] = text.replaceAll("EDAD:", "").trim();
            } else if (text.contains("LUGAR DE NACIMIENTO:")) {
              extractedData["bornCountry"] =
                  text.replaceAll("LUGAR DE NACIMIENTO:", "").trim();
            } else if (text.contains("FECHA DE DESAPARICIÓN:")) {
              extractedData["lastSeen"] =
                  text.replaceAll("FECHA DE DESAPARICIÓN:", "").trim();
            } else if (text.contains("LUGAR DE DESAPARICIÓN:")) {
              extractedData["placeLastSeen"] =
                  text.replaceAll("LUGAR DE DESAPARICIÓN:", "").trim();
            }
          }

          // Si no se encontraron datos con los patrones, intentar con índices fijos
          if (extractedData.isEmpty && bElements.length >= 14) {
            extractedData = {
              "name": bElements.length > 3 ? bElements[3].text.trim() : "",
              "lastName": bElements.length > 1 ? bElements[1].text.trim() : "",
              "age": bElements.length > 5 ? bElements[5].text.trim() : "",
              "bornCountry":
                  bElements.length > 9 ? bElements[9].text.trim() : "",
              "lastSeen":
                  bElements.length > 11 ? bElements[11].text.trim() : "",
              "placeLastSeen":
                  bElements.length > 13 ? bElements[13].text.trim() : "",
            };
          }

          // Imprimir los datos extraídos
          print("Datos extraídos: $extractedData");

          // Verificar que al menos el nombre esté presente
          if (extractedData["name"] != null &&
              extractedData["name"]!.isNotEmpty) {
            return ReportMP(
                name: extractedData["name"] ?? "",
                lastName: extractedData["lastName"] ?? "",
                status: "Desaparecido",
                age: extractedData["age"] ?? "",
                bornCountry: extractedData["bornCountry"] ?? "",
                lastSeen: extractedData["lastSeen"] ?? "",
                placeLastSeen: extractedData["placeLastSeen"] ?? "",
                alertNoteUrl: url);
          } else {
            print("No se pudo extraer el nombre del reporte");
            return null;
          }
        } else {
          print(
              "No se encontraron suficientes elementos <p> con la clase detalle-desaparecidos-p1");
          return null;
        }
      } else {
        print("Error en la respuesta HTTP: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error al procesar la URL: $e");
      return null;
    }
  }

  // Función auxiliar para extraer texto de un selector en HTML
  String? _extractTextFromHtml(html_dom.Document document, String selector) {
    html_dom.Element? element = document.querySelector(selector);
    return element?.text.trim();
  }
}
