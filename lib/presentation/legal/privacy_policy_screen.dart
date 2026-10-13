import 'package:flutter/material.dart';

// Draft content for you to review and personalize before any real
// release. This is not legal advice; replace company-specific details
// and have it checked if the app will handle real customer data.
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Last updated: [add date before publishing]',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
          SizedBox(height: 16),
          _Section(
            title: 'Information we collect',
            body:
                'When you use ShopEase, we store the information you provide directly, '
                'such as your name, phone number, delivery address and the items in your '
                'cart and order history. This information is stored locally on your device.',
          ),
          _Section(
            title: 'How we use your information',
            body:
                'Your delivery address is used only to process and display your orders. '
                'We do not sell or share your personal information with third parties.',
          ),
          _Section(
            title: 'Payment information',
            body:
                'If card payments are enabled in a future version, payment details are '
                'handled directly by our payment processor and are never stored by this app.',
          ),
          _Section(
            title: 'Data storage',
            body:
                'Cart, wishlist, address and order data are stored locally on your device '
                'using on-device storage. Uninstalling the app removes this data.',
          ),
          _Section(
            title: 'Your choices',
            body:
                'You can clear your cart, remove items from your wishlist, or uninstall '
                'the app at any time to remove locally stored data.',
          ),
          _Section(
            title: 'Contact',
            body: 'Questions about this policy can be sent to [add contact email].',
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String body;
  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          const SizedBox(height: 6),
          Text(body, style: const TextStyle(height: 1.5)),
        ],
      ),
    );
  }
}
