import 'package:flutter/material.dart';
import 'package:notes/config/theme/dark.dart';
import 'package:notes/core/constants/app_constants.dart';
import 'package:notes/core/constants/view_constants.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:notes/viewmodels/change_notifier_provider.dart';
import 'package:provider/provider.dart';
import 'package:notes/models/notes_model.dart';
import 'package:notes/views/note_view.dart';
import 'package:notes/widgets/note_card.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Dark.backgroundColor,
      appBar: AppBar(
        backgroundColor: Dark.backgroundColor,
        title:
            _isSearching
                ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                )
                : Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.font12Px,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ViewConstants.notes,
                        style: TextStyle(
                          color: Dark.textColor,
                          fontSize: AppConstants.font18Px * 2,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: Dark.textColor,
            ),
            style: IconButton.styleFrom(iconSize: AppConstants.font18Px * 2),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.font12Px,
            vertical: AppConstants.font12Px,
          ),
          child: Consumer<NotesProvider>(
            builder: (context, provider, child) {
              final List<NotesModel> notes = provider.notes;
              final List<NotesModel> filteredNotes =
                  _searchQuery.isEmpty
                      ? notes
                      : notes
                          .where(
                            (note) => note.title.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                          )
                          .toList();
              final List<StaggeredGridTile> _cardTiles = [];
              for (var note in filteredNotes) {
                _cardTiles.add(
                  StaggeredGridTile.fit(
                    crossAxisCellCount: 1,
                    child: NoteCard(note: note),
                  ),
                );
              }
              return filteredNotes.isEmpty
                  ? const Center(
                    child: Text(
                      ViewConstants.noNotes,
                      style: TextStyle(color: Dark.textColor),
                    ),
                  )
                  : MasonryGridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemBuilder:
                        (context, index) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        NoteView(note: filteredNotes[index]),
                              ),
                            );
                          },
                          child: _cardTiles[index],
                        ),
                    itemCount: _cardTiles.length,
                  );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Dark.addIconColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteView()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
