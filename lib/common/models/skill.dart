import 'package:crcrme_stage_form_demo/crcrme_enhanced_containers/lib/item_serializable.dart';

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
