import 'package:ac7/Model/RecipieModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RecipiesList extends StatefulWidget {
  const RecipiesList({Key? key}) : super(key: key);

  @override
  _RecipiesListState createState() => _RecipiesListState();
}

class _RecipiesListState extends State<RecipiesList> {
  List<Recipie> recipieRetrievalList = [];
  bool _isLoadingData = true;

  @override
  initState() {
    super.initState();
    retrieveRemoteData();
  }

  retrieveRemoteData() async {
    FirebaseFirestore.instance
        .collection('recipies')
        .snapshots()
        .listen((event) {
      _isLoadingData = false;
      recipieRetrievalList.clear();

      for (var element in event.docs) {
        recipieRetrievalList.add(Recipie(
            description: element.data()['description'],
            name: element.data()['name'],
            url: element.data()['image']));
      }

      recipieRetrievalList
          .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoadingData
        ? const Center(child: CircularProgressIndicator())
        : recipieRetrievalList.isEmpty
            ? const Center(child: Text('No data found'))
            : ListView.builder(
                itemCount: recipieRetrievalList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(recipieRetrievalList[index].name),
                      subtitle: Text(recipieRetrievalList[index].description),
                      leading: CircleAvatar(
                        child: Image.network(
                          recipieRetrievalList[index].url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                });
  }
}
