import 'dart:convert';
import 'package:http/http.dart' as http;

import '../env.dart';

Future<List<Foto>> buscarFotos(String terminoBusqueda) async {
  final url = Uri.parse(
      '${Env.baseUrl}?query=$terminoBusqueda&client_id=${Env.apiKey}');
  final respuesta = await http.get(url);
  if (respuesta.statusCode == 200) {
    final Map<String, dynamic> datos = jsonDecode(respuesta.body);
    final List<dynamic> resultados = datos['results'];
    return resultados.map((json) => Foto.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar fotos');
  }
}

class Foto {
  final String urlMiniatura;
  final String urlCompleta;
  final String titulo;

  Foto(
      {required this.urlMiniatura,
      required this.urlCompleta,
      required this.titulo});

  factory Foto.fromJson(Map<String, dynamic> json) {
    return Foto(
      urlMiniatura: json['urls']['thumb'],
      urlCompleta: json['urls']['full'],
      titulo: json['alt_description'] ?? 'Sin descripción',
    );
  }
}
