import 'package:flutter/material.dart';
import '../main.dart';
import '../models/service.dart';

class BookingPage extends StatefulWidget {
  final Service service;
  final bool isEmergency;

  const BookingPage({
    super.key,
    required this.service,
    this.isEmergency = false,
  });

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEmergency) {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Color get _accentColor => widget.isEmergency ? const Color(0xFFD9534F) : kPrimaryGreen;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: _accentColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(primary: _accentColor),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select date and time')),
      );
      return;
    }
    if (_addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your address')),
      );
      return;
    }

    setState(() => _isBooking = true);

    // TODO: Replace with actual FastAPI booking request
    // (emergency bookings would likely hit a different/priority endpoint)
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isBooking = false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _accentColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.isEmergency ? Icons.bolt_rounded : Icons.check_rounded,
                  color: _accentColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.isEmergency ? 'Help is on the way!' : 'Booking Confirmed!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: kDarkText),
              ),
              const SizedBox(height: 8),
              Text(
                widget.isEmergency
                    ? 'We\'ve dispatched your request. A provider will contact you shortly and arrive at your address.'
                    : '${widget.service.name} is booked for ${_formatDate(_selectedDate!)} at ${_selectedTime!.format(context)}.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // close dialog
                    Navigator.pop(context); // close booking page
                  },
                  child: const Text('Done'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = widget.service;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEmergency ? 'Emergency Service' : 'Book Service'),
        backgroundColor: Colors.white,
        foregroundColor: kDarkText,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.isEmergency)
                Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bolt_rounded, color: _accentColor, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Priority dispatch — a nearby provider will be assigned immediately.',
                          style: TextStyle(fontSize: 12, color: _accentColor, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),

              // Service summary card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(service.icon, color: _accentColor, size: 26),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          const SizedBox(height: 2),
                          Text(service.providerName,
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                          if (!widget.isEmergency) ...[
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 15, color: Colors.amber),
                                const SizedBox(width: 2),
                                Text('${service.rating} (${service.reviews})',
                                    style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    Text(
                      'Rs. ${service.priceNpr}',
                      style: TextStyle(fontWeight: FontWeight.w700, color: _accentColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(service.description,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
              const SizedBox(height: 28),

              Text('Select Date',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kDarkText)),
              const SizedBox(height: 10),
              _PickerTile(
                icon: Icons.calendar_today_outlined,
                label: _selectedDate == null ? 'Choose a date' : _formatDate(_selectedDate!),
                accentColor: _accentColor,
                onTap: _pickDate,
              ),
              const SizedBox(height: 20),

              Text('Select Time',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kDarkText)),
              const SizedBox(height: 10),
              _PickerTile(
                icon: Icons.access_time_rounded,
                label: _selectedTime == null ? 'Choose a time' : _selectedTime!.format(context),
                accentColor: _accentColor,
                onTap: _pickTime,
              ),
              const SizedBox(height: 20),

              Text('Service Address',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kDarkText)),
              const SizedBox(height: 10),
              TextField(
                controller: _addressController,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: 'Enter your full address',
                  prefixIcon: Icon(Icons.location_on_outlined, color: _accentColor),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Text('Additional Notes ${widget.isEmergency ? '(describe the issue)' : '(optional)'}',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: kDarkText)),
              const SizedBox(height: 10),
              TextField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: widget.isEmergency
                      ? 'e.g. Water leaking from kitchen pipe...'
                      : 'Any specific instructions for the provider...',
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: _accentColor),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isBooking ? null : _confirmBooking,
                  style: FilledButton.styleFrom(
                    backgroundColor: _accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _isBooking
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : Text(
                    widget.isEmergency
                        ? 'Request Emergency Help · Rs. ${service.priceNpr}'
                        : 'Confirm Booking · Rs. ${service.priceNpr}',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color accentColor;
  final VoidCallback onTap;

  const _PickerTile({
    required this.icon,
    required this.label,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor, size: 20),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 14)),
            const Spacer(),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}