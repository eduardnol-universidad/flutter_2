import 'package:flutter/material.dart';

class RecipiesList extends StatelessWidget {
  const RecipiesList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Recipie $index'),
                subtitle: const Text('This is a description of the recipie'),
                leading: const CircleAvatar(
                  child: Text('R'),
                ),
              ),
            );
          }),
    );
  }
}