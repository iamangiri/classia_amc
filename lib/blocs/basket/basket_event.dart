// ---------- basket_event.dart ----------
import 'package:equatable/equatable.dart';

abstract class BasketEvent extends Equatable {
  const BasketEvent();
  @override
  List<Object?> get props => [];
}

class LoadBaskets extends BasketEvent {}

class CreateBasket extends BasketEvent {
  final Map<String, String> data;
  const CreateBasket(this.data);
  @override
  List<Object?> get props => [data];
}

class UpdateBasket extends BasketEvent {
  final int basketId;
  final Map<String, String> data;
  const UpdateBasket(this.basketId, this.data);
  @override
  List<Object?> get props => [basketId, data];
}


