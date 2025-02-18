import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/main_screen/main_screen_bloc.dart';
import 'routes/app_router.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => MainScreenBloc()), // Provide globally
      ],
      child: MaterialApp.router(
        title: 'Classia Amcs',
        routerConfig: router, // Attach GoRouter
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
