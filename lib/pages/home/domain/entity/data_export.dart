import 'dart:convert';

class DataExport {
  List<List<int>>? short;
  List<List<int>>? full;
  List<String>? teleportCoupleShort;
  List<String>? teleportCoupleFull;
  DataExport({this.short, this.full, this.teleportCoupleShort, this.teleportCoupleFull});

  DataExport.fromJson(Map<String, dynamic> json) {
    short = json['short'] ?? jsonDecode(json['short']);
    full = json['full'] ?? jsonDecode(json['full']);
    teleportCoupleShort = json['teleportCoupleShort'] ?? jsonDecode(json['teleportCoupleShort']);
    teleportCoupleFull = json['teleportCoupleFull'] ?? jsonDecode(json['teleportCoupleFull']);
  }

  Map<String, dynamic> toJson() => {
    "short": jsonEncode(short),
    "full": jsonEncode(full),
    "teleportCoupleShort": jsonEncode(teleportCoupleShort),
    "teleportCoupleFull": jsonEncode(teleportCoupleFull),
  };
}