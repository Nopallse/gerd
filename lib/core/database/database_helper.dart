import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/alarm_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Get the document directory path
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'gerd_care.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alarms (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        title TEXT NOT NULL,
        subtitle TEXT NOT NULL,
        time_hour INTEGER NOT NULL,
        time_minute INTEGER NOT NULL,
        description TEXT NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        days TEXT NOT NULL,
        icon_codepoint INTEGER NOT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      )
    ''');

    // Insert default alarms
    await _insertDefaultAlarms(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      // Handle database schema updates here
      // For now, we'll just recreate the table
      await db.execute('DROP TABLE IF EXISTS alarms');
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _insertDefaultAlarms(Database db) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Default meal alarm
    await db.insert('alarms', {
      'type': 'meal',
      'title': 'Sarapan',
      'subtitle': 'Waktu Makan',
      'time_hour': 7,
      'time_minute': 0,
      'description': 'Waktu sarapan sehat untuk penderita GERD',
      'is_active': 1,
      'days': 'Setiap hari',
      'icon_codepoint': 0xe57a, // Icons.restaurant
      'created_at': now,
    });

    // Default medicine alarm
    await db.insert('alarms', {
      'type': 'medicine',
      'title': 'Minum Obat PPI',
      'subtitle': 'Minum Obat',
      'time_hour': 6,
      'time_minute': 30,
      'description': 'Proton Pump Inhibitor sebelum sarapan',
      'is_active': 1,
      'days': 'Setiap hari',
      'icon_codepoint': 0xf04c9, // Icons.medication
      'created_at': now,
    });
  }

  // CRUD Operations for Alarms

  Future<int> insertAlarm(AlarmModel alarm) async {
    final db = await database;
    final alarmMap = alarm.toMap();
    alarmMap.remove('id'); // Remove id for insertion
    return await db.insert('alarms', alarmMap);
  }

  Future<List<AlarmModel>> getAllAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      orderBy: 'time_hour ASC, time_minute ASC',
    );

    return List.generate(maps.length, (i) {
      return AlarmModel.fromMap(maps[i]);
    });
  }

  Future<List<AlarmModel>> getActiveAlarms() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'time_hour ASC, time_minute ASC',
    );

    return List.generate(maps.length, (i) {
      return AlarmModel.fromMap(maps[i]);
    });
  }

  Future<AlarmModel?> getAlarmById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return AlarmModel.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateAlarm(AlarmModel alarm) async {
    final db = await database;
    final alarmMap = alarm.copyWith(
      updatedAt: DateTime.now(),
    ).toMap();
    
    return await db.update(
      'alarms',
      alarmMap,
      where: 'id = ?',
      whereArgs: [alarm.id],
    );
  }

  Future<int> deleteAlarm(int id) async {
    final db = await database;
    return await db.delete(
      'alarms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> toggleAlarmStatus(int id, bool isActive) async {
    final db = await database;
    return await db.update(
      'alarms',
      {
        'is_active': isActive ? 1 : 0,
        'updated_at': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Utility methods

  Future<int> getAlarmsCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM alarms'),
    );
    return count ?? 0;
  }

  Future<int> getActiveAlarmsCount() async {
    final db = await database;
    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM alarms WHERE is_active = 1'),
    );
    return count ?? 0;
  }

  Future<void> deleteAllAlarms() async {
    final db = await database;
    await db.delete('alarms');
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
