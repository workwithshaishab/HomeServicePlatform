import 'package:flutter/material.dart';
import '../main.dart';
import '../models/service.dart';
import 'booking.dart';
import 'emergency_map.dart';
import 'role_selection.dart';

class _Category {
  final String name;
  final IconData icon;
  const _Category(this.name, this.icon);
}

class _Professional {
  final String name;
  final String role;
  final double rating;
  final int reviews;
  const _Professional(this.name, this.role, this.rating, this.reviews);
}

class CustomerHomePage extends StatefulWidget {
  const CustomerHomePage({super.key});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  int _navIndex = 0;
  static const int _profileTabIndex = 4;

  final _searchController = TextEditingController();
  List<Service> _searchResults = [];
  bool get _isSearching => _searchController.text.trim().isNotEmpty;

  final _categories = const [
    _Category('Cleaning', Icons.cleaning_services_outlined),
    _Category('Plumbing', Icons.plumbing_outlined),
    _Category('Electrical', Icons.lightbulb_outline_rounded),
    _Category('Carpentry', Icons.handyman_outlined),
    _Category('Painting', Icons.format_paint_outlined),
    _Category('Appliance Repair', Icons.local_laundry_service_outlined),
    _Category('Pest Control', Icons.pest_control_outlined),
    _Category('More', Icons.more_horiz_rounded),
  ];

  final _steps = const [
    ('1', Icons.description_outlined, 'Choose Service', 'Select the service you need'),
    ('2', Icons.calendar_today_outlined, 'Pick Date & Time', 'Choose a convenient time slot'),
    ('3', Icons.person_outline_rounded, 'We Assign Expert', "We'll connect you with a verified pro"),
    ('4', Icons.verified_outlined, 'Service Done', "Sit back and relax! We've got it done."),
  ];

  final _professionals = const [
    _Professional('Ram Bahadur', 'Plumber', 4.8, 120),
    _Professional('Sita Tamang', 'Cleaner', 4.7, 98),
    _Professional('Arjun Karki', 'Electrician', 4.9, 150),
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = sampleServices.where((s) {
          return s.name.toLowerCase().contains(query) ||
              s.category.toLowerCase().contains(query) ||
              s.providerName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  void _openBooking(Service service) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BookingPage(service: service)),
    );
  }

  void _openEmergencyBooking() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const EmergencyMapPage()),
    );
  }

  void _openCategoryResults(String categoryName) {
    if (categoryName == 'More') return;
    final results = sampleServices.where((s) => s.category == categoryName).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CategoryResultsPage(categoryName: categoryName, services: results),
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == _profileTabIndex) {
      _showProfileMenu(context);
      return; // keep current tab selected/highlighted; sheet is transient
    }
    setState(() => _navIndex = index);
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(color: kLightGreenBg, shape: BoxShape.circle),
                      child: const Icon(Icons.person_rounded, color: kPrimaryGreen, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Guest User', // TODO: replace with actual user name
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text('guest@example.com', // TODO: replace with actual email
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 32),
                _ProfileMenuTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Edit Profile',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to edit profile page
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.calendar_today_outlined,
                  label: 'My Bookings',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to bookings page
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.location_on_outlined,
                  label: 'Saved Addresses',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to addresses page
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.payment_outlined,
                  label: 'Payment Methods',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to payment methods page
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notifications',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to notifications settings
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.help_outline_rounded,
                  label: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to help page
                  },
                ),
                _ProfileMenuTile(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: navigate to settings page
                  },
                ),
                const Divider(height: 24),
                _ProfileMenuTile(
                  icon: Icons.logout_rounded,
                  label: 'Log Out',
                  isDestructive: true,
                  onTap: () {
                    Navigator.pop(context);
                    // TODO: clear auth session before navigating back
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const RoleSelectionPage()),
                          (route) => false,
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, color: kPrimaryGreen, size: 18),
                        const SizedBox(width: 4),
                        Text('Kathmandu, Nepal',
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.home_repair_service_rounded, color: kAccentGreen, size: 22),
                        const SizedBox(width: 4),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                            children: [
                              TextSpan(text: 'Ghar', style: TextStyle(color: kDarkText)),
                              TextSpan(text: 'Seva', style: TextStyle(color: kAccentGreen)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(Icons.notifications_none_rounded, size: 24),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(color: kAccentGreen, shape: BoxShape.circle),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Greeting (hidden while searching to keep focus on results)
            if (!_isSearching)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Hello, 👋', style: TextStyle(fontSize: 15)),
                            const SizedBox(height: 4),
                            Text(
                              'What service do you need today?',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: kDarkText,
                                height: 1.25,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => _showProfileMenu(context),
                        borderRadius: BorderRadius.circular(36),
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: const BoxDecoration(color: kLightGreenBg, shape: BoxShape.circle),
                          child: const Icon(Icons.person_rounded, color: kPrimaryGreen, size: 36),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Search bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for services...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _isSearching
                        ? IconButton(
                      icon: const Icon(Icons.close_rounded),
                      onPressed: () => _searchController.clear(),
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),

            // ── Search results (shown only while typing) ──
            if (_isSearching) ...[
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    '${_searchResults.length} result${_searchResults.length == 1 ? '' : 's'} found',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ),
              if (_searchResults.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Column(
                      children: [
                        Icon(Icons.search_off_rounded, size: 40, color: Colors.grey.shade400),
                        const SizedBox(height: 8),
                        Text('No services match your search',
                            style: TextStyle(color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _ServiceCard(
                          service: _searchResults[index],
                          onTap: () => _openBooking(_searchResults[index]),
                        ),
                      ),
                      childCount: _searchResults.length,
                    ),
                  ),
                ),
            ]

            // ── Normal home content (hidden while searching) ──
            else ...[
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Popular Services',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kDarkText)),
                      const Text('View All', style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.78,
                  ),
                  delegate: SliverChildBuilderDelegate(
                        (context, index) => _CategoryTile(
                      category: _categories[index],
                      onTap: () => _openCategoryResults(_categories[index].name),
                    ),
                    childCount: _categories.length,
                  ),
                ),
              ),

              // Emergency banner
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kLightGreenBg,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Need it urgently?',
                                  style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('Try our Emergency Services',
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kDarkText)),
                              const SizedBox(height: 4),
                              Text('Quick help, right when you need it.',
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                              const SizedBox(height: 14),
                              FilledButton(
                                onPressed: _openEmergencyBooking,
                                style: FilledButton.styleFrom(
                                  backgroundColor: kPrimaryGreen,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Book Now'),
                                    SizedBox(width: 6),
                                    Icon(Icons.arrow_forward_rounded, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.bolt_rounded, color: kAccentGreen, size: 56),
                      ],
                    ),
                  ),
                ),
              ),

              // How it works
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 8),
                sliver: SliverToBoxAdapter(
                  child: Text('How It Works',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kDarkText)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: _steps
                        .map((s) => Expanded(
                      child: Column(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: const BoxDecoration(color: kLightGreenBg, shape: BoxShape.circle),
                            child: Icon(s.$2, color: kPrimaryGreen, size: 22),
                          ),
                          const SizedBox(height: 8),
                          Text(s.$3,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ))
                        .toList(),
                  ),
                ),
              ),

              // Top rated professionals
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Top Rated Professionals',
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: kDarkText)),
                      const Text('View All', style: TextStyle(color: kPrimaryGreen, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 130,
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                    scrollDirection: Axis.horizontal,
                    itemCount: _professionals.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final p = _professionals[index];
                      return Container(
                        width: 150,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundColor: kLightGreenBg,
                              child: Icon(Icons.person_rounded, color: kPrimaryGreen),
                            ),
                            const SizedBox(height: 8),
                            Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                            Text(p.role, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                                const SizedBox(width: 2),
                                Text('${p.rating} (${p.reviews})', style: const TextStyle(fontSize: 11)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _navIndex,
        onDestinationSelected: _onNavTap,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home_rounded), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), selectedIcon: Icon(Icons.calendar_today_rounded), label: 'Bookings'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), selectedIcon: Icon(Icons.chat_bubble_rounded), label: 'Messages'),
          NavigationDestination(icon: Icon(Icons.local_offer_outlined), selectedIcon: Icon(Icons.local_offer_rounded), label: 'Offers'),
          NavigationDestination(icon: Icon(Icons.person_outline_rounded), selectedIcon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;

  const _ProfileMenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? Colors.red.shade600 : kDarkText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 22, color: color),
            const SizedBox(width: 16),
            Text(label, style: TextStyle(fontSize: 15, color: color)),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final _Category category;
  final VoidCallback onTap;
  const _CategoryTile({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(category.icon, color: kPrimaryGreen, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            category.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onTap;

  const _ServiceCard({required this.service, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(color: kLightGreenBg, borderRadius: BorderRadius.circular(14)),
              child: Icon(service.icon, color: kPrimaryGreen, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(service.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text(service.providerName, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text('${service.rating} (${service.reviews})', style: const TextStyle(fontSize: 11)),
                      const SizedBox(width: 10),
                      Text('Rs. ${service.priceNpr}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: kPrimaryGreen)),
                    ],
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class _CategoryResultsPage extends StatelessWidget {
  final String categoryName;
  final List<Service> services;

  const _CategoryResultsPage({required this.categoryName, required this.services});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: Colors.white,
        foregroundColor: kDarkText,
        elevation: 0,
      ),
      body: services.isEmpty
          ? Center(
        child: Text('No services available in $categoryName yet',
            style: TextStyle(color: Colors.grey.shade600)),
      )
          : ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final service = services[index];
          return _ServiceCard(
            service: service,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BookingPage(service: service)),
              );
            },
          );
        },
      ),
    );
  }
}