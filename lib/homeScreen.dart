// ignore_for_file: avoid_types_as_parameter_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project2/models/contact.dart';
import 'package:project2/task.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});
  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Future<Box<Contact>> contactsBoxFuture;
  TextEditingController searchContoller = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    contactsBoxFuture = Hive.openBox<Contact>('contactBox');
    searchContoller.addListener(() {
      setState(() {
        searchQuery = searchContoller.text;
      });
    });
  }

  void navigateToInputPage() async {
    final contact = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Task()),
    );
    if (contact != null) {
      final box = await contactsBoxFuture;
      box.add(contact);
      setState(() {});
    }
  }

  void updateData(int index, Contact contact) async {
    final updatedContact = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Task()));
    if (updatedContact != null) {
      final box = await contactsBoxFuture;
      box.putAt(index, updatedContact);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Contacts"),
        centerTitle: true,
        backgroundColor: Colors.pink.shade200,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SizedBox(
              width: 200,
              child: TextFormField(
                controller: searchContoller,
                decoration: InputDecoration(
                    hintText: 'Search Contact',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          )
        ],
      ),
      body: FutureBuilder<Box<Contact>>(
        future: contactsBoxFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading contacts.'));
          } else {
            final contactsBox = snapshot.data!;
            return ValueListenableBuilder(
              valueListenable: contactsBox.listenable(),
              builder: (context, Box<Contact> box, _) {
                final allContacts = box.values.toList();
                final filterContacts = allContacts.where((Contact) {
                  final query = searchQuery.toLowerCase();
                  return Contact.name.toLowerCase().contains(query) ||
                      Contact.phone.contains(query);
                }).toList();
                if (filterContacts.isEmpty) {
                  return const Center(child: Text('No contacts found.'));
                }
                return ListView.builder(
                  itemCount: filterContacts.length,
                  itemBuilder: (context, index) {
                    final contact = filterContacts[index];
                    return InkWell(
                      onTap: () {
                        updateData(index, contact);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Card(
                          child: ListTile(
                            title: Text(contact.name),
                            subtitle: Text(contact.phone),
                            trailing: IconButton(
                              onPressed: () => box.deleteAt(index),
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
               );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: navigateToInputPage,
        child: const Icon(Icons.add),
      ),
    );
  }
}
