import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/models.dart';
import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../shell/main_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _pass = TextEditingController();
  final _otp = TextEditingController();
  bool _otpMode = false, _loading = false;
  UserRole _role = UserRole.student;

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    _otp.dispose();
    super.dispose();
  }

  String? _validId(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Please enter your email or mobile number';
    final email = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s);
    final phone = RegExp(r'^\d{10}$').hasMatch(s);
    return email || phone ? null : 'Enter a valid email or 10-digit mobile number';
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900)); // replace with real auth
    if (!mounted) return;
    context.read<SessionProvider>().login(_role, identifier: _id.text.trim());
    Navigator.of(context).pushReplacement(fadeRoute(const MainShell()));
  }

  void _forgot() {
    final c = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Reset password', style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 6),
            Text("Enter your registered email and we'll send you a reset link.",
                style: Theme.of(ctx).textTheme.bodySmall),
            const SizedBox(height: 18),
            CustomTextField(
                label: 'Email', hint: 'you@college.edu', icon: Icons.mail_outline_rounded, controller: c,
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 18),
            CustomButton(
              label: 'Send reset link',
              onPressed: () {
                Navigator.pop(ctx);
                showSnack(context, 'If the account exists, a reset link has been sent.');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;
    final h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // abstract header
          Container(
            height: h * 0.42,
            decoration: const BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
            ),
            child: Stack(children: [
              Positioned(top: -50, right: -40, child: _blob(200, 0.08)),
              Positioned(top: 120, left: -60, child: _blob(160, 0.06)),
            ]),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    children: [
                      const FadeSlideIn(child: AppLogo(size: 68)),
                      const SizedBox(height: 14),
                      FadeSlideIn(
                        delayMs: 80,
                        child: Column(children: [
                          Text('Welcome back 👋',
                              style: t.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Sign in to continue to E-Campus',
                              style: t.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.85))),
                        ]),
                      ),
                      const SizedBox(height: 24),
                      FadeSlideIn(
                        delayMs: 160,
                        child: DashboardCard(
                          radius: 28,
                          padding: const EdgeInsets.all(22),
                          child: Form(
                            key: _form,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _modeToggle(p),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  label: 'Email or mobile',
                                  hint: 'you@college.edu or 9876543210',
                                  icon: Icons.person_outline_rounded,
                                  controller: _id,
                                  validator: _validId,
                                  keyboardType: TextInputType.emailAddress,
                                  action: TextInputAction.next,
                                ),
                                const SizedBox(height: 16),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 250),
                                  child: _otpMode
                                      ? Column(
                                          key: const ValueKey('otp'),
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomTextField(
                                              label: 'One-time password',
                                              hint: '6-digit OTP',
                                              icon: Icons.pin_outlined,
                                              controller: _otp,
                                              keyboardType: TextInputType.number,
                                              maxLength: 6,
                                              validator: (v) => (v ?? '').trim().length == 6
                                                  ? null
                                                  : 'Enter the 6-digit OTP',
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                onPressed: () {
                                                  if (_validId(_id.text) != null) {
                                                    showSnack(context, 'Enter your email or mobile first');
                                                  } else {
                                                    showSnack(context, 'OTP sent to ${_id.text.trim()}');
                                                  }
                                                },
                                                child: const Text('Send OTP'),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          key: const ValueKey('pass'),
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CustomTextField(
                                              label: 'Password',
                                              hint: 'Enter your password',
                                              icon: Icons.lock_outline_rounded,
                                              controller: _pass,
                                              obscure: true,
                                              action: TextInputAction.done,
                                              validator: (v) => (v ?? '').length >= 6
                                                  ? null
                                                  : 'Password must be at least 6 characters',
                                            ),
                                            Align(
                                              alignment: Alignment.centerRight,
                                              child: TextButton(
                                                  onPressed: _forgot, child: const Text('Forgot password?')),
                                            ),
                                          ],
                                        ),
                                ),
                                const SizedBox(height: 4),
                                Text('SIGN IN AS (DEMO)', style: t.labelSmall),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: UserRole.values
                                      .map((r) => ChoiceChip(
                                            label: Text(r == UserRole.cr ? 'CR' : roleLabel(r)),
                                            selected: _role == r,
                                            onSelected: (_) => setState(() => _role = r),
                                            showCheckmark: false,
                                            selectedColor: p.primary.withOpacity(0.16),
                                            labelStyle: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                              color: _role == r ? p.primary : p.subtext,
                                            ),
                                            side: BorderSide(color: _role == r ? p.primary : p.border),
                                          ))
                                      .toList(),
                                ),
                                const SizedBox(height: 22),
                                CustomButton(label: 'Login', loading: _loading, onPressed: _submit),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      FadeSlideIn(
                        delayMs: 240,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?", style: t.bodyMedium?.copyWith(color: p.subtext)),
                            TextButton(
                              onPressed: () => pushPage(context, const RegisterScreen()),
                              child: const Text('Register', style: TextStyle(fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _modeToggle(Pal p) {
    Widget seg(String label, bool otp) {
      final sel = _otpMode == otp;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() => _otpMode = otp),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: sel ? p.card : Colors.transparent,
              borderRadius: BorderRadius.circular(11),
              boxShadow: sel ? p.shadow : null,
            ),
            alignment: Alignment.center,
            child: Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 13.5, color: sel ? p.primary : p.subtext)),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: p.soft, borderRadius: BorderRadius.circular(14)),
      child: Row(children: [seg('Password', false), seg('OTP', true)]),
    );
  }

  Widget _blob(double s, double o) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(color: Colors.white.withOpacity(o), shape: BoxShape.circle),
      );
}
