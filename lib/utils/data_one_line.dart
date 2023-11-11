

import 'dart:convert';
import 'dart:html';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';

void readData1LineGameAsset() async {
  for(var i = 0 ; i <= 30; i++ ) {
    for(var k = 0; k < 35; k++){
      var levelPath = 'assets/data_level/lp$i/lvl${k}_decoded.json';
      try {
        String contents = await rootBundle.loadString('assets/data_level/lp$i/lvl${k}_decoded.json');
      } catch(_) {
        print('levelPath not found: $levelPath');
        break;
      }
    }
  }
}
void readData1LineGameAsset2() async {
  for(var i = 0 ; i <= 1040; i++ ) {
    var levelPath = '- assets/data_level/lp$i/';
    print('$levelPath');
  }
}

void exportLevel3({required String plainTextContent, required String nameLevel}){
  final anchor = AnchorElement(
      href: "data:application/octet-stream;charset=utf-16le;base64,${utf8.fuse(base64).encode(plainTextContent)}")
    ..setAttribute("download/data_level/lp0", "$nameLevel.json")
    ..click();
}
