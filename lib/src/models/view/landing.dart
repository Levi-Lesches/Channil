import "../model.dart";

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

  Future<void> signIn() async {
    isLoading = true;
    await Future<void>.delayed(const Duration(seconds: 1));
    isLoading = false;
  }
}
