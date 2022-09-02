import 'dart:convert';

import 'package:flutter/services.dart';

import '/common/models/sector.dart';

abstract class JobDataFileService {
  static Future<void> loadData() async {
    final file = await rootBundle.loadString("assets/jobs-data.json");
    final json = jsonDecode(file) as List;

    _sectors =
        json.map((e) => Sector.fromSerialized(e)).toList(growable: false);
  }

  static Sector fromId(String id) {
    return _sectors.firstWhere((sector) => sector.id == id);
  }

  static List<Sector> _sectors = [];

  static List<Sector> get sectors => _sectors;
}
