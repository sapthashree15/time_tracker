import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];
  final LocalStorage storage = LocalStorage('time_tracker_entries');

  List<TimeEntry> get entries => _entries;

  TimeEntryProvider() {
    loadEntries();
  }

  // Load entries from local storage
  Future<void> loadEntries() async {
    await storage.ready;
    final data = storage.getItem('entries');
    if (data != null) {
      _entries = (data as List)
          .map((entry) => TimeEntry.fromMap(entry))
          .toList();
      notifyListeners();
    }
  }

  // Add a new time entry
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    storage.setItem('entries', _entries.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  // Delete a time entry
  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    storage.setItem('entries', _entries.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  // Get entries grouped by project
  List<TimeEntry> getEntriesByProject(String projectId) {
    return _entries.where((entry) => entry.projectId == projectId).toList();
  }
}
