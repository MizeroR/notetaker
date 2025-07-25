import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/notes_provider.dart';
import '../widgets/note_item.dart';
import '../widgets/add_edit_note_dialog.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNotes();
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green,
        ),
      );
    }
  }

  Future<void> _fetchNotes() async {
    if (!mounted) return;
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    try {
      await notesProvider.fetchNotes();
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to fetch notes: ${e.toString()}', isError: true);
      }
    }
  }

  Future<void> _addNote() async {
    if (!mounted) return;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => const AddEditNoteDialog(),
    );

    if (!mounted) return;
    if (result != null && result.isNotEmpty) {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      try {
        await notesProvider.addNote(result);
        if (mounted) {
          _showSnackBar('Note added successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to add note: ${e.toString()}', isError: true);
        }
      }
    }
  }

  Future<void> _editNote(String id, String currentText) async {
    if (!mounted) return;
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AddEditNoteDialog(initialText: currentText),
    );

    if (!mounted) return;
    if (result != null && result.isNotEmpty && result != currentText) {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      try {
        await notesProvider.updateNote(id, result);
        if (mounted) {
          _showSnackBar('Note updated successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to update note: ${e.toString()}',
              isError: true);
        }
      }
    }
  }

  Future<void> _deleteNote(String id) async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;
    if (confirmed == true) {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      try {
        await notesProvider.deleteNote(id);
        if (mounted) {
          _showSnackBar('Note deleted successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showSnackBar('Failed to delete note: ${e.toString()}',
              isError: true);
        }
      }
    }
  }

  Future<void> _signOut() async {
    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      await authProvider.signOut();
      if (mounted) {
        _showSnackBar('Signed out successfully!');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Failed to sign out: ${e.toString()}', isError: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (notesProvider.notes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.note_add_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nothing here yet—tap ➕ to add a note.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _fetchNotes,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notesProvider.notes.length,
              itemBuilder: (context, index) {
                final note = notesProvider.notes[index];
                return NoteItem(
                  note: note,
                  onEdit: () => _editNote(note.id, note.text),
                  onDelete: () => _deleteNote(note.id),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
