import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../applied_loans/applied_loans_screen.dart';
import '../../main.dart';

class SuccessScreen extends StatefulWidget {
  final String thankYouMessage;
  
  const SuccessScreen({
    super.key,
    required this.thankYouMessage,
  });

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with TickerProviderStateMixin {
  late AnimationController _blastController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late Animation<double> _blastAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _scaleAnimation;
  
  int _countdown = 10;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    
    // Blast animation controller
    _blastController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Pulse animation controller
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    // Scale animation controller
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    // Blast animation - particles flying outward
    _blastAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _blastController, curve: Curves.elasticOut),
    );
    
    // Pulse animation for the success icon
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Scale animation for the card
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    
    // Start animations
    _blastController.forward();
    _pulseController.repeat(reverse: true);
    _scaleController.forward();
    
    // Start countdown timer
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });
      
      if (_countdown <= 0) {
        timer.cancel();
        _navigateToApplications();
      }
    });
  }

  void _navigateToApplications() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const MainNavScreen(initialIndex: 1),
      ),
      (route) => false,
    );
  }

  @override
  void dispose() {
    _blastController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF005DFF),
            Color(0xFF5BB5FF),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Blast animation container
                        AnimatedBuilder(
                          animation: _blastAnimation,
                          builder: (context, child) {
                            return Stack(
                              alignment: Alignment.center,
                              children: [
                                // Blast particles
                                ...List.generate(8, (index) {
                                  final angle = (index * 45) * (3.14159 / 180);
                                  final distance = 60 * _blastAnimation.value;
                                  final x = distance * cos(angle);
                                  final y = distance * sin(angle);
                                  
                                  return Positioned(
                                    left: 50 + x,
                                    top: 50 + y,
                                    child: AnimatedBuilder(
                                      animation: _blastAnimation,
                                      builder: (context, child) {
                                        return Opacity(
                                          opacity: 1 - _blastAnimation.value,
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                                
                                // Success icon with pulse animation
                                AnimatedBuilder(
                                  animation: _pulseAnimation,
                                  builder: (context, child) {
                                    return Transform.scale(
                                      scale: _pulseAnimation.value,
                                      child: Container(
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 48,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Success message
                        Text(
                          'Application Submitted!',
                          style: TextStyle(
                            color: const Color(0xFF005DFF),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 16),
                        
                        Text(
                          widget.thankYouMessage,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Countdown timer
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005DFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFF005DFF).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.timer,
                                color: Color(0xFF005DFF),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Redirecting in $_countdown seconds',
                                style: const TextStyle(
                                  color: Color(0xFF005DFF),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Montserrat',
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 24),
                        
                        // Manual navigation button
                        TextButton(
                          onPressed: _navigateToApplications,
                          child: const Text(
                            'View Applications Now',
                            style: TextStyle(
                              color: Color(0xFF005DFF),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
} 