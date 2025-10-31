// ---------- basket_state.dart ----------
import 'package:equatable/equatable.dart';

abstract class BasketState extends Equatable {
  const BasketState();
  @override
  List<Object?> get props => [];
}

class BasketInitial extends BasketState {}

class BasketLoading extends BasketState {}

class BasketLoaded extends BasketState {
  final List<Map<String, dynamic>> baskets;
  const BasketLoaded(this.baskets);
  @override
  List<Object?> get props => [baskets];
}

class BasketError extends BasketState {
  final String message;
  const BasketError(this.message);
  @override
  List<Object?> get props => [message];
}
