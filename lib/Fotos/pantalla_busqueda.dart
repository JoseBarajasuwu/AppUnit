import 'package:flutter/material.dart';
import 'api_service.dart';
import 'pantalla_foto_completa.dart';

class PantallaBusqueda extends StatefulWidget {
  @override
  _PantallaBusquedaState createState() => _PantallaBusquedaState();
}

class _PantallaBusquedaState extends State<PantallaBusqueda> {
  final TextEditingController _controladorBusqueda = TextEditingController();
  List<Foto> _resultados = [];
  bool _cargando = false;

  void _buscarFotos() async {
    setState(() {
      _cargando = true;
    });
    try {
      final resultados = await buscarFotos(_controladorBusqueda.text);
      setState(() {
        _resultados = resultados;
        _cargando = false;
      });
    } catch (e) {
      setState(() {
        _cargando = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buscar Fotos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controladorBusqueda,
              decoration: const InputDecoration(
                labelText: 'Buscar',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _buscarFotos(),
            ),
          ),
          if (_cargando)
            const CircularProgressIndicator()
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _resultados.length,
                itemBuilder: (context, index) {
                  final foto = _resultados[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PantallaFotoCompleta(foto: foto),
                        ),
                      );
                    },
                    child: GridTile(
                      child:
                          Image.network(foto.urlMiniatura, fit: BoxFit.cover),
                      footer: GridTileBar(
                        backgroundColor: Colors.black54,
                        title: Text(
                          foto.titulo,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.fullscreen),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PantallaFotoCompleta(foto: foto),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
