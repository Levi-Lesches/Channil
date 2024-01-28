import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

class ProfileViewModel extends ViewModel {
  late ChannilUser user;
  late UserID? profileID;
  late bool shouldUpdate;

  final HomeModel home;
  ProfileViewModel(this.home, {this.profileID});      

  @override
  Future<void> init() async { 
    isLoading = true;
    shouldUpdate = profileID == null;
    final profile = profileID == null 
      ? models.user.channilUser!
      : await services.database.getUser(profileID!);
    profileID ??= models.user.channilUser!.id;
    isLoading = false;
    if (profile == null) {
      errorText = "Could not load profile ID=$profileID";
    } else {
      user = profile;
      home.appBarText = user.name;
    }
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
