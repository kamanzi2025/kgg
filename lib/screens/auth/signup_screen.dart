import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_strings.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _selectedRole = AppStrings.roleStudent;
  String _selectedCampus = AppStrings.campusKigali;
  bool _loading = false;
  bool _obscurePass = true;

  static const _roles = [
    AppStrings.roleStudent,
    AppStrings.roleClubLeader,
    AppStrings.roleOrganizer,
    AppStrings.roleEntrepreneur,
  ];

  static const _campuses = [
    AppStrings.campusKigali,
    AppStrings.campusMauritius,
    AppStrings.campusRemote,
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await context.read<AppProvider>().login(
          _nameCtrl.text.trim(),
          _emailCtrl.text.trim(),
          _selectedRole,
          _selectedCampus,
        );
    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.main);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Create Account',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Join the ALU Connect community',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputField(
                      controller: _nameCtrl,
                      label: AppStrings.fullName,
                      icon: Icons.person_outline,
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Full name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _emailCtrl,
                      label: AppStrings.email,
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Email is required';
                        if (!v.contains('@')) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    InputField(
                      controller: _passCtrl,
                      label: AppStrings.password,
                      icon: Icons.lock_outline,
                      obscureText: _obscurePass,
                      suffix: IconButton(
                        icon: Icon(
                          _obscurePass
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () =>
                            setState(() => _obscurePass = !_obscurePass),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'Minimum 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _DropdownField(
                      label: AppStrings.selectRole,
                      value: _selectedRole,
                      items: _roles,
                      icon: Icons.badge_outlined,
                      onChanged: (v) => setState(() => _selectedRole = v!),
                    ),
                    const SizedBox(height: 14),
                    _DropdownField(
                      label: AppStrings.selectCampus,
                      value: _selectedCampus,
                      items: _campuses,
                      icon: Icons.location_city_outlined,
                      onChanged: (v) => setState(() => _selectedCampus = v!),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              CustomButton(
                label: AppStrings.signup,
                width: double.infinity,
                isLoading: _loading,
                onTap: _signup,
              ),
              const SizedBox(height: 16),
              Center(
                child: GestureDetector(
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: 'Sign In',
                          style: TextStyle(
                            color: AppColors.accentGold,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final IconData icon;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      onChanged: onChanged,
      dropdownColor: AppColors.cardBackground,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 20),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentGold),
        ),
      ),
      items: items
          .map((r) => DropdownMenuItem(value: r, child: Text(r)))
          .toList(),
    );
  }
}
