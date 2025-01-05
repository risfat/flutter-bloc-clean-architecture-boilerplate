import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/routes.dart';
import '../../bloc/authenticator_watcher/authenticator_watcher_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Future.microtask(
        () => context.read<AuthenticatorWatcherBloc>().add(
              const AuthenticatorWatcherEvent.authCheckRequest(),
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticatorWatcherBloc, AuthenticatorWatcherState>(
      listener: (context, state) {
        state.maybeMap(
          orElse: () {},
          authenticating: (_) {},
          authenticated: (_) =>
              context.replaceNamed(AppRoutes.dashboardRouteName),
          isFirstTime: (_) =>
              context.replaceNamed(AppRoutes.dashboardRouteName),
          unauthenticated: (_) =>
              context.replaceNamed(AppRoutes.dashboardRouteName),
        );
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade300, Colors.purple.shade300],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.flutter_dash,
                  size: 100,
                  color: Colors.white,
                )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.elasticOut)
                    .fade(duration: 500.ms),
                SizedBox(height: 20),
                Text(
                  'Flutter Boilerplate',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ).animate().fadeIn(delay: 300.ms, duration: 500.ms).slideY(
                    begin: 0.2, end: 0, delay: 300.ms, duration: 500.ms),
                SizedBox(height: 10),
                Text(
                  'Clean Architecture',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 500.ms).slideY(
                    begin: 0.2, end: 0, delay: 600.ms, duration: 500.ms),
              ],
            ).animate().scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 1000.ms,
                curve: Curves.easeOutBack),
          ),
        ),
      ),
    );
  }
}
