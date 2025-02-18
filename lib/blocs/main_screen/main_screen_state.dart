abstract class MainScreenState {}

class TabChangedState extends MainScreenState {
  final int tabIndex;
  TabChangedState(this.tabIndex);
}
