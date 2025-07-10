import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {
  String? _referralCode;

  void _generateReferral() {
    setState(() {
      _referralCode = 'CHITTI${Random().nextInt(100000).toString().padLeft(5, '0')}';
    });
  }

  void _shareApp() {
    if (_referralCode != null) {
      Share.share('Check out Chitti Finserve! Use my referral code: $_referralCode');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF005DFF), Color(0xFF5BB5FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Card(
          elevation: 12,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Refer a Friend',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF005DFF),
                          fontFamily: 'Montserrat',
                        ),
                    textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005DFF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Montserrat'),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _generateReferral,
                  icon: const Icon(Icons.card_giftcard),
                  label: const Text('Generate Referral Code'),
                ),
                if (_referralCode != null) ...[
                  const SizedBox(height: 28),
                  Text('Your Referral Code:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontFamily: 'Montserrat')),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Color.alphaBlend(const Color(0xFF5BB5FF).withAlpha((0.12 * 255).toInt()), Colors.white),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      _referralCode!,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF005DFF), fontFamily: 'Montserrat', letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Montserrat'),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _shareApp,
                    icon: const Icon(Icons.share),
                    label: const Text('Share App'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
