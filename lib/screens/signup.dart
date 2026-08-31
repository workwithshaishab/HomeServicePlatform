import 'package:flutter/material.dart';
import '../main.dart';
import '../services/auth_service.dart';
import '../services/provider_service.dart';
import 'login.dart';

class SignupPage extends StatefulWidget {
  final UserRole role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _customCategoryController = TextEditingController();

  static const String _otherCategoryValue = 'Other';

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;
  bool _submitted = false;
  String? _errorMessage;

  List<String> _categories = [];
  bool _loadingCategories = true;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    if (widget.role == UserRole.provider) {
      _loadCategories();
    }
  }

  Future<void> _loadCategories() async {
    final categories = await ProviderService.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = [...categories, _otherCategoryValue];
      _loadingCategories = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _customCategoryController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your full name';
    if (v.length < 2) return 'Name is too short';
    return null;
  }

  String? _validateIdentifier(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your email or phone number';

    final isEmailLike = v.contains('@');
    if (isEmailLike) {
      final emailRegex = RegExp(r'^[\w\.\-\+]+@[\w\-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(v)) return 'Enter a valid email address';
    } else {
      final digitsOnly = v.replaceAll(RegExp(r'[^0-9]'), '');
      if (digitsOnly.length < 7) return 'Enter a valid phone number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Enter a password';
    if (v.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != _passwordController.text) return 'Passwords do not match';
    return null;
  }

  String? _validateCategory(String? value) {
    if (widget.role != UserRole.provider) return null;
    if (value == null || value.isEmpty) return 'Select the type of service you offer';
    return null;
  }

  String? _validateCustomCategory(String? value) {
    if (widget.role != UserRole.provider) return null;
    if (_selectedCategory != _otherCategoryValue) return null;
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Enter your service type';
    if (v.length < 2) return 'Service type is too short';
    return null;
  }

  /// The value actually sent to the backend: the predefined category, or
  /// the custom text if "Other" was picked.
  String? get _resolvedServiceCategory {
    if (widget.role != UserRole.provider) return null;
    if (_selectedCategory == _otherCategoryValue) {
      return _customCategoryController.text.trim();
    }
    return _selectedCategory;
  }

  Future<void> _handleSignup() async {
    setState(() {
      _errorMessage = null;
      _submitted = true;
    });

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final roleString = widget.role == UserRole.customer ? 'customer' : 'provider';

      await AuthService.signup(
        fullName: _nameController.text,
        identifier: _emailController.text,
        password: _passwordController.text,
        role: roleString,
        serviceCategory: _resolvedServiceCategory,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
              SizedBox(width: 10),
              Text('Account created successfully! Please log in.'),
            ],
          ),
          backgroundColor: kPrimaryGreen,
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1800),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;

      // Signing up only creates the account — the home page is reached by
      // logging in afterwards, not directly from signup.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage(role: widget.role)),
      );
    } on AuthException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please check your connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isProvider = widget.role == UserRole.provider;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded),
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              Icon(Icons.home_repair_service_rounded, color: kAccentGreen, size: 56),
              const SizedBox(height: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
                  children: [
                    TextSpan(text: 'Ghar', style: TextStyle(color: kDarkText)),
                    TextSpan(text: 'Sewa', style: TextStyle(color: kAccentGreen)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Home Services, Simplified.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),
              Text(
                'Create Account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: kDarkText),
              ),
              const SizedBox(height: 6),
              Text(
                isProvider
                    ? 'Sign up to start offering your services'
                    : 'Sign up to start booking home services',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 24),

              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline_rounded, color: Colors.red.shade400, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(fontSize: 13, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),

              Form(
                key: _formKey,
                autovalidateMode: _submitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Full Name',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kDarkText),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      validator: _validateName,
                      decoration: _fieldDecoration(
                        hint: 'Enter your full name',
                        icon: Icons.badge_outlined,
                      ),
                    ),
                    if (widget.role == UserRole.provider) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Type of Service You Offer',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kDarkText),
                      ),
                      const SizedBox(height: 8),
                      _loadingCategories
                          ? Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              alignment: Alignment.centerLeft,
                              child: const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(strokeWidth: 2, color: kPrimaryGreen),
                              ),
                            )
                          : DropdownButtonFormField<String>(
                              value: _selectedCategory,
                              validator: _validateCategory,
                              decoration: _fieldDecoration(
                                hint: 'Select a service category',
                                icon: Icons.handyman_outlined,
                              ),
                              items: _categories
                                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (value) => setState(() => _selectedCategory = value),
                            ),
                      if (_selectedCategory == _otherCategoryValue) ...[
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _customCategoryController,
                          textCapitalization: TextCapitalization.words,
                          validator: _validateCustomCategory,
                          decoration: _fieldDecoration(
                            hint: 'Enter your service type (e.g. Roofing)',
                            icon: Icons.edit_outlined,
                          ),
                        ),
                      ],
                    ],
                    const SizedBox(height: 20),
                    const Text(
                      'Email or Phone Number',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kDarkText),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateIdentifier,
                      decoration: _fieldDecoration(
                        hint: 'Enter your email or phone number',
                        icon: Icons.person_outline_rounded,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kDarkText),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      validator: _validatePassword,
                      decoration: _fieldDecoration(
                        hint: 'Create a password (min. 6 characters)',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Confirm Password',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: kDarkText),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      validator: _validateConfirmPassword,
                      decoration: _fieldDecoration(
                        hint: 'Re-enter your password',
                        icon: Icons.lock_outline_rounded,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            color: Colors.grey.shade600,
                          ),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _handleSignup,
                        style: FilledButton.styleFrom(
                          backgroundColor: kPrimaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                            : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Already have an account? ', style: TextStyle(color: Colors.grey.shade600)),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: kPrimaryGreen),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: kPrimaryGreen),
      ),
    );
  }
}