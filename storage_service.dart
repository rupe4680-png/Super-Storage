import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../models/file_item.dart';

/// Handles storing files fully offline (device storage + Hive metadata),
/// and opportunistically backing them up to Firebase Storage when
/// internet is available. Nothing here ever blocks on network access -
/// upload/view always works offline first.
class StorageService extends ChangeNotifier {
  final Box _filesBox = Hive.box('files_box');
  final _uuid = const Uuid();

  List<FileItem> _items = [];
  List<FileItem> get items => _items;

  StorageService() {
    _loadFromHive();
  }

  void _loadFromHive() {
    _items = _filesBox.values
        .map((e) => FileItem.fromMap(Map<String, dynamic>.from(e)))
        .toList();
    notifyListeners();
  }

  /// Copies a picked file (photo/video/pdf/doc/audio) into the app's local
  /// storage directory so it is available with NO internet connection,
  /// then saves metadata to Hive. Cloud backup is attempted separately.
  Future<FileItem> saveFileOffline({
    required File pickedFile,
    required String displayName,
    required FileCategory category,
    required String folder,
  }) async {
    final appDir = await getApplicationDocumentsDirectory();
    final id = _uuid.v4();
    final ext = pickedFile.path.split('.').last;
    final localPath = '${appDir.path}/s_store/$id.$ext';

    await Directory('${appDir.path}/s_store').create(recursive: true);
    await pickedFile.copy(localPath);

    final item = FileItem(
      id: id,
      name: displayName,
      localPath: localPath,
      category: category,
      folder: folder,
      createdAt: DateTime.now(),
      isSynced: false,
    );

    await _filesBox.put(id, item.toMap());
    _items.add(item);
    notifyListeners();

    // Fire-and-forget cloud backup; safe to fail silently if offline.
    _backupToCloud(item);

    return item;
  }

  Future<void> _backupToCloud(FileItem item) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      final ref = FirebaseStorage.instance
          .ref()
          .child('users/$uid/${item.folder}/${item.id}');
      await ref.putFile(File(item.localPath));
      item.cloudUrl = await ref.getDownloadURL();
      item.isSynced = true;
      await _filesBox.put(item.id, item.toMap());
      notifyListeners();
    } catch (_) {
      // No internet or upload failed - file remains safely available offline.
      // Sync will be retried next time syncPendingFiles() runs.
    }
  }

  /// Call when connectivity is restored to push any files backed up locally
  /// but not yet synced to the cloud.
  Future<void> syncPendingFiles() async {
    final pending = _items.where((f) => !f.isSynced).toList();
    for (final item in pending) {
      await _backupToCloud(item);
    }
  }

  Future<void> renameFile(String id, String newName) async {
    final item = _items.firstWhere((f) => f.id == id);
    item.name = newName;
    await _filesBox.put(id, item.toMap());
    notifyListeners();
  }

  Future<void> deleteFile(String id) async {
    final item = _items.firstWhere((f) => f.id == id);
    final file = File(item.localPath);
    if (await file.exists()) await file.delete();
    await _filesBox.delete(id);
    _items.removeWhere((f) => f.id == id);
    notifyListeners();
  }

  List<FileItem> filesInFolder(String folder) =>
      _items.where((f) => f.folder == folder).toList();

  List<FileItem> search(String query) {
    final q = query.toLowerCase();
    return _items.where((f) => f.name.toLowerCase().contains(q)).toList();
  }
}
