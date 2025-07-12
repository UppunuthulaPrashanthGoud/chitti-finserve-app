import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'core/app_config.dart';
import 'presentation/splash/splash_screen.dart';
import 'presentation/login/login_screen.dart';
import 'presentation/home/home_screen.dart';
import 'presentation/emi/emi_screen.dart';
import 'presentation/referral/referral_screen.dart';
import 'presentation/contact/contact_screen.dart';
import 'presentation/applied_loans/applied_loans_screen.dart';
import 'presentation/profile/profile_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // Print debug information
  AppConfig.printDebugInfo();
  
  runApp(const ProviderScope(child: ChittiFinserveApp()));
}

class ChittiFinserveApp extends StatelessWidget {
  const ChittiFinserveApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chitti Finserve',
      theme: appTheme(context, isDark: false),
      darkTheme: appTheme(context, isDark: false),
      themeMode: ThemeMode.light,
      home: const SplashRouterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashRouterScreen extends StatefulWidget {
  const SplashRouterScreen({super.key});

  @override
  State<SplashRouterScreen> createState() => _SplashRouterScreenState();
}

class _SplashRouterScreenState extends State<SplashRouterScreen> {
  bool? _autoLogin;

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // TODO: Replace with real secure storage/session logic later
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _autoLogin = false; // Simulate not logged in for now
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_autoLogin == null) {
      return SplashScreen();
    } else if (_autoLogin == true) {
      return MainNavScreen();
    } else {
      return LoginScreen();
    }
  }
}

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int _selectedIndex = 0;
  final List<Widget> _screens = const [
    HomeScreen(),
    AppliedLoansScreen(),
    EmiScreen(),
    ReferralScreen(),
    ContactScreen(),
    ProfileScreen(),
  ];
  final List<String> _titles = const [
    'Home',
    'My Applications',
    'EMI Calculator',
    'Referral',
    'Contact Us',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Applications'),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'EMI'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Referral'),
          BottomNavigationBarItem(icon: Icon(Icons.contact_mail), label: 'Contact'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
