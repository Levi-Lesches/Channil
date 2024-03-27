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

  void onAuth() {
    if (!models.user.isAuthenticated) return;
    if (models.user.hasAccount) {
      router.go(Routes.profile);
    } else {
      errorText = "No account exists for that email. Please sign up below";
      notifyListeners();
    }
  }
}
