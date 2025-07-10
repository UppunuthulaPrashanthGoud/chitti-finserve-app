import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'login_provider.dart';
import '../../main.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _mobileController = TextEditingController();
  final _otpController = TextEditingController();
  bool _otpSent = false;
  bool _loading = false;
  String? _error;
  bool _loggedIn = false;
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _getOtp(int otpLength) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _loading = false;
      _otpSent = true;
    });
  }

  void _verifyOtp(int otpLength, String successMsg, String errorMsg) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_otpController.text == List.filled(otpLength, '1').join()) {
      setState(() {
        _loading = false;
        _loggedIn = true;
      });
      // Navigate to MainNavScreen after login
      Future.microtask(() {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainNavScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      });
    } else {
      setState(() {
        _loading = false;
        _error = errorMsg;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginAsync = ref.watch(loginConfigProvider);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: loginAsync.when(
            data: (config) {
              if (_loggedIn) {
                return _buildSuccessCard(config);
              }
              return _buildLoginCard(config);
            },
            loading: () => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            error: (e, _) => Center(
              child: Card(
                elevation: 12,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                      const SizedBox(height: 16),
                      Text(
                        'Failed to load login config!',
                        style: TextStyle(
                          color: Colors.red[300],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        e.toString(),
                        style: TextStyle(
                          color: Colors.red[200],
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(dynamic config) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 16,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              child: Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header with Animation
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF005DFF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.lock_outline,
                            size: 48,
                            color: const Color(0xFF005DFF),
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                        config.title,
                              textStyle: const TextStyle(
                                color: Color(0xFF005DFF),
                                fontSize: 24,
                              fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                              ),
                              speed: const Duration(milliseconds: 100),
                            ),
                          ],
                          totalRepeatCount: 1,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your mobile number to continue',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                              fontFamily: 'Montserrat',
                            ),
                        textAlign: TextAlign.center,
                      ),
                      ],
                    ),
                    
                      const SizedBox(height: 32),
                    
                    // Mobile Number Input
                      TextField(
                        controller: _mobileController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontFamily: 'Montserrat'),
                        decoration: InputDecoration(
                          labelText: config.mobileLabel,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: const Icon(Icons.phone, color: Color(0xFF005DFF)),
                        filled: true,
                        fillColor: Colors.grey[50],
                        enabled: !_otpSent,
                      ),
                    ),
                    
                      const SizedBox(height: 20),
                    
                    // OTP Input
                      if (_otpSent)
                        TextField(
                          controller: _otpController,
                          keyboardType: TextInputType.number,
                          maxLength: config.otpLength,
                          style: const TextStyle(fontFamily: 'Montserrat'),
                          decoration: InputDecoration(
                            labelText: config.otpLabel,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          prefixIcon: const Icon(Icons.lock, color: Color(0xFF005DFF)),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                      ),
                    
                      const SizedBox(height: 20),
                    
                    // Error Message
                      if (_error != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.error_outline, color: Colors.red[300], size: 20),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: TextStyle(
                                  color: Colors.red[700],
                                  fontFamily: 'Montserrat',
                                  fontSize: 14,
                                ),
                              ),
                        ),
                          ],
                        ),
                      ),
                    
                    const SizedBox(height: 24),
                    
                    // Submit Button
                      _loading
                        ? const Center(child: CircularProgressIndicator())
                          : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF005DFF),
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  fontFamily: 'Montserrat',
                                ),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                elevation: 4,
                                ),
                                onPressed: _otpSent
                                  ? () => _verifyOtp(config.otpLength, config.successMessage, config.errorMessage)
                                    : () => _getOtp(config.otpLength),
                                child: Text(_otpSent ? config.verifyOtpButton : config.getOtpButton),
                              ),
                            ),
                    ],
                  ),
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessCard(dynamic config) {
    return Center(
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green[600],
                  size: 48,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                config.successMessage,
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Redirecting to home...',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
