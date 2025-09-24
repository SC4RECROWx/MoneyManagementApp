// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AvatarsPicker extends StatelessWidget {
  final List<String> avatars; // List path gambar avatar
  final String? selectedAvatar; // Path avatar terpilih
  final ValueChanged<String> onAvatarSelected;
  final String label;
  final String? errorText;

  const AvatarsPicker({
    super.key,
    required this.avatars,
    required this.selectedAvatar,
    required this.onAvatarSelected,
    this.label = 'Pilih Avatar',
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: avatars.isEmpty
              ? const Text('No avatars available')
              : Wrap(
                  spacing: 12.0,
                  runSpacing: 8.0,
                  children: avatars.map((avatarPath) {
                    final isSelected = avatarPath == selectedAvatar;
                    return GestureDetector(
                      onTap: () => onAvatarSelected(avatarPath),
                      child: CircleAvatar(
                        radius: isSelected ? 32 : 28,
                        backgroundColor: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.3)
                            : Colors.transparent,
                        // Tambahkan border jika terpilih
                        foregroundColor: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                        child: CircleAvatar(
                          radius: 26,
                          backgroundImage: AssetImage(avatarPath),
                          // Jika ingin support network, bisa pakai NetworkImage
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
