import 'package:myapp/src/features/home/data/models/advisory_model.dart';

class Advisory {
  final String description;

  Advisory({
    required this.description,
  });

  factory Advisory.fromModel(AdvisoryModel model) {
    return Advisory(
      description: model.description,
    );
  }
}
