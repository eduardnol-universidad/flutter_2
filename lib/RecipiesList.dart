import 'package:ac7/Model/RecipieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipiesList extends StatelessWidget {
  const RecipiesList({Key? key}) : super(key: key);

  Future<List<Recipie>> retrieveRecipies() async {
    var downloadedData =
    await FirebaseFirestore.instance.collection('recipies').get();
    List<Recipie> recipieRetrievalList = [];
    for (var element in downloadedData.docs) {
      recipieRetrievalList.add(Recipie(
        description: element.data()['description'], name: element.data()['name']
      ));
    }
    return recipieRetrievalList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: retrieveRecipies(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error);
          return const Text('Connection ERROR');
        } else {
          List<Recipie>? recipieRetrievalList = snapshot.data;
          return ListView.builder(
              itemCount: recipieRetrievalList!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(recipieRetrievalList[index].name),
                    subtitle:  Text(recipieRetrievalList[index].description),
                    leading: const CircleAvatar(
                      child: Text('R'),
                    ),
                  ),
                );
              });
        }
      },
    );
  }
}

