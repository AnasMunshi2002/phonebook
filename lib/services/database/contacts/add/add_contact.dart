import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../models/contact/person.dart';

class DBManager {
  static final DBManager instance = DBManager._internal();

  factory DBManager() => instance;

  DBManager._internal();

  Database? _database;
  final String dbName = "contacts.db";
  final String table = "contacts";

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
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

  Future<List<Person>> getAllContacts() async {
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

  Future<int> addContact(Person person) async {
    int value = await _database!.insert(table, person.toMap());
    return value;
  }

  Future<int> deleteContact(Person person) async {
    int result = await _database!
        .delete(table, where: "phone =?", whereArgs: [person.phone]);
    return result;
  }

  Future<int> updateContact(Person person) async {
    int result = await _database!
        .update(table, person.toMap(), where: "id=?", whereArgs: [person.id]);
    return result;
  }

  Future<int> toggleBlock(Person person, bool bool) async {
    int result = await _database!.update(table, {"blocked": bool ? 1 : 0},
        where: "id=?", whereArgs: [person.id]);
    return result;
  }

  Future<int> toggleFav(Person person, bool bool) async {
    int result = await _database!.update(table, {"favourite": bool ? 1 : 0},
        where: "id=?", whereArgs: [person.id]);
    return result;
  }
}
