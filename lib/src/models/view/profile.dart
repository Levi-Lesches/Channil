import "package:channil/data.dart";
import "package:channil/models.dart";

class ProfileViewModel extends ViewModel {
  ChannilUser user;
  bool shouldUpdate;

  factory ProfileViewModel() => ProfileViewModel._(user: models.user.channilUser!, shouldUpdate: false);
  ProfileViewModel._({required this.user, required this.shouldUpdate});
  
  @override
  Future<void> init() async { 
    if (shouldUpdate) models.user.addListener(updateUser);
  }

  @override
  void dispose() {
    if (shouldUpdate) models.user.removeListener(updateUser);
    super.dispose();
  }

  void updateUser() {
    user = models.user.channilUser!;
    notifyListeners();
  }
}
