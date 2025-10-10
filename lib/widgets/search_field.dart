import 'package:flutter/material.dart';
import 'package:vpncn2_app/l10n/generated/app_localizations.dart';

class SearchField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return TextField(
      decoration: InputDecoration(
        hintText: t.searchYourKey,
        prefixIcon: const Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
      onChanged: onChanged,
    );
  }
}



