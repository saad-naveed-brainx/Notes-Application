import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes/core/constants/app_constants.dart';
import 'package:notes/core/constants/view_constants.dart';
import 'package:notes/models/notes_model.dart';
import 'package:notes/viewmodels/change_notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes/config/app_router.dart';

class NoteView extends StatefulWidget {
  final NotesModel? note;
  const NoteView({super.key, this.note});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  bool isEditing = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late NotesProvider notesProvider;
  late bool isNewNote;

  @override
  void initState() {
    super.initState();
    notesProvider = Provider.of<NotesProvider>(context, listen: false);
    isNewNote = widget.note == null;
    titleController.text = widget.note?.title ?? '';
    descriptionController.text = widget.note?.description ?? '';
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void saveNote() {
    notesProvider.validateAndSave(
      titleController,
      descriptionController,
      context,
      isNewNote,
      widget.note,
      toggleEdit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNewNote = widget.note == null;
    final bgColor =
        isNewNote
            ? Colors.white
            : Color(
              int.parse(
                '0xFF${widget.note!.backgroundColorHex.replaceAll('#', '')}',
              ),
            );

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        actions: [
          if (widget.note != null && !isEditing)
            IconButton(onPressed: toggleEdit, icon: const Icon(Icons.edit)),
          if (widget.note != null && isEditing)
            IconButton(
              onPressed: saveNote,
              icon: const Icon(Icons.check),
            ),
          if (widget.note == null)
            IconButton(
              onPressed: saveNote,
              icon: const Icon(Icons.save),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.gap16Px,
              vertical: AppConstants.gap18Px,
            ),
            child: Consumer<NotesProvider>(
              builder: (context, notesProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isEditing && !isNewNote)
                      TextField(
                        controller: titleController,
                        style: TextStyle(
                          fontSize: AppConstants.font24Px * 2,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ViewConstants.title,
                        ),
                      ),
                    if (!isEditing && !isNewNote)
                      Text(
                        notesProvider.notes
                                .where((note) => note.id == widget.note?.id)
                                .firstOrNull
                                ?.title ??
                            '',
                        style: TextStyle(
                          fontSize: AppConstants.font24Px * 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    if (isNewNote)
                      TextField(
                        controller: titleController,
                        style: TextStyle(
                          fontSize: AppConstants.font24Px * 2,
                          fontWeight: FontWeight.w900,
                        ),
                        maxLines: null,
                        minLines: 1,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ViewConstants.title,
                        ),
                      ),
                    const SizedBox(height: AppConstants.gap24Px),
                    Text(
                      isNewNote
                          ? DateFormat('MMMM dd, yyyy').format(DateTime.now())
                          : DateFormat('MMMM dd, yyyy').format(
                            notesProvider.notes
                                    .where((note) => note.id == widget.note?.id)
                                    .firstOrNull
                                    ?.createOrUpdatedAt ??
                                DateTime.now(),
                          ),
                      style: TextStyle(
                        fontSize: AppConstants.font18Px,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: AppConstants.gap24Px),
                    if (isEditing)
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ViewConstants.description,
                        ),
                        style: TextStyle(
                          fontSize: AppConstants.font18Px,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: null,
                        minLines: 1,
                      ),
                    if (!isEditing && !isNewNote)
                      Text(
                        notesProvider.notes
                                .where((note) => note.id == widget.note?.id)
                                .firstOrNull
                                ?.description ??
                            '',
                        style: TextStyle(
                          fontSize: AppConstants.font18Px,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    if (isNewNote)
                      TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: ViewConstants.description,
                        ),
                        style: TextStyle(
                          fontSize: AppConstants.font18Px,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: null,
                        minLines: 1,
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton:
          widget.note != null
              ? FloatingActionButton(
                onPressed: () async {
                  try {
                    await notesProvider.deleteNote(widget.note!.id);
                    if (mounted) {
                      AppRouter.moveBack(context);
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(ViewConstants.errorDeletingNote),
                        ),
                      );
                    }
                  }
                },
                child: const Icon(Icons.delete),
              )
              : null,
    );
  }
}
