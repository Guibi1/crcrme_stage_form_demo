import 'package:crcrme_stage_form_demo/crcrme_enhanced_containers/lib/item_serializable.dart';

import '/common/models/job.dart';

class Sector extends ItemSerializable {
  Sector({
    required this.name,
    required this.jobs,
  });

  Sector.fromSerialized(map)
      : name = map["name"],
        jobs = (map["jobs"] as List)
            .map((data) => Job.fromSerialized(data))
            .toList(),
        super.fromSerialized(map);

  @override
  ItemSerializable deserializeItem(map) {
    return Sector.fromSerialized(map);
  }

  @override
  Map<String, dynamic> serializedMap() {
    throw "Sector should not be serialized. Store its ID intead.";
  }

  Job fromId(String id) {
    return jobs.firstWhere((job) => job.id == id);
  }

  final String name;
  final List<Job> jobs;
}
