import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/core/constants/app_constants.dart';
import 'package:notes/models/notes_model.dart';

class NoteCard extends StatelessWidget {
  final NotesModel note;

  const NoteCard({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final bgColor = Color(
      int.parse('0xFF${note.backgroundColorHex.replaceAll('#', '')}'),
    );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // makes height fit content
        children: [
          Text(
            note.title,
            style: const TextStyle(
              fontSize: AppConstants.font24Px,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                DateFormat('MMM d yyyy').format(note.createOrUpdatedAt),
                style: const TextStyle(
                  fontSize: AppConstants.font12Px,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
