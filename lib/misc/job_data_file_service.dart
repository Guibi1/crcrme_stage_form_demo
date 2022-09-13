import 'dart:convert';

import 'package:crcrme_stage_form_demo/crcrme_enhanced_containers/lib/item_serializable.dart';
import 'package:flutter/services.dart';

abstract class JobDataFileService {
  static Future<void> loadData() async {
    final file = await rootBundle.loadString("assets/jobs-data.json");
    final json = jsonDecode(file) as List;

    _sectors = List.from(
      json.map((e) => ActivitySector.fromSerialized(e)),
      growable: false,
    );
  }

  static ActivitySector fromId(String id) {
    return _sectors.firstWhere((sector) => sector.id == id);
  }

  static List<ActivitySector> get sectors => _sectors;

  static List<ActivitySector> _sectors = [];
}

class ActivitySector extends ItemSerializable {
  ActivitySector({
    required this.name,
    required this.jobs,
  });

  ActivitySector.fromSerialized(map)
      : name = map["name"],
        jobs = List.from(
          map["specializations"].map((e) => Specialization.fromSerialized(e)),
          growable: false,
        ),
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
        skills = List.from(
          map["skills"].map((e) => Skill.fromSerialized(e)),
          growable: false,
        ),
        questions = Set.from(map["questions"].map((e) => e.toString())),
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
        criteria = List.from(
          map["criteria"].map((e) => e.toString()),
          growable: false,
        ),
        tasks = List.from(
          map["tasks"].map((e) => e.toString()),
          growable: false,
        ),
        risks = Set.from(map["risks"].map((e) => e.toString())),
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
