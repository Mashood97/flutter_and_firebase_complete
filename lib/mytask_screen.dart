import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterandfirebasecomplete/add_task.dart';
import 'package:flutterandfirebasecomplete/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

import 'edit_task_screen.dart';

class MyTask extends StatelessWidget {
  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  MyTask({this.user, this.googleSignIn});

  void _signOut(BuildContext context) {
    AlertDialog dialog = AlertDialog(
      content: Container(
        height: 215.0,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: Image.network(user.photoUrl),
            ),
            Text(
              'Signout',
              style: TextStyle(fontSize: 16),
            ),
            Divider(),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('YES'),
          onPressed: () {
            googleSignIn.signOut();
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => MyHomePage(),
            ));
          },
        ),
        FlatButton(
          child: Text('NO'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
    showDialog(context: context, child: dialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          splashColor: Colors.amber,
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (ctx) => AddTask(user.email),
            ));
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 20,
          color: Theme.of(context).primaryColor,
          child: ButtonBar(
            children: <Widget>[],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 200.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('task')
                      .where('email', isEqualTo: user.email)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return TaskList(
                      snapshot.data.documents,
                    );
                  },
                ),
              ),
              Container(
                height: 170,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(color: Colors.black, blurRadius: 8.0),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.photoUrl),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          user.displayName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Spacer(),
                        FlatButton(
                          padding: EdgeInsets.all(10),
                          splashColor: Colors.amber,
                          color: Colors.deepPurple,
                          child: Text(
                            'Logout',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            _signOut(context);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    Text(
                      'My Task',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  final List<DocumentSnapshot> document;

  TaskList(this.document);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: document.length,
        itemBuilder: (ctx, i) {
          return Dismissible(
            background: Container(
              height: 100,
              color: Colors.red,
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            direction: DismissDirection.endToStart,
            key: Key(document[i].documentID),
            onDismissed: (direction) {
              Firestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot =
                    await transaction.get(document[i].reference);
                await transaction.delete(snapshot.reference);
              });
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 2),
                content: Text('Deleted Successfully'),
              ));
            },
            child: ListTile(
                title: Text(document[i].data['title'].toString()),
                subtitle: Text(document[i].data['note'].toString()),
                leading: Icon(Icons.dashboard),
                trailing: IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ),
                  splashColor: Colors.amber,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => EditData(
                        duedate: document[i].data['dueDate'],
                        title: document[i].data['title'].toString(),
                        note: document[i].data['note'].toString(),
                        index: document[i].reference,
                      ),
                    ));
                  },
                )),
          );
        });
  }
}
