import 'package:flutter/material.dart';
import 'database_helper.dart';

class ListaTareas extends StatefulWidget {
  const ListaTareas({super.key});
  static const routeNameListaTareas = 'lista_tareas_page';

  @override
  State<ListaTareas> createState() => _EstadoListaTareas();
}

class _EstadoListaTareas extends State<ListaTareas> {
  late DatabaseHelper _dbHelper;
  List<Tarea> _tareas = [];
  final TextEditingController _controladorTarea = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _cargarTareas();
  }

  void _cargarTareas() async {
    final tareas = await _dbHelper.tareas();
    setState(() {
      _tareas = tareas;
    });
  }

  void _cambiarEstadoTarea(int indice) async {
    setState(() {
      _tareas[indice].estaCompleta = !_tareas[indice].estaCompleta;
    });
    await _dbHelper
        .insertTarea(_tareas[indice]); // Actualiza la tarea en la base de datos
    _cargarTareas(); // Recarga la lista de tareas desde la base de datos
  }

  void _agregarTarea() async {
    final tituloTarea = _controladorTarea.text;
    if (tituloTarea.isNotEmpty) {
      final nuevaTarea = Tarea(titulo: tituloTarea);
      await _dbHelper
          .insertTarea(nuevaTarea); // Inserta la tarea en la base de datos
      _cargarTareas(); // Recarga la lista de tareas desde la base de datos
      _controladorTarea.clear();
    }
  }

  void _eliminarTareasCompletas(int? id) async {
    await _dbHelper.deleteTareaPorId(id!); // Elimina la tarea por ID
    _cargarTareas(); // Recarga la lista de tareas desde la base de datos
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: _controladorTarea,
              decoration: const InputDecoration(
                labelText: 'Nueva tarea',
                border: OutlineInputBorder(),
              ),
              onFieldSubmitted: (_) => _agregarTarea(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tareas.length,
              itemBuilder: (context, index) {
                final tarea = _tareas[index];
                return ListTile(
                  leading: Checkbox(
                    value: tarea.estaCompleta,
                    onChanged: (bool? valor) {
                      _cambiarEstadoTarea(index);
                    },
                  ),
                  title: Text(tarea.titulo),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _eliminarTareasCompletas(tarea.id);
                    },
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
