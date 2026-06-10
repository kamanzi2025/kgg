import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../constants/app_colors.dart';
import '../../models/post_model.dart';
import '../../providers/app_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/input_field.dart';

class PostCreateScreen extends StatefulWidget {
  const PostCreateScreen({super.key});

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _maxParticipantsCtrl = TextEditingController(text: '100');

  String _type = 'event';
  String _category = 'Events';
  String _campus = 'Kigali';
  DateTime _date = DateTime.now().add(const Duration(days: 7));
  DateTime _deadline = DateTime.now().add(const Duration(days: 3));
  bool _loading = false;

  static const _categories = ['Events', 'Opportunities', 'Academic', 'Clubs'];
  static const _campuses = ['Kigali', 'Mauritius', 'Remote'];

  // Placeholder cover images by category
  static const _coverImages = {
    'Events': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=800',
    'Opportunities': 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?w=800',
    'Academic': 'https://images.unsplash.com/photo-1532012197267-da84d127e765?w=800',
    'Clubs': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
  };

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _locationCtrl.dispose();
    _maxParticipantsCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate({required bool isDeadline}) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isDeadline ? _deadline : _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.accentGold,
            surface: AppColors.cardBackground,
          ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      if (isDeadline) {
        _deadline = picked;
      } else {
        _date = picked;
      }
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final provider = context.read<AppProvider>();
    final user = provider.currentUser!;
    final post = PostModel(
      id: const Uuid().v4(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      organizerName: user.name,
      organizerId: user.id,
      organizerAvatar: user.avatarUrl,
      category: _category,
      type: _type,
      campus: _campus,
      location: _locationCtrl.text.trim(),
      date: _date,
      deadline: _deadline,
      coverImageUrl: _coverImages[_category] ?? _coverImages['Events']!,
      maxParticipants: int.tryParse(_maxParticipantsCtrl.text) ?? 100,
      isFeatured: false,
    );

    await Future.delayed(const Duration(milliseconds: 600));
    provider.addPost(post);

    setState(() => _loading = false);
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Post published successfully!'),
        backgroundColor: AppColors.successGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Type toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    _TypeToggle(
                      label: 'Event',
                      icon: Icons.event_rounded,
                      isSelected: _type == 'event',
                      onTap: () => setState(() => _type = 'event'),
                    ),
                    _TypeToggle(
                      label: 'Opportunity',
                      icon: Icons.work_outline_rounded,
                      isSelected: _type == 'opportunity',
                      onTap: () => setState(() => _type = 'opportunity'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              InputField(
                controller: _titleCtrl,
                label: 'Title',
                icon: Icons.title_rounded,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Title is required' : null,
              ),
              const SizedBox(height: 14),
              InputField(
                controller: _descCtrl,
                label: 'Description',
                icon: Icons.description_outlined,
                maxLines: 4,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Description is required' : null,
              ),
              const SizedBox(height: 14),
              InputField(
                controller: _locationCtrl,
                label: 'Location',
                icon: Icons.location_on_outlined,
                validator: (v) =>
                    (v == null || v.isEmpty) ? 'Location is required' : null,
              ),
              const SizedBox(height: 14),

              // Category + campus row
              Row(
                children: [
                  Expanded(
                    child: _DropdownField(
                      label: 'Category',
                      value: _category,
                      items: _categories,
                      icon: Icons.category_outlined,
                      onChanged: (v) => setState(() => _category = v!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DropdownField(
                      label: 'Campus',
                      value: _campus,
                      items: _campuses,
                      icon: Icons.location_city_outlined,
                      onChanged: (v) => setState(() => _campus = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Date pickers row
              Row(
                children: [
                  Expanded(
                    child: _DatePickerField(
                      label: 'Event Date',
                      date: _date,
                      onTap: () => _pickDate(isDeadline: false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DatePickerField(
                      label: 'Deadline',
                      date: _deadline,
                      onTap: () => _pickDate(isDeadline: true),
                      isDeadline: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              InputField(
                controller: _maxParticipantsCtrl,
                label: 'Max Participants',
                icon: Icons.people_outline_rounded,
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (int.tryParse(v) == null) return 'Must be a number';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              CustomButton(
                label: 'Publish Post',
                width: double.infinity,
                isLoading: _loading,
                icon: Icons.rocket_launch_rounded,
                onTap: _submit,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeToggle({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.accentGold : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.black : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
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
      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
      isDense: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        prefixIcon: Icon(icon, color: AppColors.textSecondary, size: 18),
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
      items: items.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final String label;
  final DateTime date;
  final VoidCallback onTap;
  final bool isDeadline;

  const _DatePickerField({
    required this.label,
    required this.date,
    required this.onTap,
    this.isDeadline = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(
              isDeadline ? Icons.timer_outlined : Icons.calendar_today_outlined,
              color: AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 11)),
                  Text(
                    '${date.day}/${date.month}/${date.year}',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
