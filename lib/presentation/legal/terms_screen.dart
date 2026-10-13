import 'package:flutter/material.dart';

// Draft content for you to review and personalize before any real
// release. Not legal advice.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms and Conditions')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          Text('Last updated: [add date before publishing]',
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
          SizedBox(height: 16),
          _Section(
            title: 'Acceptance of terms',
            body:
                'By using ShopEase, you agree to these terms. If you do not agree, '
                'please do not use the app.',
          ),
          _Section(
            title: 'Orders',
            body:
                'Placing an order through the app is a request to purchase the listed '
                'items. Orders may be cancelled before dispatch; contact support for help '
                'with an existing order.',
          ),
          _Section(
            title: 'Pricing',
            body:
                'Prices are shown in US dollars and may change without notice. We make '
                'reasonable efforts to keep pricing accurate.',
          ),
          _Section(
            title: 'Payment',
            body:
                'Cash on Delivery orders are paid directly to the courier on delivery. '
                'Card payments, where available, are processed securely by our payment '
                'provider.',
          ),
          _Section(
            title: 'Limitation of liability',
            body:
                'ShopEase is provided as-is. We are not liable for indirect damages '
                'arising from use of the app, to the extent permitted by law.',
          ),
          _Section(
            title: 'Changes to these terms',
            body: 'These terms may be updated from time to time; continued use of the '
                'app after changes means you accept the updated terms.',
          ),
          _Section(
            title: 'Contact',
            body: 'Questions about these terms can be sent to [add contact email].',
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
