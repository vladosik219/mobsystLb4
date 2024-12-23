import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier(this.ref, super.state);

  final Ref ref;

  void addStudent(Student student) {
    state = [...state, student];
  }

  void editStudent(Student updatedStudent, int index) {
    final newState = [...state];
    newState[index] = updatedStudent;
    state = newState;
  }

  void insertStudent(Student student, int index) {
    final newState = [...state];
    newState.insert(index, student);
    state = newState;
  }

  void removeStudent(int index) {
    state = state.where((student) => state.indexOf(student) != index).toList();
  }

  void undoDelete(Student student, int index) {
    final newState = [...state];
    newState.insert(index, student);
    state = newState;
  }
}

final studentsProvider =
    StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  return StudentsNotifier(ref, [
    Student(firstName: 'Владлен', lastName: 'Ломако', departmentId: '3', grade: 99, gender: Gender.male),
    Student(firstName: 'Андрій', lastName: 'Омельченко', departmentId: '1', grade: 90, gender: Gender.male),
    Student(firstName: 'Вікторія', lastName: 'Гурєєва', departmentId: '2', grade: 80, gender: Gender.female),
    Student(firstName: 'Тітаренко', lastName: 'Єгор', departmentId: '4', grade: 75, gender: Gender.male),
    Student(firstName: 'Колпащикова', lastName: 'Карина', departmentId: '2', grade: 86, gender: Gender.female),
  ]);
});