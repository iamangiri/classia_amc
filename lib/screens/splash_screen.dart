import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/splash/splash_bloc.dart';
import '../blocs/splash/splash_event.dart';
import '../blocs/splash/splash_state.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashBloc()..add(StartSplashEvent()),
      child: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) async {
          if (state is SplashLoaded) {
            // Retrieve the token from SharedPreferences.
            final prefs = await SharedPreferences.getInstance();
            final token = prefs.getString('auth_token');
            // Check if the token exists and is not empty.
            if (token != null && token.isNotEmpty) {
              context.go('/login');
            } else {
              context.go('/onboarding');
            }
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
                'assets/images/classia-logo.jpg', // Ensure the asset exists
                width: 150,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
