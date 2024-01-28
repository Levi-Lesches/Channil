import "src/models/model.dart";
import "src/models/data/user.dart";

export "src/models/model.dart";
export "src/models/data/user.dart";

export "src/models/view/landing.dart";
export "src/models/view/home.dart";
export "src/models/view/browse.dart";
export "src/models/view/profile.dart";

export "src/models/builder/athlete.dart";
export "src/models/builder/business.dart";
export "src/models/builder/image.dart";
export "src/models/builder/profile.dart";
export "src/models/builder/social.dart";

class Models extends DataModel {
  final user = UserModel();
  List<DataModel> get models => [user]; 

  @override
  Future<void> init() async {
    for (final model in models) {
      await model.init();
    }
  }
}

final models = Models();
