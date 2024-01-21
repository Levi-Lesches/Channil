import "package:channil/models.dart";
import "package:channil/pages.dart";

class LandingViewModel extends ViewModel {
  int state = 0;

  void next() {
    state++;
    notifyListeners();
  }

  void back() {
    state--;
    notifyListeners();
  }

  @override
  Future<void> init() async {
    models.user.addListener(onAuth);
  }

  @override
  void dispose() {
    models.user.removeListener(onAuth);
    super.dispose();
  }

  void onAuth() {
    if (!models.user.isAuthenticated) return;
    if (models.user.hasAccount) {
      router.goNamed(Routes.profile);
    } else {
      errorText = "No account exists for that email. Please sign up below";
      notifyListeners();
    }
  }
}
