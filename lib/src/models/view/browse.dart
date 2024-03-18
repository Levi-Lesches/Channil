import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/services.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class BrowseViewModel extends ViewModel {
  List<ChannilUser> upcomingUsers = [];
  ChannilUser? currentUser;
  DocumentSnapshot<ChannilUser>? snapshot;

  final HomeModel home;
  BrowseViewModel(this.home);

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
    home.rejectedIDs.add(currentUser!.id);
    nextUser();
  }

  List<String> get skipIDs => [...home.rejectedIDs, ...home.matchedIDs];

  Future<bool> loadMoreUsers() async {
    final (newSnapshot, nextUsers) = await models.user.channilUser!.matchProfileType(
      handleBusiness: (profile) => services.database.queryAthletes(profile, startAfter: snapshot),
      handleAthlete: (profile) => services.database.queryBusinesses(profile, startAfter: snapshot),
    );
    snapshot = newSnapshot;
    if (nextUsers.isEmpty) {
      errorText = "Could not find any users that match your preferences. Try making your preferences more broad.";
      // home.updateAppBarText(null);
      currentUser = null;
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
    if (skipIDs.contains(currentUser!.id)) return nextUser();
    // home.updateAppBarText(currentUser!.name);
    notifyListeners();
  }

  Future<void> clearRejections() async {
    isLoading = true;
    home.rejectedIDs.clear();
    errorText = null;
    await nextUser();
    isLoading = false;
  }

  Future<void> connect(Message firstMessage) async {
    isLoading = true;
    final connection = Connection.start(
      from: models.user.channilUser!, 
      to: currentUser!,
      firstMessage: firstMessage,
    );
    await services.database.saveConnection(connection);
    await home.getConnections();
    await nextUser();
    isLoading = false;
  }
}
