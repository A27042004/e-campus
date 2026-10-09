import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscure;
  final int? maxLength;
  final TextInputAction? action;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? formatters;
  final TextAlign textAlign;
  final TextStyle? style;

  const CustomTextField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.controller,
    this.validator,
    this.keyboardType,
    this.obscure = false,
    this.maxLength,
    this.action,
    this.onChanged,
    this.formatters,
    this.textAlign = TextAlign.start,
    this.style,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _hide = widget.obscure;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2),
          child: Text(widget.label, style: t.titleSmall),
        ),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: _hide,
          maxLength: widget.maxLength,
          textInputAction: widget.action,
          onChanged: widget.onChanged,
          inputFormatters: widget.formatters,
          textAlign: widget.textAlign,
          style: widget.style ?? t.bodyLarge,
          decoration: InputDecoration(
            hintText: widget.hint,
            counterText: '',
            prefixIcon: widget.icon == null ? null : Icon(widget.icon, size: 20),
            suffixIcon: widget.obscure
                ? IconButton(
                    tooltip: _hide ? 'Show password' : 'Hide password',
                    icon: Icon(_hide ? Icons.visibility_off_rounded : Icons.visibility_rounded, size: 20),
                    onPressed: () => setState(() => _hide = !_hide),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
