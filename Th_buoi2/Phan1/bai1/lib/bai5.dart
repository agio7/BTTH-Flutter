import 'package:flutter/material.dart';
import 'package:bai1/models/contact.dart'; // Đúng tên project


class Exercise05 extends StatelessWidget {
  final List<Contact> contacts = List.generate(
    20,
        (index) => Contact(
      index,
      'MyContact $index',
      'assets/images/contact.png',
      '088899988$index',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: const Text('CONTACTS')),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: TabBarView(
            children: [
              const Center(child: Text('Contact yêu thích')),
              const Center(child: Text('Contact gọi gần đây')),
              ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Image.asset(contacts[index].avatar, width: 40),
                    title: Text(contacts[index].name),
                    subtitle: Text(contacts[index].phone),
                    trailing: TextButton(
                      onPressed: () {},
                      child: const Icon(Icons.call),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: const Material(
          color: Colors.red,
          child: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.favorite), text: 'Favourites'),
              Tab(icon: Icon(Icons.recent_actors), text: 'Recent'),
              Tab(icon: Icon(Icons.contacts), text: 'Contacts'),
            ],
          ),
        ),
      ),
    );
  }
}
