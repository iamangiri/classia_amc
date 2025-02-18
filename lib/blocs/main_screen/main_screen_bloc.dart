import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_screen_event.dart';
import 'main_screen_state.dart';

class MainScreenBloc extends Bloc<MainScreenEvent, MainScreenState> {
  MainScreenBloc() : super(TabChangedState(0)) {
    on<TabChangeEvent>((event, emit) {
      emit(TabChangedState(event.tabIndex)); // Properly emit new state
    });
  }
}
