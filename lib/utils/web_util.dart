import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:tool_eat_all_game/utils/ui.dart';
import 'package:tool_eat_all_game/widgets/text_padding.dart';
import 'package:get/get.dart';
void exportLevel2({required String plainTextContent, required String nameLevel}){
  final anchor = AnchorElement(
  href: "data:application/octet-stream;charset=utf-16le;base64,${utf8.fuse(base64).encode(plainTextContent)}")
  ..setAttribute("download", "$nameLevel.json")
  ..click();
}

final _textNameLevelController = TextEditingController();
String lastLevelExportName = '';
Future<dynamic> showDialogConfirmExportLevel(BuildContext context, {required String plainTextContent}) async {
  _textNameLevelController.text = "";
   var result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nhập name int level... ( Ví dụ: 1,2,3... )', style: TextStyle(color: Colors.black87, fontSize: 18),),
          content: TextField(
            controller: _textNameLevelController,
            style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.bold),
            decoration: const InputDecoration(hintText: ""),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const TextPadding("CANCEL", style: TextStyle(color: Colors.white), padding: EdgeInsets.all(8),),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black26,
                 ),
              onPressed: () => Navigator.pop(context, false ),
            ),
            ElevatedButton(
              child: const TextPadding('OK', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),),
              onPressed: () {
                var nameFile = _textNameLevelController.text.trim().toLowerCase();
                if(nameFile.isEmpty){
                  showErrorMessage(message: "Nhập tên file export level!");
                  return;
                } else {
                  Navigator.pop(context, true);
                }
              },
            ),
          ],
        );
      });
   if(true == result){
     var nameFile = _textNameLevelController.text.trim().toLowerCase();
     if(nameFile.isEmpty){
       showErrorMessage(message: "Nhập tên file export level!");
       return;
     }
     lastLevelExportName = 'Level_$nameFile';
     exportLevel2(plainTextContent: plainTextContent, nameLevel: lastLevelExportName);
     return true;
   }
}


final _textLevelImportController = TextEditingController();

Future<String?> showDialogImportLevelFromFile(BuildContext context) async {
  _textLevelImportController.text = "";
  var result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Copy -> Paste data vào đây...', style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500, fontSize: 16),),
          content: SizedBox(
            height: Get!.height * 0.2,
            width: Get!.width * 0.5,
            child: TextField(
              minLines: 5,
              maxLines: 1000,
              autofocus: true,
              controller: _textLevelImportController,
              style: const TextStyle(color: Color(0xFF851800), fontSize: 16, fontWeight: FontWeight.normal),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const TextPadding("CANCEL", style: const TextStyle(color: Colors.white), padding: EdgeInsets.all(8),),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black26,
              ),
              onPressed: () => Navigator.pop(context, false ),
            ),
            ElevatedButton(
              child: const TextPadding('IMPORT', padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      });
  if(true == result){
    var data = _textLevelImportController.text.trim();
    if(data.contains("short") && data.contains("full")){
      return data;
    }
  }
  return null;
}