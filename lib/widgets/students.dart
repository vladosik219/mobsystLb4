import 'package:flutter/material.dart';
import '../models/student.dart';
import 'student_item.dart';

class StudentsScreen extends StatelessWidget {
  StudentsScreen({super.key});

  // Список студентів
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
    // Додайте більше студентів 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Логіка для додавання студента, наприклад, відкриття форми
            },
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: students.length,
        itemBuilder: (ctx, index) {
          return StudentItem(student: students[index]);
        },
        separatorBuilder: (ctx, index) => Divider(height: 1, color: Colors.grey[300]),
      ),
    );
  }
}
