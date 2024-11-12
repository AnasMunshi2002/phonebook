import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../models/contact/person.dart';

class BinDB {
  static final BinDB instance = BinDB._internal();

  factory BinDB() => instance;

  BinDB._internal();

  Database? _database;
  final String dbName = "bin.db";
  final String table = "contacts";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initBinDatabase();
    return _database!;
  }

  Future<Database> initBinDatabase() async {
    String path = join(await getDatabasesPath(), dbName);
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('CREATE TABLE $table'
            '(id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,'
            'image TEXT,'
            'prefix TEXT,'
            'firstname TEXT,'
            'lastname TEXT,'
            'favourite BOOLEAN,'
            'blocked BOOLEAN,'
            'phone TEXT,'
            'email TEXT,'
            'birthday TEXT,'
            'addDate TEXT,'
            'address TEXT);');
      },
      version: 1,
    );
  }

  Future<int> addContact(Person person) async {
    int value = await _database!.insert(table, person.toMap());
    return value;
  }

  Future<List<Person>> getAllBin() async {
    List<Map<String, dynamic>> map = [];
    List<Person> list = [];
    try {
      var db = await instance.database;
      map = await db.query(table);
      list = List.generate(
          map.length,
          (index) => Person(
                id: map[index]['id'],
                prefix: map[index]['prefix'],
                image: map[index]['image'],
                firstname: map[index]['firstname'],
                lastname: map[index]['lastname'],
                fav: map[index]['favourite'] == 1 ? true : false,
                birthday: map[index]['birthday'],
                blocked: map[index]['blocked'] == 1 ? true : false,
                addDate: map[index]['addDate'],
                phone: map[index]['phone'],
                email: map[index]['email'],
                address: map[index]['address'],
              ));
    } catch (e) {
      return [];
    }
    return list;
  }

  Future<int> removeOne(Person person) async {
    int result = await _database!
        .delete(table, where: "phone=?", whereArgs: [person.phone]);
    return result;
  }

  Future<int> empty() async {
    int result = await _database!.delete(table);
    return result;
  }
}
