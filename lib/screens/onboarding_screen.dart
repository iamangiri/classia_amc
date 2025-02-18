import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../blocs/onboarding/onboarding_bloc.dart';
import '../blocs/onboarding/onboarding_event.dart';
import '../blocs/onboarding/onboarding_state.dart';

class OnBoardingScreen extends StatefulWidget {
  static const String routeName = '/onboarding';

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingBloc(),
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          bool showGetStartedButton = state is OnboardingCompleted;

          return Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    if (index == 3) {
                      context.read<OnboardingBloc>().add(LastPageReachedEvent());
                    } else {
                      context.read<OnboardingBloc>().add(NextPageEvent(index));
                    }
                  },
                  children: [
                    _buildOnboardingPage(
                      'Welcome to Jocey Trading!',
                      'assets/anim/trade-4.json',
                      'We make trading simple and accessible for everyone.',
                    ),
                    _buildOnboardingPage(
                      'Simple Buying & Selling',
                      'assets/anim/trade-3.json',
                      'Trade effortlessly with just a few taps.',
                    ),
                    _buildOnboardingPage(
                      'Boost Your Earnings',
                      'assets/anim/trade-1.json',
                      'Trade effortlessly with just a few taps.',
                    ),
                    _buildOnboardingPage(
                      'Secure & Reliable Trading',
                      'assets/anim/trade-5.json',
                      'Your transactions are protected with top-notch security.',
                    ),
                  ],
                ),
                if (showGetStartedButton)
                  Align(
                    alignment: const Alignment(0, 0.75),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/main'); // Navigate to login
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                Container(
                  alignment: const Alignment(0, 0.9),
                  child: SmoothPageIndicator(
                    controller: _controller,
                    count: 4,
                    effect: const WormEffect(activeDotColor: Colors.amber),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String imagePath, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(imagePath, height: 300, width: 300),
          const SizedBox(height: 20),
          Text(title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
          const SizedBox(height: 20),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
