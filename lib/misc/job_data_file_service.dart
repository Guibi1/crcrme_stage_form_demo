import 'dart:convert';

import 'package:crcrme_stage_form_demo/crcrme_enhanced_containers/lib/item_serializable.dart';
import 'package:flutter/services.dart';

abstract class JobDataFileService {
  static Future<void> loadData() async {
    final file = await rootBundle.loadString("assets/jobs-data.json");
    final json = jsonDecode(file) as List;

    _sectors = json
        .map((e) => ActivitySector.fromSerialized(e))
        .toList(growable: false);
  }

  static ActivitySector fromId(String id) {
    return _sectors.firstWhere((sector) => sector.id == id);
  }

  static List<ActivitySector> _sectors = [];

  static List<ActivitySector> get sectors => _sectors;
}

class ActivitySector extends ItemSerializable {
  ActivitySector({
    required this.name,
    required this.jobs,
  });

  ActivitySector.fromSerialized(map)
      : name = map["name"],
        jobs = (map["specializations"] as List)
            .map((data) => Specialization.fromSerialized(data))
            .toList(),
        super.fromSerialized(map);

  @override
  ItemSerializable deserializeItem(map) {
    return ActivitySector.fromSerialized(map);
  }

  @override
  Map<String, dynamic> serializedMap() {
    throw "Sector should not be serialized. Store its ID intead.";
  }

  Specialization fromId(String id) {
    return jobs.firstWhere((job) => job.id == id);
  }

  final String name;
  final List<Specialization> jobs;
}

class Specialization extends ItemSerializable {
  Specialization({
    required this.name,
    required this.skills,
    required this.questions,
  });

  Specialization.fromSerialized(map)
      : name = map["name"],
        skills = (map["skills"] as List)
            .map((s) => Skill.fromSerialized(s))
            .toList(),
        questions = (map["questions"] as List)
            .map((question) => question.toString())
            .toSet(),
        super.fromSerialized(map);

  @override
  ItemSerializable deserializeItem(map) {
    return Specialization.fromSerialized(map);
  }

  @override
  Map<String, dynamic> serializedMap() {
    throw "Job should not be serialized. Store its ID intead.";
  }

  Skill fromId(String id) {
    return skills.firstWhere((skill) => skill.id == id);
  }

  final String name;

  final List<Skill> skills;
  final Set<String> questions;
}

class Skill extends ItemSerializable {
  Skill({
    required this.name,
    required this.criteria,
    required this.tasks,
    required this.risks,
  });

  Skill.fromSerialized(map)
      : name = map["name"],
        criteria = (map["criteria"] as List).map((e) => e.toString()).toList(),
        tasks = (map["tasks"] as List).map((e) => e.toString()).toList(),
        risks = (map["risks"] as List).map((risk) => risk.toString()).toSet(),
        super.fromSerialized(map);

  @override
  ItemSerializable deserializeItem(map) {
    return Skill.fromSerialized(map);
  }

  @override
  Map<String, dynamic> serializedMap() {
    throw "Skill should not be serialized. Store its ID intead.";
  }

  String name;

  List<String> criteria;
  List<String> tasks;
  Set<String> risks;
}
