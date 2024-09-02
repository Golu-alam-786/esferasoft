import 'package:esferasoft/model/note_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseController {
  static final DatabaseController instance = DatabaseController._init();
  static Database? _database;

  DatabaseController._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        content TEXT,
        category TEXT,
        image TEXT,
        created_At TEXT
      )
    ''');
  }

  Future<int> create(NotesModel note) async {
    final db = await instance.database;
    return await db.insert('notes', note.toJson());
  }

  Future<List<NotesModel>> readAllNotes() async {
    final db = await instance.database;
    final result = await db.query('notes');
    return result.map((json) => NotesModel.fromJson(json)).toList();
  }

  Future<int> update(NotesModel note) async {
    final db = await instance.database;
    return await db.update('notes', note.toJson(), where: 'id = ?', whereArgs: [note.id]);
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}
