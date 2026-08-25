import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final String providerName;
  final double rating;
  final int reviews;
  final int priceNpr;
  final String description;

  const Service({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.providerName,
    required this.rating,
    required this.reviews,
    required this.priceNpr,
    required this.description,
  });
}

// Sample data — replace with FastAPI response later.
const List<Service> sampleServices = [
  Service(
    id: 's1',
    name: 'Deep Home Cleaning',
    category: 'Cleaning',
    icon: Icons.cleaning_services_outlined,
    providerName: 'Sita Tamang',
    rating: 4.7,
    reviews: 98,
    priceNpr: 1200,
    description:
    'Thorough cleaning of your entire home including kitchen, bathrooms, and living areas. Includes dusting, mopping, and sanitizing.',
  ),
  Service(
    id: 's2',
    name: 'Sofa & Carpet Cleaning',
    category: 'Cleaning',
    icon: Icons.cleaning_services_outlined,
    providerName: 'Sita Tamang',
    rating: 4.6,
    reviews: 64,
    priceNpr: 1500,
    description:
    'Deep shampoo cleaning for sofas, carpets, and rugs to remove stains, dust, and odors.',
  ),
  Service(
    id: 's3',
    name: 'Pipe Leak Repair',
    category: 'Plumbing',
    icon: Icons.plumbing_outlined,
    providerName: 'Ram Bahadur',
    rating: 4.8,
    reviews: 120,
    priceNpr: 800,
    description:
    'Fix leaking pipes, joints, and fittings. Includes inspection and minor part replacement.',
  ),
  Service(
    id: 's4',
    name: 'Bathroom Fitting Installation',
    category: 'Plumbing',
    icon: Icons.plumbing_outlined,
    providerName: 'Ram Bahadur',
    rating: 4.7,
    reviews: 75,
    priceNpr: 2000,
    description:
    'Installation of taps, showers, sinks, and other bathroom fittings.',
  ),
  Service(
    id: 's5',
    name: 'Switchboard Fix',
    category: 'Electrical',
    icon: Icons.lightbulb_outline_rounded,
    providerName: 'Arjun Karki',
    rating: 4.9,
    reviews: 150,
    priceNpr: 600,
    description:
    'Diagnose and repair faulty switchboards, sockets, and wiring issues safely.',
  ),
  Service(
    id: 's6',
    name: 'Ceiling Fan Installation',
    category: 'Electrical',
    icon: Icons.lightbulb_outline_rounded,
    providerName: 'Arjun Karki',
    rating: 4.8,
    reviews: 60,
    priceNpr: 900,
    description: 'Safe mounting and wiring of ceiling fans with balance testing.',
  ),
  Service(
    id: 's7',
    name: 'Furniture Assembly',
    category: 'Carpentry',
    icon: Icons.handyman_outlined,
    providerName: 'Kishor Lama',
    rating: 4.6,
    reviews: 45,
    priceNpr: 700,
    description: 'Assembly of flat-pack furniture, shelves, and cabinets.',
  ),
  Service(
    id: 's8',
    name: 'Wall Painting',
    category: 'Painting',
    icon: Icons.format_paint_outlined,
    providerName: 'Newari Paint House',
    rating: 4.7,
    reviews: 80,
    priceNpr: 3500,
    description:
    'Full interior wall painting including surface prep, primer, and two coats of paint.',
  ),
  Service(
    id: 's9',
    name: 'Washing Machine Repair',
    category: 'Appliance Repair',
    icon: Icons.local_laundry_service_outlined,
    providerName: 'Prakash Rai',
    rating: 4.5,
    reviews: 52,
    priceNpr: 1000,
    description: 'Diagnosis and repair of washing machine mechanical or electrical faults.',
  ),
  Service(
    id: 's10',
    name: 'Cockroach & Pest Treatment',
    category: 'Pest Control',
    icon: Icons.pest_control_outlined,
    providerName: 'CleanHome Pest Co.',
    rating: 4.6,
    reviews: 70,
    priceNpr: 1500,
    description: 'Safe chemical treatment to eliminate cockroaches and common household pests.',
  ),
];

// Special entry used for the "Emergency Services" quick-book flow.
const Service emergencyService = Service(
  id: 'emergency',
  name: 'Emergency Service Call',
  category: 'Emergency',
  icon: Icons.bolt_rounded,
  providerName: 'Next Available Provider',
  rating: 4.7,
  reviews: 320,
  priceNpr: 1500,
  description:
  'Urgent dispatch for critical issues — plumbing leaks, electrical faults, lockouts, and more. '
      'A verified nearby professional is assigned immediately and typically arrives within 60–90 minutes.',
);

// Represents a provider shown on the emergency "nearby providers" radar.
class NearbyProvider {
  final String id;
  final String name;
  final String serviceType;
  final IconData icon;
  final double rating;
  final double distanceKm;
  final int etaMinutes;
  final double angle; // position on radar, in radians (0 = right, clockwise)
  final double radiusFraction; // 0.0 (center) to 1.0 (edge of radar)

  const NearbyProvider({
    required this.id,
    required this.name,
    required this.serviceType,
    required this.icon,
    required this.rating,
    required this.distanceKm,
    required this.etaMinutes,
    required this.angle,
    required this.radiusFraction,
  });
}

// Sample nearby providers — replace with live location data from FastAPI later.
final List<NearbyProvider> sampleNearbyProviders = [
  NearbyProvider(
    id: 'p1',
    name: 'Ram Bahadur',
    serviceType: 'Plumber',
    icon: Icons.plumbing_outlined,
    rating: 4.8,
    distanceKm: 0.8,
    etaMinutes: 6,
    angle: 0.6,
    radiusFraction: 0.35,
  ),
  NearbyProvider(
    id: 'p2',
    name: 'Arjun Karki',
    serviceType: 'Electrician',
    icon: Icons.electrical_services_outlined,
    rating: 4.9,
    distanceKm: 1.3,
    etaMinutes: 9,
    angle: 2.3,
    radiusFraction: 0.55,
  ),
  NearbyProvider(
    id: 'p3',
    name: 'Kishor Lama',
    serviceType: 'Handyman',
    icon: Icons.handyman_outlined,
    rating: 4.6,
    distanceKm: 1.9,
    etaMinutes: 13,
    angle: 4.1,
    radiusFraction: 0.75,
  ),
  NearbyProvider(
    id: 'p4',
    name: 'Prakash Rai',
    serviceType: 'Appliance Repair',
    icon: Icons.build_circle_outlined,
    rating: 4.5,
    distanceKm: 2.4,
    etaMinutes: 17,
    angle: 5.4,
    radiusFraction: 0.9,
  ),
];