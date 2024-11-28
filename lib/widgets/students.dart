import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';
import 'NewStudent.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  final List<Student> students = [
        Student(
      firstName: 'Владлен',
      lastName: 'Ломако',
      department: Department.it,
      grade: 99,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Андрій',
      lastName: 'Омельченко',
      department: Department.finance,
      grade: 90,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Вікторія',
      lastName: 'Гурєєва',
      department: Department.law,
      grade: 80,
      gender: Gender.female,
    ),
    Student(
      firstName: 'Тітаренко',
      lastName: 'Єгор',
      department: Department.medical,
      grade: 75,
      gender: Gender.male,
    ),
    Student(
      firstName: 'Колпащикова',
      lastName: 'Карина',
      department: Department.law,
      grade: 86,
      gender: Gender.female,
    ),
  ];

  Student? _recentlyDeletedStudent; // Зберігає видаленого студента для Undo
  int? _recentlyDeletedIndex; // Зберігає індекс видаленого студента

  void _addStudent() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewStudent(
          onSave: (newStudent) {
            setState(() {
              students.add(newStudent);
            });
          },
        );
      },
    );
  }

  void _editStudent(Student student) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return NewStudent(
          student: student,
          onSave: (updatedStudent) {
            setState(() {
              final index = students.indexOf(student);
              students[index] = updatedStudent;
            });
          },
        );
      },
    );
  }

  void _deleteStudent(int index) {
    setState(() {
      _recentlyDeletedStudent = students[index];
      _recentlyDeletedIndex = index;
      students.removeAt(index); // Видаляємо студента зі списку
    });

    // Показуємо Snackbar із можливістю скасування
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Deleted ${_recentlyDeletedStudent!.firstName} ${_recentlyDeletedStudent!.lastName}',
        ),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoDelete, // Повертаємо видаленого студента
        ),
        duration: const Duration(seconds: 3), // Тривалість показу Snackbar
      ),
    );
  }

  void _undoDelete() {
    if (_recentlyDeletedStudent != null && _recentlyDeletedIndex != null) {
      setState(() {
        students.insert(_recentlyDeletedIndex!, _recentlyDeletedStudent!);
        _recentlyDeletedStudent = null;
        _recentlyDeletedIndex = null;
      });
    }
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (ctx) {
                  return NewStudent(
                    onSave: (newStudent) {
                      setState(() {
                        students.add(newStudent);
                      });
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(students[index]),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (direction) {
              _deleteStudent(index);
            },
            child: InkWell(
              onTap: () => _editStudent(students[index]),
              child: StudentItem(student: students[index]),
            ),
          );
        },
        separatorBuilder: (ctx, index) =>
            Divider(height: 1, color: Colors.grey[300]),
      ),
    );
  }
}