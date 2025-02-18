abstract class OnboardingEvent {}

class NextPageEvent extends OnboardingEvent {
  final int currentPage;
  NextPageEvent(this.currentPage);
}

class LastPageReachedEvent extends OnboardingEvent {}
