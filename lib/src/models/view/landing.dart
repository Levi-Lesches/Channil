import "package:channil/models.dart";

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
}
