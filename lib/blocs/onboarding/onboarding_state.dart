abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingInProgress extends OnboardingState {
  final int currentPage;
  OnboardingInProgress(this.currentPage);
}

class OnboardingCompleted extends OnboardingState {}
