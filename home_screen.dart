import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

import '../services/auth_service.dart';
import '../services/storage_service.dart';
import '../services/theme_service.dart';
import '../models/file_item.dart';
import 'file_viewer_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _folders = ['Personal', 'Work', 'Study'];
  String _selectedFolder = 'Personal';
  String _searchQuery = '';

  Future<void> _uploadFile() async {
    // Works fully offline - file is picked from device and copied locally,
    // cloud backup happens later automatically if internet is available.
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result == null || result.files.single.path == null) return;

    final path = result.files.single.path!;
    final ext = path.split('.').last.toLowerCase();
    FileCategory category = FileCategory.other;
    if (['jpg', 'jpeg', 'png', 'heic'].contains(ext)) category = FileCategory.photo;
    if (['mp4', 'mov', 'mkv'].contains(ext)) category = FileCategory.video;
    if (ext == 'pdf') category = FileCategory.pdf;
    if (['doc', 'docx', 'txt'].contains(ext)) category = FileCategory.document;
    if (['mp3', 'wav', 'm4a'].contains(ext)) category = FileCategory.audio;

    final storage = context.read<StorageService>();
    await storage.saveFileOffline(
      pickedFile: File(path),
      displayName: result.files.single.name,
      category: category,
      folder: _selectedFolder,
    );
  }

  void _showRenameDialog(FileItem item) {
    final ctrl = TextEditingController(text: item.name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rename File'),
        content: TextField(controller: ctrl, autofocus: true),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              context.read<StorageService>().renameFile(item.id, ctrl.text.trim());
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();
    final theme = context.watch<ThemeService>();
    final auth = context.read<AuthService>();

    final files = _searchQuery.isNotEmpty
        ? storage.search(_searchQuery)
        : storage.filesInFolder(_selectedFolder);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Storage'),
        actions: [
          IconButton(
            icon: Icon(theme.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: theme.toggleTheme,
          ),
          IconButton(icon: const Icon(Icons.logout), onPressed: auth.signOut),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'फाइलें search करें...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          if (_searchQuery.isEmpty)
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: _folders.map((f) {
                  final selected = f == _selectedFolder;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(f),
                      selected: selected,
                      onSelected: (_) => setState(() => _selectedFolder = f),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 8),
          Expanded(
            child: files.isEmpty
                ? const Center(child: Text('कोई फाइल नहीं है। + दबाकर upload करें।'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, i) {
                      final item = files[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => FileViewerScreen(item: item)),
                        ),
                        onLongPress: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => SafeArea(
                            child: Wrap(children: [
                              ListTile(
                                leading: const Icon(Icons.edit),
                                title: const Text('Rename'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showRenameDialog(item);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete, color: Colors.red),
                                title: const Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  context.read<StorageService>().deleteFile(item.id);
                                },
                              ),
                            ]),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(_iconFor(item.category), size: 32),
                              const SizedBox(height: 4),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  item.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                              if (!item.isSynced)
                                const Icon(Icons.cloud_off, size: 12, color: Colors.grey),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _uploadFile,
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _iconFor(FileCategory c) {
    switch (c) {
      case FileCategory.photo:
        return Icons.image;
      case FileCategory.video:
        return Icons.videocam;
      case FileCategory.pdf:
        return Icons.picture_as_pdf;
      case FileCategory.document:
        return Icons.description;
      case FileCategory.audio:
        return Icons.audiotrack;
      default:
        return Icons.insert_drive_file;
    }
  }
}
