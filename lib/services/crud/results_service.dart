import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ResultsService {
  Database? _db;

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final res = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (res.isNotEmpty) {
      throw UserAlreadyExistsException();
    }

    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(
      id: userId,
      email: email,
    );
  }

  Future<DatabaseResult> createResult({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();

    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUserException();
    }

    const text = '';
    final resultId = await db.insert(resultTable, {
      userIdColumn: owner.id,
      textColumn: text,
    });

    final result = DatabaseResult(
      id: resultId,
      userId: owner.id,
      text: text,
    );

    return result;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();

    final res = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (res.isEmpty) {
      throw CouldNotFindUserException();
    } else {
      return DatabaseUser.fromRow(res.first);
    }
  }

  Future<DatabaseResult> getResult({required int id}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      resultTable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (results.isEmpty) {
      throw CouldNotFindResultException();
    } else {
      return DatabaseResult.fromRow(results.first);
    }
  }

  Future<Iterable<DatabaseResult>> getAllResults() async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(resultTable);

    return results.map((resultRow) => DatabaseResult.fromRow(resultRow));
  }

  Future<DatabaseResult> updateResult(
      {required DatabaseResult result, required String text}) async {
    final db = _getDatabaseOrThrow();

    await getResult(id: result.id);

    final updatesCount = await db.update(resultTable, {
      textColumn: text,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateResultException();
    } else {
      return await getResult(id: result.id);
    }
  }

  Future<int> deleteAllResults() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(resultTable);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if (deletedCount != 1) {
      throw CouldNotDeleteUserException();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createResultTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseResult {
  final int id;
  final int userId;
  final String text;

  DatabaseResult({
    required this.id,
    required this.userId,
    required this.text,
  });

  DatabaseResult.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String;
}

const dbName = 'results.db';
const resultTable = 'result';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';

const createUserTable = '''
  CREATE TABLE IF NOT EXISTS "user" (
    "id"	INTEGER NOT NULL,
    "email"	TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id" AUTOINCREMENT)
  );
''';

const createResultTable = '''
  CREATE TABLE IF NOT EXISTS "result" (
    "id"	INTEGER NOT NULL,
    "user_id"	INTEGER NOT NULL,
    "text"	TEXT,
    FOREIGN KEY("user_id") REFERENCES "user"("id"),
    PRIMARY KEY("id" AUTOINCREMENT)
  );
''';
