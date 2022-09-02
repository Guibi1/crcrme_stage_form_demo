import 'package:crcrme_stage_form_demo/crcrme_enhanced_containers/lib/item_serializable.dart';

import '/common/models/skill.dart';

class Job extends ItemSerializable {
  Job({
    required this.name,
    required this.skills,
    required this.questions,
  });

  Job.fromSerialized(map)
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
    return Job.fromSerialized(map);
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
