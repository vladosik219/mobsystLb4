import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class StudentsNotifier extends StateNotifier<List<Student>> {
  StudentsNotifier(this.ref, super.state);

  final Ref ref;
  final String databaseUrl = 'https://laba4-31f1f-default-rtdb.firebaseio.com/';
  //https://laba4-31f1f-default-rtdb.firebaseio.com/

  Future<void> fetchStudents() async {
    final url = Uri.parse('$databaseUrl/students.json');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<Student> loadedStudents = [];
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>;
      extractedData.forEach((studentId, studentData) {
        loadedStudents.add(Student(
          id: studentId,
          firstName: studentData['firstName'],
          lastName: studentData['lastName'],
          departmentId: studentData['departmentId'],
          gender: Gender.values.firstWhere((e) => e.toString() == studentData['gender']),
          grade: studentData['grade'],
        ));
      });
      state = loadedStudents;
    } else {
      throw Exception('Failed to load students');
    }
  }

  Future<void> addStudent(Student student) async {
    final url = Uri.parse('$databaseUrl/students.json');
    final response = await http.post(
      url,
      body: jsonEncode({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'departmentId': student.departmentId,
        'gender': student.gender.toString(),
        'grade': student.grade,
      }),
    );

    if (response.statusCode == 200) {
      final newStudent = student.copyWith(id: jsonDecode(response.body)['name']);
      state = [...state, newStudent];
    } else {
      throw Exception('Failed to add student');
    }
  }

  Future<void> editStudent(Student student, int index) async {
    final url = Uri.parse('$databaseUrl/students/${student.id}.json');
    final response = await http.put(
      url,
      body: jsonEncode({
        'firstName': student.firstName,
        'lastName': student.lastName,
        'departmentId': student.departmentId,
        'gender': student.gender.toString(),
        'grade': student.grade,
      }),
    );

    if (response.statusCode == 200) {
      final newState = [...state];
      newState[index] = student;
      state = newState;
    } else {
      throw Exception('Failed to edit student');
    }
  }

  Future<void> removeStudent(Student student) async {
    final url = Uri.parse('$databaseUrl/students/${student.id}.json');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      state = state.where((s) => s.id != student.id).toList();
    } else {
      throw Exception('Failed to delete student');
    }
  }

  void removeStudentLocal(int index) {
    state = state.where((student) => state.indexOf(student) != index).toList();
  }

  void insertStudentLocal(Student student, int index) {
    final newState = [...state];
    newState.insert(index, student);
    state = newState;
  }
}

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  return StudentsNotifier(ref, []);
});
/*
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
});*/