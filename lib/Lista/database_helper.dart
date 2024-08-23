import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Define la estructura de la base de datos
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'tareas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tareas(id INTEGER PRIMARY KEY AUTOINCREMENT, titulo TEXT, estaCompleta INTEGER)',
        );
      },
    );
  }

  Future<void> insertTarea(Tarea tarea) async {
    final db = await database;
    await db.insert(
      'tareas',
      tarea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Tarea>> tareas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('tareas');

    return List.generate(maps.length, (i) {
      return Tarea.fromMap(maps[i]);
    });
  }

  Future<void> deleteTareaPorId(int id) async {
    final db = await database;
    await db.delete(
      'tareas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

class Tarea {
  int? id;
  String titulo;
  bool estaCompleta;

  Tarea({this.id, required this.titulo, this.estaCompleta = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'estaCompleta': estaCompleta ? 1 : 0,
    };
  }

  factory Tarea.fromMap(Map<String, dynamic> map) {
    return Tarea(
      id: map['id'],
      titulo: map['titulo'],
      estaCompleta: map['estaCompleta'] == 1,
    );
  }
}
