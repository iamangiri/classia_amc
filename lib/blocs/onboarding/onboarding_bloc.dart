import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial()) {
    on<NextPageEvent>(_onNextPage);
    on<LastPageReachedEvent>(_onLastPageReached);
  }

  void _onNextPage(NextPageEvent event, Emitter<OnboardingState> emit) {
    emit(OnboardingInProgress(event.currentPage));
  }

  void _onLastPageReached(LastPageReachedEvent event, Emitter<OnboardingState> emit) {
    emit(OnboardingCompleted());
  }
}
