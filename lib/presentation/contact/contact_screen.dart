import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'contact_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactScreen extends ConsumerWidget {
  const ContactScreen({super.key});

  void _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchWhatsApp(String number) async {
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactAsync = ref.watch(contactProvider);
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
        child: contactAsync.when(
          data: (contact) => Card(
            elevation: 12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Contact Us',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF005DFF),
                            fontFamily: 'Montserrat',
                          ),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 32),
                  ListTile(
                    leading: const Icon(Icons.location_on, color: Color(0xFF005DFF)),
                    title: Text(contact.officeAddress, style: const TextStyle(fontFamily: 'Montserrat')),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone, color: Color(0xFF005DFF)),
                    title: Text(contact.phone, style: const TextStyle(fontFamily: 'Montserrat')),
                    onTap: () => _launchPhone(contact.phone),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(Colors.green.withAlpha((0.12 * 255).toInt()), Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: const Text('Call', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.chat, color: Color(0xFF005DFF)),
                    title: const Text('WhatsApp Chat', style: TextStyle(fontFamily: 'Montserrat')),
                    onTap: () => _launchWhatsApp(contact.whatsapp),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(Colors.teal.withAlpha((0.12 * 255).toInt()), Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: const Text('Chat', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.email, color: Color(0xFF005DFF)),
                    title: Text(contact.email, style: const TextStyle(fontFamily: 'Montserrat')),
                    onTap: () => _launchEmail(contact.email),
                    trailing: Container(
                      decoration: BoxDecoration(
                        color: Color.alphaBlend(Colors.deepPurple.withAlpha((0.12 * 255).toInt()), Colors.white),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: const Text('Email', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Color(0xFF005DFF)),
                    title: Text(contact.hours, style: const TextStyle(fontFamily: 'Montserrat')),
                  ),
                ],
              ),
            ),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(
            child: Text('Failed to load contact info!\n$e', style: const TextStyle(color: Colors.red, fontFamily: 'Montserrat')),
          ),
        ),
      ),
    );
  }
}
