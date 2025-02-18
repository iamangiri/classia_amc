import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../blocs/splash/splash_bloc.dart';
import '../blocs/splash/splash_event.dart';
import '../blocs/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(StartSplashEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoaded) {
            context.go('/onboarding'); // Navigate when splash is done
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: TweenAnimationBuilder(
              duration: Duration(seconds: 1),
              tween: Tween<double>(begin: 0, end: 1),
              builder: (context, double value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(scale: value, child: child),
                );
              },
              child: Image.asset(
                'assets/images/splash-2.png', // Ensure asset exists
                width: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
