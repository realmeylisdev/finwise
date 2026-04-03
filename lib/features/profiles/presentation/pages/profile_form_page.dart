import 'package:finwise/core/theme/app_dimensions.dart';
import 'package:finwise/features/profiles/domain/entities/profile_entity.dart';
import 'package:finwise/features/profiles/presentation/bloc/profiles_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({this.profile, super.key});

  final ProfileEntity? profile;

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  int _selectedColor = 0xFF6366F1;

  bool get _isEditing => widget.profile != null;

  static const _colorOptions = [
    0xFF6366F1, // Indigo
    0xFF22C55E, // Green
    0xFFEF4444, // Red
    0xFF3B82F6, // Blue
    0xFFF59E0B, // Amber
    0xFF8B5CF6, // Violet
    0xFFEC4899, // Pink
    0xFF14B8A6, // Teal
    0xFFF97316, // Orange
    0xFF06B6D4, // Cyan
    0xFF84CC16, // Lime
    0xFF64748B, // Slate
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final p = widget.profile!;
      _nameController.text = p.name;
      _emailController.text = p.email ?? '';
      _selectedColor = p.avatarColor;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final profile = ProfileEntity(
      id: widget.profile?.id ?? const Uuid().v4(),
      name: _nameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      avatarColor: _selectedColor,
      isOwner: widget.profile?.isOwner ?? false,
      createdAt: widget.profile?.createdAt ?? DateTime.now(),
    );

    final bloc = context.read<ProfilesBloc>();
    if (_isEditing) {
      bloc.add(ProfileUpdated(profile));
    } else {
      bloc.add(ProfileCreated(profile));
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Member' : 'New Member'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(AppDimensions.paddingM),
          children: [
            // Avatar preview
            Center(
              child: CircleAvatar(
                radius: 40.r,
                backgroundColor:
                    Color(_selectedColor).withValues(alpha: 0.15),
                child: Text(
                  _previewInitials,
                  style: TextStyle(
                    color: Color(_selectedColor),
                    fontWeight: FontWeight.w700,
                    fontSize: 28.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                hintText: 'e.g. John, Mom, Partner',
              ),
              textCapitalization: TextCapitalization.words,
              onChanged: (_) => setState(() {}),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter a name' : null,
            ),
            SizedBox(height: AppDimensions.paddingM),

            // Email (optional)
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (optional)',
                hintText: 'e.g. john@example.com',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: AppDimensions.paddingL),

            // Color picker
            Text(
              'Avatar Color',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: AppDimensions.paddingS),
            Wrap(
              spacing: 10.w,
              runSpacing: 10.w,
              children: _colorOptions.map((color) {
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40.w,
                    height: 40.w,
                    decoration: BoxDecoration(
                      color: Color(color),
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.onSurface,
                              width: 3.w,
                            )
                          : null,
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Color(color).withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: isSelected
                        ? Icon(Icons.check, color: Colors.white, size: 20.w)
                        : null,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.paddingXL),

            // Submit
            ElevatedButton(
              onPressed: _submit,
              child: Text(_isEditing ? 'Save Changes' : 'Add Member'),
            ),
          ],
        ),
      ),
    );
  }

  String get _previewInitials {
    final text = _nameController.text.trim();
    if (text.isEmpty) return '?';
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return text[0].toUpperCase();
  }
}
