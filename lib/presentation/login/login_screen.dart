import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'login_provider.dart';
import '../../main.dart';
import '../../data/model/login_model.dart';
import '../profile/profile_completion_screen.dart';
import '../profile/profile_provider.dart';
import '../../core/app_config.dart';
import '../../core/image_utils.dart';

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
  int _resendTimer = 0;
  Timer? _timer;
  
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
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = 60; // 60 seconds
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendTimer > 0) {
          _resendTimer--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  Future<void> _getOtp() async {
    if (_mobileController.text.isEmpty) {
      setState(() {
        _error = 'Please enter mobile number';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final loginState = ref.read(loginStateProvider.notifier);
      await loginState.sendOTP(_mobileController.text);
      
      setState(() {
        _loading = false;
        _otpSent = true;
      });
      
      _startResendTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _resendOtp() async {
    if (_resendTimer > 0) return;
    
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final loginState = ref.read(loginStateProvider.notifier);
      await loginState.sendOTP(_mobileController.text);
      
      setState(() {
        _loading = false;
      });
      
      _startResendTimer();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP resent successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _verifyOtp() async {
    if (_otpController.text.isEmpty) {
      setState(() {
        _error = 'Please enter OTP';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final loginState = ref.read(loginStateProvider.notifier);
      await loginState.verifyOTP(_mobileController.text, _otpController.text);

      // After OTP verification, fetch profile
      final profileNotifier = ref.read(profileProvider.notifier);
      await profileNotifier.loadProfile();
      final profile = ref.read(profileProvider).value;
      
      setState(() {
        _loading = false;
      });

      // Check for temporary email and name
      final email = profile?.email?.trim().toLowerCase() ?? '';
      final name = profile?.name?.trim() ?? '';

      final isTempEmail = email.isEmpty ||
          (email.startsWith('temp_') && email.endsWith('@chittifinserv.com'));
      final isTempName = name.isEmpty || name == 'Temporary User';

      final needsProfileCompletion = isTempEmail || isTempName;

      if (needsProfileCompletion) {
        // Incomplete or temporary profile - navigate to profile completion
        Future.microtask(() {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ProfileCompletionScreen(
                mobileNumber: _mobileController.text,
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              transitionDuration: const Duration(milliseconds: 800),
            ),
          );
        });
      } else {
        // Complete profile - navigate to home screen
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
      }
    } catch (e) {
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginAsync = ref.watch(loginConfigProvider);
    final appConfigAsync = ref.watch(appConfigProvider);
    
    return Scaffold(
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Container(
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
              return appConfigAsync.when(
                data: (appConfig) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Display logo from splash configuration
                      if (appConfig.splash['logo'] != null && appConfig.splash['logo'].toString().isNotEmpty)
                        Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              ImageUtils.getImageUrl(appConfig.splash['logo']),
                              fit: BoxFit.contain,
                              headers: {
                                'Accept': 'image/*',
                                'User-Agent': 'Flutter/1.0',
                                'Cache-Control': 'no-cache',
                              },
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF005DFF),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('🔧 Login Logo Error:');
                                print('   URL: ${ImageUtils.getImageUrl(appConfig.splash['logo'])}');
                                print('   Error: $error');
                                print('   Stack: $stackTrace');
                                return Container(
                                  height: 120,
                                  width: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.account_balance,
                                        size: 40,
                                        color: Color(0xFF005DFF),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Logo Error',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        config.welcomeTitle ?? 'Welcome to Chitti Finserv',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          color: Colors.white,
                        ),
                      ),
                      if (config.welcomeSubtitle != null && config.welcomeSubtitle!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            config.welcomeSubtitle!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontFamily: 'Montserrat',
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      _buildLoginCard(config),
                    ],
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
                error: (e, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.account_balance,
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      config.welcomeTitle ?? 'Welcome to Chitti Finserv',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                      ),
                    ),
                    if (config.welcomeSubtitle != null && config.welcomeSubtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          config.welcomeSubtitle!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    _buildLoginCard(config),
                  ],
                ),
              );
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

  Widget _buildLoginCard(LoginModel config) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
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
              // Error message
              if (_error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Text(
                    _error!,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              if (_error != null) const SizedBox(height: 16),
              
              // Mobile number input
              TextField(
                controller: _mobileController,
                enabled: !_otpSent,
                keyboardType: TextInputType.phone,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
                decoration: InputDecoration(
                  labelText: config.mobileLabel ?? 'Mobile Number',
                  hintText: 'Enter your mobile number',
                  prefixIcon: const Icon(Icons.phone),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
                  ),
                ),
              ),

              // OTP input (shown after OTP is sent)
              if (_otpSent) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                  ),
                  decoration: InputDecoration(
                    labelText: config.otpLabel ?? 'OTP',
                    hintText: 'Enter OTP',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF005DFF), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t receive OTP? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    TextButton(
                      onPressed: _resendTimer > 0 ? null : _resendOtp,
                      child: Text(
                        _resendTimer > 0
                            ? 'Resend in ${_resendTimer}s'
                            : 'Resend OTP',
                        style: const TextStyle(
                          color: Color(0xFF005DFF),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              
              const SizedBox(height: 24),

              // Action button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _loading
                      ? null
                      : _otpSent
                          ? _verifyOtp
                          : _getOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005DFF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(_otpSent ? (config.verifyOtpButton ?? 'Verify OTP') : (config.getOtpButton ?? 'Get OTP')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
