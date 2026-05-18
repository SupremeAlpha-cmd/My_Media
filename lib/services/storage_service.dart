import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class StorageService {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<Directory> get _mediaDir async {
    final path = await _localPath;
    final dir = Directory(p.join(path, 'MyMedia'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<File> saveFile(String sourcePath, {bool isVideo = false}) async {
    final dir = await _mediaDir;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}${isVideo ? ".mp4" : ".jpg"}';
    final targetPath = p.join(dir.path, fileName);
    
    final sourceFile = File(sourcePath);
    return await sourceFile.copy(targetPath);
  }

  static Future<List<FileSystemEntity>> getMediaFiles() async {
    final dir = await _mediaDir;
    return dir.listSync().where((file) {
      final ext = p.extension(file.path).toLowerCase();
      return ext == '.jpg' || ext == '.mp4';
    }).toList();
  }
}
