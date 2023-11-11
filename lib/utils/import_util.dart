import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

Future<List<String>?> importFileJsonLevel() async{
  if (kIsWeb) {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['json'],
    );
    if(result != null && result.files.isNotEmpty){
      PlatformFile file = result.files.first;
      var data = String.fromCharCodes(file.bytes!).trim();
      if(data.contains("short") && data.contains("full")){
        return [file.name, data];
      }
    }
  }
  return null;
}