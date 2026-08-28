import 'dart:io';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:video_player/video_player.dart';
import 'package:open_filex/open_filex.dart';

import '../models/file_item.dart';

/// Opens files directly from local device storage - works with
/// zero internet connection since nothing here depends on cloudUrl.
class FileViewerScreen extends StatefulWidget {
  final FileItem item;
  const FileViewerScreen({super.key, required this.item});

  @override
  State<FileViewerScreen> createState() => _FileViewerScreenState();
}

class _FileViewerScreenState extends State<FileViewerScreen> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    if (widget.item.category == FileCategory.video) {
      _videoController = VideoPlayerController.file(File(widget.item.localPath))
        ..initialize().then((_) {
          setState(() {});
          _videoController!.play();
        });
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;

    Widget body;
    switch (item.category) {
      case FileCategory.photo:
        body = PhotoView(imageProvider: FileImage(File(item.localPath)));
        break;
      case FileCategory.video:
        body = _videoController != null && _videoController!.value.isInitialized
            ? Center(
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              )
            : const Center(child: CircularProgressIndicator());
        break;
      default:
        // PDFs, documents, audio - open with device's default local app
        body = Center(
          child: FilledButton.icon(
            onPressed: () => OpenFilex.open(item.localPath),
            icon: const Icon(Icons.open_in_new),
            label: const Text('फाइल खोलें'),
          ),
        );
    }

    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      backgroundColor: Colors.black,
      body: body,
      floatingActionButton: item.category == FileCategory.video
          ? FloatingActionButton(
              onPressed: () {
                setState(() {
                  _videoController!.value.isPlaying
                      ? _videoController!.pause()
                      : _videoController!.play();
                });
              },
              child: Icon(
                _videoController != null && _videoController!.value.isPlaying
                    ? Icons.pause
                    : Icons.play_arrow,
              ),
            )
          : null,
    );
  }
}
