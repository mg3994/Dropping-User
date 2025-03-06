import 'package:drift/drift.dart';
import 'package:drift/wasm.dart';
import 'package:flutter/foundation.dart';

class PlatformInterface {
  static QueryExecutor createDatabaseConnection(String databaseName) {
    return DatabaseConnection.delayed(Future(() async {
      final database = await WasmDatabase.open(
        databaseName: databaseName,
        sqlite3Uri: Uri.parse('/sqlite3.wasm'),
        driftWorkerUri: Uri.parse(
          kReleaseMode ? '/drift_worker.js' : '/drift_worker.js',
        ),
      );
      return database.resolvedExecutor;
    }));
  }
}