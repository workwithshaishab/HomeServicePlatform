import 'dart:math';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/service.dart';
import 'booking.dart';

const _emergencyRed = Color(0xFFD9534F);

class EmergencyMapPage extends StatefulWidget {
  const EmergencyMapPage({super.key});

  @override
  State<EmergencyMapPage> createState() => _EmergencyMapPageState();
}

class _EmergencyMapPageState extends State<EmergencyMapPage>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _searchController;

  bool _isSearching = true;
  NearbyProvider? _selectedProvider;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _searchController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Simulate a short "searching nearby" delay, like a ride-share app.
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (!mounted) return;
      setState(() => _isSearching = false);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _selectProvider(NearbyProvider provider) {
    setState(() => _selectedProvider = provider);
  }

  void _confirmDispatch() {
    if (_selectedProvider == null) return;

    final assignedService = Service(
      id: emergencyService.id,
      name: emergencyService.name,
      category: emergencyService.category,
      icon: emergencyService.icon,
      providerName: _selectedProvider!.name,
      rating: _selectedProvider!.rating,
      reviews: emergencyService.reviews,
      priceNpr: emergencyService.priceNpr,
      description: emergencyService.description,
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingPage(service: assignedService, isEmergency: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final radarSize = screenWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F4),
      appBar: AppBar(
        title: const Text('Nearby Providers'),
        backgroundColor: Colors.white,
        foregroundColor: kDarkText,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Radar / map area
          SizedBox(
            width: double.infinity,
            height: radarSize * 0.62,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Concentric radar rings
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(radarSize, radarSize * 0.62),
                      painter: _RadarPainter(pulseValue: _pulseController.value),
                    );
                  },
                ),

                // Provider markers (only once search completes)
                if (!_isSearching)
                  ...sampleNearbyProviders.map((p) {
                    final maxRadius = (radarSize * 0.62) / 2 * 0.85;
                    final dx = cos(p.angle) * maxRadius * p.radiusFraction;
                    final dy = sin(p.angle) * maxRadius * p.radiusFraction * 0.7;
                    final isSelected = _selectedProvider?.id == p.id;

                    return AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      left: radarSize / 2 + dx - 20,
                      top: (radarSize * 0.62) / 2 + dy - 20,
                      child: GestureDetector(
                        onTap: () => _selectProvider(p),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: isSelected ? 46 : 40,
                          height: isSelected ? 46 : 40,
                          decoration: BoxDecoration(
                            color: isSelected ? _emergencyRed : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.white : _emergencyRed,
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            p.icon,
                            color: isSelected ? Colors.white : _emergencyRed,
                            size: isSelected ? 22 : 18,
                          ),
                        ),
                      ),
                    );
                  }),

                // Center: user's location pin
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: kPrimaryGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(Icons.home_rounded, color: Colors.white, size: 22),
                ),

                // Searching overlay
                if (_isSearching)
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: _emergencyRed,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text('Searching nearby providers...',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Provider list / bottom panel
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
                ],
              ),
              child: _isSearching
                  ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Locating verified providers near you...'),
                ),
              )
                  : Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                    child: Row(
                      children: [
                        Text(
                          '${sampleNearbyProviders.length} providers nearby',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
                      itemCount: sampleNearbyProviders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final p = sampleNearbyProviders[index];
                        final isSelected = _selectedProvider?.id == p.id;
                        return InkWell(
                          onTap: () => _selectProvider(p),
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isSelected ? _emergencyRed.withOpacity(0.06) : Colors.white,
                              border: Border.all(
                                color: isSelected ? _emergencyRed : Colors.grey.shade200,
                                width: isSelected ? 1.5 : 1,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: _emergencyRed.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(p.icon, color: _emergencyRed, size: 22),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(p.name,
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                                      Text(p.serviceType,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                      const SizedBox(height: 3),
                                      Row(
                                        children: [
                                          const Icon(Icons.star_rounded, size: 13, color: Colors.amber),
                                          const SizedBox(width: 2),
                                          Text('${p.rating}', style: const TextStyle(fontSize: 11)),
                                          const SizedBox(width: 8),
                                          Icon(Icons.social_distance_rounded, size: 13, color: Colors.grey.shade500),
                                          const SizedBox(width: 2),
                                          Text('${p.distanceKm} km', style: const TextStyle(fontSize: 11)),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text('${p.etaMinutes} min',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700, fontSize: 14, color: _emergencyRed)),
                                    const Text('ETA', style: TextStyle(fontSize: 10)),
                                  ],
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  const Icon(Icons.check_circle_rounded, color: _emergencyRed, size: 20),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _selectedProvider == null ? null : _confirmDispatch,
                        style: FilledButton.styleFrom(
                          backgroundColor: _emergencyRed,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        child: Text(
                          _selectedProvider == null
                              ? 'Select a provider'
                              : 'Request ${_selectedProvider!.name} · ${_selectedProvider!.etaMinutes} min ETA',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Draws concentric pulsing circles + a faint grid to simulate a radar/map.
class _RadarPainter extends CustomPainter {
  final double pulseValue;

  _RadarPainter({required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2 * 0.9;

    // Background
    final bgPaint = Paint()..color = const Color(0xFFEFF5F1);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Static concentric rings
    final ringPaint = Paint()
      ..color = kPrimaryGreen.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    for (var i = 1; i <= 3; i++) {
      canvas.drawCircle(center, maxRadius * (i / 3), ringPaint);
    }

    // Pulsing animated ring
    final pulseRadius = maxRadius * pulseValue;
    final pulsePaint = Paint()
      ..color = kPrimaryGreen.withOpacity((1 - pulseValue) * 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, pulseRadius, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _RadarPainter oldDelegate) => true;
}