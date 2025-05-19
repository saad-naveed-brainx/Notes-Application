import 'package:flutter/material.dart';
import 'package:notes/core/constants/app_constants.dart';
import 'package:notes/models/notes_model.dart';
import 'package:intl/intl.dart';
import 'package:notes/core/constants/view_constants.dart';
import 'package:notes/config/theme/dark.dart';

class NoteView extends StatelessWidget {
  final NotesModel note;
  const NoteView({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(
        int.parse('0xFF${note.backgroundColorHex.replaceAll('#', '')}'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.gap16Px,
            vertical: AppConstants.gap18Px,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title,
                style: TextStyle(
                  fontSize: AppConstants.font24Px * 2,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppConstants.gap24Px),
              Text(
                DateFormat('MMMM dd, yyyy').format(note.createOrUpdatedAt),
                style: TextStyle(
                  fontSize: AppConstants.font18Px,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppConstants.gap24Px),
              Text(
                note.description,
                style: TextStyle(
                  fontSize: AppConstants.font18Px,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
