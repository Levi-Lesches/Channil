import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";

class BrowseViewModel extends ViewModel {
  List<ChannilUser> upcomingUsers = [];
  ChannilUser? currentUser;

  @override
  Future<void> init() async {
    isLoading = true;
    if (!models.user.hasAccount) {
      errorText = "You must sign in to browse other profiles";
      return;
    }
    await nextUser();
    isLoading = false;
  }

  void reject() {
    rejectedIDs.add(currentUser!.id);
    nextUser();
  }

  List<String> get rejectedIDs => models.home.rejectedIDs;

  Future<bool> loadMoreUsers() async {
    final nextUsers = await models.user.channilUser!.matchProfileType(
      handleBusiness: (profile) => services.database.queryAthletes(profile, rejectedIDs: rejectedIDs),
      handleAthlete: (profile) => services.database.queryBusinesses(profile, rejectedIDs: rejectedIDs),
    );
    if (nextUsers.isEmpty) {
      errorText = "Could not find any users that match your preferences\nTry making your preferences more broad";
      models.home.updateAppBarText(null);
      return false;
    } else {
      upcomingUsers = nextUsers;
      return true;
    }
  }

  Future<void> nextUser() async {
    if (upcomingUsers.isEmpty) {
      if (!await loadMoreUsers()) return;
    }
    currentUser = upcomingUsers.removeLast();
    models.home.updateAppBarText(currentUser!.name);
    notifyListeners();
  }
}
