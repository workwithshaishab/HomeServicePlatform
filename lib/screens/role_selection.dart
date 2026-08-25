import 'package:flutter/material.dart';
import '../main.dart';
import 'login.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Icon(Icons.home_repair_service_rounded,
                  color: kAccentGreen, size: 56),
              const SizedBox(height: 8),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                  children: [
                    TextSpan(text: 'Ghar', style: TextStyle(color: kDarkText)),
                    TextSpan(text: 'Seva', style: TextStyle(color: kAccentGreen)),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Home Services, Simplified.',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 48),
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: kDarkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Choose your login type to continue',
                style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 40),
              _RoleCard(
                icon: Icons.people_alt_rounded,
                title: 'Customer Login',
                subtitle: 'Book trusted home services quickly and easily.',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(role: UserRole.customer),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _RoleCard(
                icon: Icons.engineering_rounded,
                title: 'Service Provider Login',
                subtitle:
                'Manage bookings, grow your business and serve more customers.',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(role: UserRole.provider),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  GestureDetector(
                    onTap: () {
                      // TODO: navigate to sign up page
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: kPrimaryGreen,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: kLightGreenBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: kPrimaryGreen, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: kDarkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: kLightGreenBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.chevron_right_rounded,
                  color: kPrimaryGreen,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}