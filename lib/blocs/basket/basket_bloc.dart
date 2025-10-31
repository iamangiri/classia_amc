// // ---------- basket_bloc.dart ----------
// import 'package:classia_amc/blocs/basket/basket_state.dart';
// import 'package:classia_amc/service/apiservice/basket_api_service.dart' show BasketApiService;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'basket_event.dart';


// class BasketBloc extends Bloc<BasketEvent, BasketState> {
//   final BasketApiService _api = BasketApiService();

//   BasketBloc() : super(BasketInitial()) {
//     on<LoadBaskets>(_load);
//     on<CreateBasket>(_create);
//     on<UpdateBasket>(_update);
//   }

//   Future<void> _load(LoadBaskets event, Emitter<BasketState> emit) async {
//     emit(BasketLoading());
//     try {
//       final list = await _api.fetchBaskets(
//         subscriptionType: 'FREE',
//         volatility: 'LOW',
//         status: 'ACTIVE',
//         page: 1,
//         sizePerPage: 50,
//       );
//       emit(BasketLoaded(list));
//     } catch (e) {
//       emit(BasketError(e.toString()));
//     }
//   }

//   Future<void> _create(CreateBasket event, Emitter<BasketState> emit) async {
//     try {
//       await _api.createBasket(
//         basketName: event.data['basketName']!,
//         subscriptionAmount: event.data['subscriptionAmount']!,
//         raName: event.data['raName']!,
//         expectedReturn: event.data['expectedReturn']!,
//         subscriptionType: event.data['subscriptionType']!,
//         volatility: event.data['volatility']!,
//         status: event.data['status']!,
//       );
//       add(LoadBaskets()); // refresh
//     } catch (e) {
//       emit(BasketError(e.toString()));
//     }
//   }

//   Future<void> _update(UpdateBasket event, Emitter<BasketState> emit) async {
//     try {
//       await _api.updateBasket(
//         basketId: event.basketId,
//         basketName: event.data['basketName']!,
//         subscriptionAmount: event.data['subscriptionAmount']!,
//         raName: event.data['raName']!,
//         expectedReturn: event.data['expectedReturn']!,
//         subscriptionType: event.data['subscriptionType']!,
//         volatility: event.data['volatility']!,
//         status: event.data['status']!,
//       );
//       add(LoadBaskets());
//     } catch (e) {
//       emit(BasketError(e.toString()));
//     }
//   }
// }