import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SqlDb {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CERATE TABLE tutorial(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    title TEXT,
    createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)
    """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'dbteste.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  //insert
  static Future<int> insert(String title, String? description) async {
    final db = await SqlDb.db();

    final data = {'title': title, 'description': description};
    final id = await db.insert('tutorial', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  //mostra todos
  static Future<List<Map<String, dynamic>>> buscarTodos() async {
    final db = await SqlDb.db();
    return db.query('tutorial', orderBy: "id");
  }

  //busca por item
  static Future<List<Map<String, dynamic>>> buscarPorItem(int id) async {
    final db = await SqlDb.db();
    return db.query('tutorial', where: "id = ?", whereArgs: [id], limit: 1);
  }

  //update
  static Future<int> atualizaItem(
      int id, String title, String? description) async {
    final db = await SqlDb.db();

    final data = {
      'title': title,
      'description': description,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('tutorial', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  //delete
  static Future<void> deleteItem(int id) async {
    final db = await SqlDb.db();
    try {
      await db.delete("tutorial", where: "Id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Algo deu errado na exclusão do item: $err ");
    }
  }
}
