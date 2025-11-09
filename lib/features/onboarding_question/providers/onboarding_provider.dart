import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:test/core/models/models.dart';
import 'package:test/core/services/networkClient/network.dart';
import 'package:test/features/onboarding_question/api/api.dart';


final dioClientProvider = Provider((ref) => DioClient());

final experiencesApiProvider =
    Provider((ref) => ExperiencesApi(ref.watch(dioClientProvider)));

final experiencesRepositoryProvider = experiencesApiProvider;

final experiencesListProvider = FutureProvider<List<Experience>>((ref) async {
  return ref.read(experiencesRepositoryProvider).fetchExperiences();
});

class ExperienceSelectionState {
  final List<int> selectedIds;
  final String note; // multi-line text (250 limit)
  final String? mediaPath; // Path to recorded media (audio/video)
  
  ExperienceSelectionState({
    required this.selectedIds, 
    required this.note,
    this.mediaPath,
  });
  
  ExperienceSelectionState copyWith({
    List<int>? selectedIds,
    String? note,
    String? mediaPath,
  }) {
    return ExperienceSelectionState(
      selectedIds: selectedIds ?? this.selectedIds,
      note: note ?? this.note,
      mediaPath: mediaPath ?? this.mediaPath,
    );
  }
}

class ExperienceSelectionNotifier extends StateNotifier<ExperienceSelectionState> {
  ExperienceSelectionNotifier()
      : super(ExperienceSelectionState(selectedIds: [], note: ''));

  void toggleSelection(int id) {
    final ids = [...state.selectedIds];
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
    state = state.copyWith(selectedIds: ids);
  }

  void setNote(String value) {
    final truncated = value.length <= 250 ? value : value.substring(0, 250);
    state = state.copyWith(note: truncated);
  }

  void setMediaPath(String path) {
    state = state.copyWith(mediaPath: path);
  }

  void clearMedia() {
    state = state.copyWith(mediaPath: null);
  }

  void clear() => state = ExperienceSelectionState(selectedIds: [], note: '');
}

final experienceSelectionProvider = StateNotifierProvider<
    ExperienceSelectionNotifier, ExperienceSelectionState>((ref) {
  return ExperienceSelectionNotifier();
});
