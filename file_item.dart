enum FileCategory { photo, video, pdf, document, audio, other }

class FileItem {
  final String id;
  String name;
  final String localPath; // path on device - works fully offline
  String? cloudUrl; // set once uploaded to Firebase Storage (for backup)
  final FileCategory category;
  final String folder; // Personal / Work / Study
  final DateTime createdAt;
  bool isSynced;

  FileItem({
    required this.id,
    required this.name,
    required this.localPath,
    this.cloudUrl,
    required this.category,
    required this.folder,
    required this.createdAt,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'localPath': localPath,
        'cloudUrl': cloudUrl,
        'category': category.name,
        'folder': folder,
        'createdAt': createdAt.toIso8601String(),
        'isSynced': isSynced,
      };

  factory FileItem.fromMap(Map map) => FileItem(
        id: map['id'],
        name: map['name'],
        localPath: map['localPath'],
        cloudUrl: map['cloudUrl'],
        category: FileCategory.values.firstWhere((e) => e.name == map['category']),
        folder: map['folder'],
        createdAt: DateTime.parse(map['createdAt']),
        isSynced: map['isSynced'] ?? false,
      );
}
