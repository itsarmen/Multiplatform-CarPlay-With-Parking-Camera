import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Per-camera calibration values persisted by [SettingsStore].
class CameraConfig {
  CameraConfig({
    this.zoom = 1.0,
    this.distance = 0.5,
    this.carWidth = 0.6,
    this.lineAngle = 0.45,
  });

  /// Digital zoom applied to the live preview (0.5 - 3.0).
  double zoom;

  /// Distance of the nearest parking guideline, in metres (0.2 - 3.0).
  double distance;

  /// Car width as a fraction of the view width (0.0 - 1.0); drives the gap
  /// between parking guidelines. 1.0 reaches the view corners.
  double carWidth;

  /// Slant of the parking guidelines: top gap as a fraction of the bottom gap
  /// (0.0 = lines meet at the top, 1.0 = parallel).
  double lineAngle;
}

/// Persistent app settings backed by a local SQLite database.
///
/// All values are cached in memory and written through to disk on change, so
/// reads are synchronous and writes are fire-and-forget.
class SettingsStore {
  SettingsStore._(this._db);

  final Database? _db;

  String lastSection = 'home';
  String mirrorCameraId = '';
  String rearCameraId = '';
  bool beeperEnabled = true;
  bool linesVisible = true;
  final Map<String, CameraConfig> cameras = <String, CameraConfig>{};

  /// Opens (or creates) the settings database and loads every stored value.
  ///
  /// Returns a store even if the database is unavailable, falling back to
  /// in-memory defaults so the app still runs.
  static Future<SettingsStore> open() async {
    Database? db;
    try {
      sqfliteFfiInit();
      final factory = databaseFactoryFfi;
      String dbPath;
      try {
        final dir = await getApplicationSupportDirectory();
        dbPath = p.join(dir.path, 'carplay_settings.db');
      } catch (_) {
        dbPath = p.join(Directory.current.path, 'carplay_settings.db');
      }
      db = await factory.openDatabase(
        dbPath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: (db, version) async {
            await db.execute(
              'CREATE TABLE kv (key TEXT PRIMARY KEY, value TEXT NOT NULL)',
            );
            await db.execute(
              'CREATE TABLE camera_settings ('
              'camera_id TEXT PRIMARY KEY, '
              'zoom REAL NOT NULL, '
              'distance REAL NOT NULL, '
              'car_width REAL NOT NULL, '
              'line_angle REAL NOT NULL DEFAULT 0.45)',
            );
          },
          onUpgrade: (db, oldVersion, newVersion) async {
            if (oldVersion < 2) {
              await db.execute(
                'ALTER TABLE camera_settings '
                'ADD COLUMN line_angle REAL NOT NULL DEFAULT 0.45',
              );
            }
          },
        ),
      );
    } catch (_) {
      db = null;
    }
    final store = SettingsStore._(db);
    await store._load();
    return store;
  }

  Future<void> _load() async {
    final db = _db;
    if (db == null) return;
    try {
      for (final row in await db.query('kv')) {
        final key = row['key'] as String;
        final value = row['value'] as String;
        if (key == 'lastSection') {
          lastSection = value;
        } else if (key == 'mirrorCameraId') {
          mirrorCameraId = value;
        } else if (key == 'rearCameraId') {
          rearCameraId = value;
        } else if (key == 'beeperEnabled') {
          beeperEnabled = value == '1';
        } else if (key == 'linesVisible') {
          linesVisible = value == '1';
        }
      }
      for (final row in await db.query('camera_settings')) {
        cameras[row['camera_id'] as String] = CameraConfig(
          zoom: (row['zoom'] as num?)?.toDouble() ?? 1.0,
          distance: (row['distance'] as num?)?.toDouble() ?? 0.5,
          carWidth:
              ((row['car_width'] as num?)?.toDouble() ?? 0.6)
                  .clamp(0.0, 1.0)
                  .toDouble(),
          lineAngle:
              ((row['line_angle'] as num?)?.toDouble() ?? 0.45)
                  .clamp(0.0, 1.0)
                  .toDouble(),
        );
      }
    } catch (_) {
      // Corrupt / unreadable database — keep defaults.
    }
  }

  CameraConfig configFor(String id) =>
      cameras.putIfAbsent(id, () => CameraConfig());

  Future<void> _putKv(String key, String value) async {
    final db = _db;
    if (db == null) return;
    await db.insert(
      'kv',
      <String, Object?>{'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> _saveCamera(String id, CameraConfig config) async {
    final db = _db;
    if (db == null) return;
    await db.insert(
      'camera_settings',
      <String, Object?>{
        'camera_id': id,
        'zoom': config.zoom,
        'distance': config.distance,
        'car_width': config.carWidth,
        'line_angle': config.lineAngle,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> setLastSection(String value) {
    lastSection = value;
    return _putKv('lastSection', value);
  }

  Future<void> setMirrorCamera(String value) {
    mirrorCameraId = value;
    return _putKv('mirrorCameraId', value);
  }

  Future<void> setRearCamera(String value) {
    rearCameraId = value;
    return _putKv('rearCameraId', value);
  }

  Future<void> setBeeperEnabled(bool value) {
    beeperEnabled = value;
    return _putKv('beeperEnabled', value ? '1' : '0');
  }

  Future<void> setLinesVisible(bool value) {
    linesVisible = value;
    return _putKv('linesVisible', value ? '1' : '0');
  }

  Future<void> setZoom(String id, double value) {
    final config = configFor(id)..zoom = value;
    return _saveCamera(id, config);
  }

  Future<void> setDistance(String id, double value) {
    final config = configFor(id)..distance = value;
    return _saveCamera(id, config);
  }

  Future<void> setCarWidth(String id, double value) {
    final config = configFor(id)..carWidth = value;
    return _saveCamera(id, config);
  }

  Future<void> setLineAngle(String id, double value) {
    final config = configFor(id)..lineAngle = value;
    return _saveCamera(id, config);
  }

  Future<void> close() async => _db?.close();
}
