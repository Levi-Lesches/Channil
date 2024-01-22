import "package:channil/data.dart";
import "package:channil/models.dart";

class ProfileViewModel extends ViewModel {
  late ChannilUser user;
  
  @override
  Future<void> init() async { 
    updateUser();
    models.user.addListener(updateUser);
  }

  @override
  void dispose() {
    models.user.removeListener(updateUser);
    super.dispose();
  }

  void updateUser() {
    user = models.user.channilUser!;
    notifyListeners();
  }
}
