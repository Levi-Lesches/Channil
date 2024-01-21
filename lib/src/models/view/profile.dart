import "package:channil/data.dart";
import "package:channil/models.dart";

class ProfileViewModel extends ViewModel { 
  late final ChannilUser user;
  final List<ImageUploader> imageModels = [];
  
  // TODO: Refresh on user edits
  
  @override
  Future<void> init() async {
    isLoading = true;
    user = models.user.channilUser!;
    isLoading = false;
    notifyListeners();
  }
}
