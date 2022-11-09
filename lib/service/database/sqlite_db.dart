import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:user_profile/service/model/user_details.dart';

class TransactionDetailDataBase {
  static final TransactionDetailDataBase instance =
      TransactionDetailDataBase._init();

  static Database? _database;

  TransactionDetailDataBase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('transactionDetails.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableNotes ( 
  ${TableDetails.userId} $idType, 
  ${TableDetails.email} $textType,
  ${TableDetails.userName} $textType,
  ${TableDetails.password} $textType,
  ${TableDetails.imagePath} $textType,
  ${TableDetails.mobile} $textType 
  )
''');
  }

  Future<UserDetails> create(UserDetails note) async {
    final db = await instance.database;

    final id = await db.insert(tableNotes, note.toJson());
    return note.copy(userId: id);
  }

  Future<List<UserDetails>> readAllDocuments() async {
    final db = await instance.database;

    final result = await db.query(tableNotes);

    return result.map((json) => UserDetails.fromJson(json)).toList();
  }
}
