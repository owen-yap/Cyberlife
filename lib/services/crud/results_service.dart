import 'dart:async';

import 'package:cyberlife/services/crud/crud_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ResultsService {
  Database? _db;

  List<DatabaseResult> _results = [];

  // Turning ResultsService to a Singleton
  static final ResultsService _shared = ResultsService._sharedInstance();
  ResultsService._sharedInstance();
  factory ResultsService() => _shared;

  final _resultsStreamController =
      StreamController<List<DatabaseResult>>.broadcast();

  Stream<List<DatabaseResult>> get allResults =>
      _resultsStreamController.stream;

  Future<void> _cacheResults() async {
    final allResults = await getAllResults();
    _results = allResults.toList();
    _resultsStreamController.add(_results);
  }

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on CouldNotFindUserException {
      final newUser = await createUser(email: email);
      return newUser;
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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

    _results.add(result);
    _resultsStreamController.add(_results);

    return result;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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
      final result = DatabaseResult.fromRow(results.first);
      _results.removeWhere((result) => result.id == id);
      _results.add(result);
      _resultsStreamController.add(_results);
      return result;
    }
  }

  Future<Iterable<DatabaseResult>> getAllResults() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await db.query(resultTable);

    return results.map((resultRow) => DatabaseResult.fromRow(resultRow));
  }

  Future<DatabaseResult> updateResult(
      {required DatabaseResult result, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();

    // Make sure that the result exists
    await getResult(id: result.id);

    final updatesCount = await db.update(
      resultTable,
      {
        textColumn: text,
      },
      where: 'id = ?',
      whereArgs: [result.id],
    );

    if (updatesCount == 0) {
      throw CouldNotUpdateResultException();
    } else {
      final updatedResult = await getResult(id: result.id);
      _results.add(updatedResult);
      _resultsStreamController.add(_results);
      return updatedResult;
    }
  }

  Future<int> deleteAllResults() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numDeletions = await db.delete(resultTable);

    _results = [];
    _resultsStreamController.add(_results);

    return numDeletions;
  }

  Future<void> deleteResult({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      resultTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deleteCount != 1) {
      throw CouldNotDeleteResultException();
    } else {
      _results.removeWhere((result) => result.id == id);
      _resultsStreamController.add(_results);
    }
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
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

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {}
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
      await _cacheResults();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
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
