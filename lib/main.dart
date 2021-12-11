import 'dart:html';
import "";
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.grey,
      ),
      home: MyApp(),
    ));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String todoTitle = "";

  createTodos() {
    DocumentReference documentReference =
        FireStore.instance.collection("MyTodos").document(input);

    // Map

    Map<String, String> todos = {"todoTitle": input};

    documentReference.setData(todos).whenComplete(() {
      print("$input created");
    });
  }

  deleteTodos(item) {
    DocumentReference documentReference =
        FireStore.instance.collection("MyTodos").document(item);

    documentReference.delete().whenComplete(() {
      print("$item Deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My TODOs"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext Context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("Add todo list"),
                  content: TextField(
                    onChanged: (String Value) {
                      input = Value;
                    },
                  ),
                  actions: <Widget>[
                    // ignore: deprecated_member_use
                    FlatButton(
                        onPressed: () {
                          createTodos();
                        
                          Navigator.of(context).pop();
                        },
                        child: Text("Add")),
                  ],
                );
              });
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("MyTodos").snapshots(),
          builder: (context, snapshots) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (Context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.documents[index];
                  return Dismissible(
                    onDismissed: (direction){
                      deleteTodos(documentSnapshot["todoTitle"]);
                    },
                      key: Key(documentSnapshot["todoTitle"]),
                      child: Card(
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(documentSnapshot[index]),
                          trailing: IconButton(
                            onPressed: () {
                              deleteTodos(documentSnapshot["todoTitle"]);
                            },
                            icon: Icon(Icons.delete),
                            color: Colors.red),
                            

                          ),
                        ),
                      ));
                });
          }),
    );
  }
}
