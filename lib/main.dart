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
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/config/config_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  // Print debug information
  AppConfig.printDebugInfo();
  
  runApp(const ProviderScope(child: ChittiFinserveApp()));
}

class ChittiFinserveApp extends ConsumerWidget {
  const ChittiFinserveApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Chitti Finserv',
      theme: appTheme(context, isDark: false),
      darkTheme: appTheme(context, isDark: false),
      themeMode: ThemeMode.light,
      home: ForceUpdateWrapper(child: const SplashRouterScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ForceUpdateWrapper extends ConsumerStatefulWidget {
  final Widget child;
  const ForceUpdateWrapper({required this.child, super.key});
  @override
  ConsumerState<ForceUpdateWrapper> createState() => _ForceUpdateWrapperState();
}

class _ForceUpdateWrapperState extends ConsumerState<ForceUpdateWrapper> {
  bool _showDialog = false;
  String _updateMessage = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForceUpdate());
  }

  Future<void> _checkForceUpdate() async {
    final configAsync = ref.read(appConfigProvider);
    configAsync.whenData((config) {
      final forceUpdate = config.forceUpdate;
      final isActive = forceUpdate['isActive'] == true;
      final requiredVersion = forceUpdate['version'] ?? '1.0.0';
      final message = forceUpdate['message'] ?? 'A new version is available. Please update to continue.';
      if (isActive && _isVersionLess(AppConfig.appVersion, requiredVersion)) {
        setState(() {
          _showDialog = true;
          _updateMessage = message;
        });
      }
    });
  }

  bool _isVersionLess(String current, String required) {
    final c = current.split('.').map(int.parse).toList();
    final r = required.split('.').map(int.parse).toList();
    for (int i = 0; i < 3; i++) {
      if (c[i] < r[i]) return true;
      if (c[i] > r[i]) return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final configAsync = ref.watch(appConfigProvider);
    String androidUrl = '';
    String iosUrl = '';
    configAsync.whenData((config) {
      androidUrl = config.forceUpdate['androidUrl'] ?? '';
      iosUrl = config.forceUpdate['iosUrl'] ?? '';
    });
    return Stack(
      children: [
        widget.child,
        if (_showDialog)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Update Required'),
                      content: Text(_updateMessage),
                      actions: [
                        ElevatedButton(
                          onPressed: () async {
                            final url = Theme.of(context).platform == TargetPlatform.iOS
                              ? iosUrl
                              : androidUrl;
                            if (url.isNotEmpty && await canLaunch(url)) {
                              await launch(url);
                            }
                          },
                          child: const Text('Update Now'),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
      ],
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
    try {
      // Check if user has a valid auth token
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      setState(() {
        // If token exists and is not empty, user is logged in
        _autoLogin = token != null && token.isNotEmpty;
      });
    } catch (e) {
      setState(() {
        _autoLogin = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_autoLogin == null) {
      return const SplashScreen();
    } else if (_autoLogin == true) {
      return const MainNavScreen();
    } else {
      return const LoginScreen();
    }
  }
}

class MainNavScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavScreen({super.key, this.initialIndex = 0});
  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }
  final List<Widget> _screens = const [
    HomeScreen(),
    AppliedLoansScreen(),
    EmiScreen(),
    ReferralScreen(),
    ContactScreen(),
    ProfileScreen(),
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
