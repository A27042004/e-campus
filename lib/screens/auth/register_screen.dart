import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/services/session_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/nav.dart';
import '../../widgets/widgets.dart';
import '../shell/main_shell.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _page = PageController();
  final _k1 = GlobalKey<FormState>();
  final _k2 = GlobalKey<FormState>();
  final _k3 = GlobalKey<FormState>();
  final _mobile = TextEditingController();
  final _otp = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _pass = TextEditingController();
  String _dept = 'Computer Science';
  String _sem = 'Semester 1';
  int _step = 0;
  bool _busy = false;

  static const _titles = ['Your mobile number', 'Verify OTP', 'Profile details'];
  static const _subs = [
    "We'll send a one-time password to verify it's you.",
    'Enter the 6-digit code we just sent.',
    'Almost done — tell us a little about yourself.',
  ];

  @override
  void dispose() {
    _page.dispose();
    _mobile.dispose();
    _otp.dispose();
    _name.dispose();
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    final key = [_k1, _k2, _k3][_step];
    if (!key.currentState!.validate()) return;
    setState(() => _busy = true);
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _busy = false);

    if (_step == 2) {
      context.read<SessionProvider>().register(
            name: _name.text.trim(),
            email: _email.text.trim(),
            phone: _mobile.text.trim(),
            department: _dept,
            semester: _sem,
          );
      Navigator.of(context).pushAndRemoveUntil(fadeRoute(const MainShell()), (_) => false);
      return;
    }
    if (_step == 0) showSnack(context, 'OTP sent to +91 ${_mobile.text.trim()}');
    setState(() => _step++);
    _page.animateToPage(_step, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
  }

  void _back() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      setState(() => _step--);
      _page.animateToPage(_step, duration: const Duration(milliseconds: 350), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = Pal.of(context);
    final t = Theme.of(context).textTheme;

    return PopScope(
      canPop: _step == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Create account',
          leading: Padding(
            padding: const EdgeInsets.only(left: 12),
            child: IconButton(
              tooltip: 'Back',
              onPressed: _back,
              icon: const Icon(Icons.arrow_back_rounded),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(3, (i) {
                            return Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                height: 6,
                                margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                                decoration: BoxDecoration(
                                  gradient: i <= _step ? AppColors.brandGradient : null,
                                  color: i <= _step ? null : p.border,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 14),
                        Text('STEP ${_step + 1} OF 3', style: t.labelSmall?.copyWith(color: p.primary)),
                        const SizedBox(height: 4),
                        Text(_titles[_step], style: t.headlineSmall),
                        const SizedBox(height: 4),
                        Text(_subs[_step], style: t.bodyMedium?.copyWith(color: p.subtext)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PageView(
                      controller: _page,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [_step1(), _step2(), _step3()],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                    child: CustomButton(
                      label: _step == 2 ? 'Create account' : (_step == 1 ? 'Verify' : 'Send OTP'),
                      loading: _busy,
                      onPressed: _next,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrap(Widget child) => SingleChildScrollView(padding: const EdgeInsets.all(20), child: child);

  Widget _step1() => _wrap(Form(
        key: _k1,
        child: CustomTextField(
          label: 'Mobile number',
          hint: '10-digit mobile number',
          icon: Icons.phone_iphone_rounded,
          controller: _mobile,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          formatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (v) => RegExp(r'^\d{10}$').hasMatch((v ?? '').trim()) ? null : 'Enter a valid 10-digit number',
        ),
      ));

  Widget _step2() => _wrap(Form(
        key: _k2,
        child: Column(
          children: [
            CustomTextField(
              label: 'Verification code',
              hint: '••••••',
              controller: _otp,
              keyboardType: TextInputType.number,
              maxLength: 6,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: 12),
              formatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (v) => (v ?? '').length == 6 ? null : 'Enter the 6-digit code',
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => showSnack(context, 'A new OTP has been sent'),
              child: const Text("Didn't get it? Resend OTP"),
            ),
          ],
        ),
      ));

  Widget _step3() {
    const depts = ['Computer Science', 'Information Technology', 'Electronics', 'Mechanical', 'Civil'];
    final sems = List.generate(8, (i) => 'Semester ${i + 1}');
    return _wrap(Form(
      key: _k3,
      child: Column(
        children: [
          CustomTextField(
            label: 'Full name',
            hint: 'Your full name',
            icon: Icons.badge_outlined,
            controller: _name,
            action: TextInputAction.next,
            validator: (v) => (v ?? '').trim().length < 3 ? 'Please enter your full name' : null,
          ),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Email',
            hint: 'you@college.edu',
            icon: Icons.mail_outline_rounded,
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim())
                ? null
                : 'Enter a valid email address',
          ),
          const SizedBox(height: 16),
          _dropdown('Department', _dept, depts, (v) => setState(() => _dept = v)),
          const SizedBox(height: 16),
          _dropdown('Semester', _sem, sems, (v) => setState(() => _sem = v)),
          const SizedBox(height: 16),
          CustomTextField(
            label: 'Password',
            hint: 'At least 6 characters',
            icon: Icons.lock_outline_rounded,
            controller: _pass,
            obscure: true,
            validator: (v) => (v ?? '').length < 6 ? 'Password must be at least 6 characters' : null,
          ),
        ],
      ),
    ));
  }

  Widget _dropdown(String label, String value, List<String> items, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 2),
          child: Text(label, style: Theme.of(context).textTheme.titleSmall),
        ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          borderRadius: BorderRadius.circular(14),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ],
    );
  }
}
