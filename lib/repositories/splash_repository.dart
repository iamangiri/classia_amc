class SplashRepository {
  Future<void> fetchInitialData() async {
    await Future.delayed(Duration(seconds: 3)); // Simulated delay
  }
}
