import 'package:flutter/material.dart';
import 'package:project2/models/contact.dart';

class Task extends StatefulWidget {
  const Task({super.key});

  @override
  State<Task> createState() => _TaskState();
}

class _TaskState extends State<Task> {
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();

  void SaveContact() {
    final name = _nameController.text;
    final phone = _numberController.text;

    if (name.isNotEmpty && phone.isNotEmpty) {
      final contact = Contact(name: name, phone: phone);
      Navigator.pop(context, contact);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contacts"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade200,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(
              Icons.search_sharp,
              size: 40,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: TextFormField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: 'Number',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
          ),
          ElevatedButton(
              onPressed: () {
                SaveContact();
              },
              child: const Text(
                "SAVE",
                style: TextStyle(color: Colors.black),
              ))
        ],
      ),
    );
  }
}
