import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

class CustomButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading, outlined, small, expanded;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.loading = false,
    this.outlined = false,
    this.small = false,
    this.expanded = true,
    this.gradient,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final disabled = widget.onPressed == null;
    final fg = widget.outlined ? p.primary : Colors.white;
    final radius = BorderRadius.circular(14);

    final content = widget.loading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2.4, color: fg),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon, size: 20, color: fg),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Text(
                  widget.label,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: fg, fontSize: widget.small ? 13 : 15),
                ),
              ),
            ],
          );

    return Listener(
      onPointerDown: (_) => setState(() => _down = true),
      onPointerUp: (_) => setState(() => _down = false),
      onPointerCancel: (_) => setState(() => _down = false),
      child: AnimatedScale(
        scale: _down ? 0.97 : 1,
        duration: const Duration(milliseconds: 100),
        child: Opacity(
          opacity: disabled && !widget.loading ? 0.5 : 1,
          child: Container(
            width: widget.expanded ? double.infinity : null,
            height: widget.small ? 40 : 52,
            decoration: BoxDecoration(
              gradient: widget.outlined ? null : (widget.gradient ?? AppColors.brandGradient),
              borderRadius: radius,
              border: widget.outlined ? Border.all(color: p.primary.withOpacity(0.5), width: 1.4) : null,
              boxShadow: widget.outlined || p.dark
                  ? null
                  : [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.25),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      )
                    ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: radius,
                onTap: widget.loading ? null : widget.onPressed,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: widget.small ? 16 : 20),
                  child: Center(child: content),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
