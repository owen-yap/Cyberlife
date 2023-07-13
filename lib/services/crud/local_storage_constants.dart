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
