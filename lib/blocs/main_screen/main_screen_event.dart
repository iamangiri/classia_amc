abstract class MainScreenEvent {}

class TabChangeEvent extends MainScreenEvent {
  final int tabIndex;
  TabChangeEvent(this.tabIndex);
}
