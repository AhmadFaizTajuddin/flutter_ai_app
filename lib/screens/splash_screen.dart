import 'package:flutter/material.dart';
import 'dart:async';
import '../utils/app_theme.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _fadeController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;

  int _loadingStep = 0;
  final List<String> _loadingSteps = [
    'Initializing Edge Nodes...',
    'Loading AI Models...',
    'Connecting to Network...',
    'Calibrating Inference Engine...',
    'Ready.',
  ];

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _fadeController.forward();
    _startLoading();
  }

  void _startLoading() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (_loadingStep < _loadingSteps.length - 1) {
        setState(() => _loadingStep++);
      } else {
        timer.cancel();
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.of(context).pushReplacement(
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const HomeScreen(),
                transitionDuration: const Duration(milliseconds: 600),
                transitionsBuilder: (_, anim, __, child) {
                  return FadeTransition(opacity: anim, child: child);
                },
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (_, child) => Transform.scale(
                  scale: _pulseAnimation.value,
                  child: child,
                ),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.primaryGlow,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('⚡', style: TextStyle(fontSize: 48)),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // App name
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppGradients.primaryGlow.createShader(bounds),
                child: const Text(
                  'AI EDGE',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 8,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'COMPUTING PLATFORM',
                style: TextStyle(
                  fontSize: 11,
                  color: AppTheme.textMuted,
                  letterSpacing: 4,
                ),
              ),

              const SizedBox(height: 60),

              // Loading indicator
              SizedBox(
                width: 200,
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_loadingStep + 1) / _loadingSteps.length,
                        backgroundColor: AppTheme.border,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                            AppTheme.primary),
                        minHeight: 2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _loadingSteps[_loadingStep],
                        key: ValueKey(_loadingStep),
                        style: TextStyle(
                          color: _loadingStep == _loadingSteps.length - 1
                              ? AppTheme.accent
                              : AppTheme.textMuted,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              Text(
                'Powered by Claude AI • Edge Optimized',
                style: TextStyle(
                  color: AppTheme.textMuted,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
