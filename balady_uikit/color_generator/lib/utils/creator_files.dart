import 'dart:io';

Future<File> getFile(String filePath) async {
  final file = File(filePath);

  if (!await file.exists()) {
    throw Exception('File not found: $filePath');
  }
  return file;
}

Future<void> createFolder(String folderPath) async {
  final directory = Directory(folderPath);

  if (await directory.exists()) {
    print('Folder already exists: $folderPath');
  } else {
    await directory.create(recursive: true);
    print('Folder created: $folderPath');
  }
}

Future<void> createFile(String filePath, String content) async {
  final file = File(filePath);
  if (await file.exists()) {
    await file.delete();
    print('File deleted: $filePath');
  }

  await file.create(recursive: true);
  await file.writeAsString(content);
  print('File created: $filePath');
}
