import 'package:flutter/material.dart';
import 'api_service.dart';

class PantallaFotoCompleta extends StatefulWidget {
  final Foto foto;

  const PantallaFotoCompleta({super.key, required this.foto});

  @override
  // ignore: library_private_types_in_public_api
  _PantallaFotoCompletaState createState() => _PantallaFotoCompletaState();
}

class _PantallaFotoCompletaState extends State<PantallaFotoCompleta> {
  bool _cargando = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Completa'),
      ),
      body: Center(
        child: Stack(
          children: [
            Image.network(
              widget.foto.urlCompleta,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  // Imagen cargada completamente
                  if (_cargando) {
                    // Solo actualiza el estado cuando sea seguro hacerlo
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        _cargando = false;
                      });
                    });
                  }
                  return child;
                } else {
                  // Mientras la imagen se está cargando
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                }
              },
              errorBuilder:
                  (BuildContext context, Object error, StackTrace? stackTrace) {
                return const Center(child: Text('Error al cargar imagen'));
              },
            ),
            if (_cargando)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
