import 'package:flutter/material.dart';

// A plain FilledButton that briefly shows a checkmark and label after
// a successful add-to-cart, using only implicit animations (no
// decorative motion beyond confirming the action actually happened).
class AddToCartButton extends StatefulWidget {
  final bool enabled;
  final Future<void> Function() onAddToCart;

  const AddToCartButton({super.key, required this.enabled, required this.onAddToCart});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  bool _justAdded = false;

  Future<void> _handleTap() async {
    await widget.onAddToCart();
    if (!mounted) return;
    setState(() => _justAdded = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() => _justAdded = false);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _justAdded ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      child: FilledButton(
        onPressed: widget.enabled && !_justAdded ? _handleTap : null,
        style: _justAdded
            ? FilledButton.styleFrom(backgroundColor: Colors.green.shade600)
            : null,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _justAdded
              ? const Row(
                  key: ValueKey('added'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 18, color: Colors.white),
                    SizedBox(width: 6),
                    Text('Added'),
                  ],
                )
              : const Text('Add to Cart', key: ValueKey('add')),
        ),
      ),
    );
  }
}
