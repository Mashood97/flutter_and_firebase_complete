import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  final String email;

  AddTask(this.email);

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime _dueDate = DateTime.now();
  String _dateText = '';
  String newTask = '';
  String newNote = '';
  final Firestore _firestore = Firestore.instance;

  Future<Null> _selectedDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
        _dateText = '${picked.day}/${picked.month}/${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _dateText = '${_dueDate.day}/${_dueDate.month}/${_dueDate.year}';
  }

  void _addData() async {
    await _firestore.collection('task').add({
      'email': widget.email,
      'title': newTask,
      'dueDate': _dueDate,
      'note': newNote,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
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
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    newTask = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter New Task',
                  icon: Icon(Icons.dashboard),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Due Date',
                      style: TextStyle(color: Colors.black54, fontSize: 22),
                    ),
                  ),
                  FlatButton(
                    onPressed: () => _selectedDueDate(context),
                    child: Text(
                      _dateText,
                      style: TextStyle(color: Colors.black54, fontSize: 22),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: (val) {
                  setState(() {
                    newNote = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Enter Note',
                  icon: Icon(Icons.note),
                  border: InputBorder.none,
                ),
                style: TextStyle(fontSize: 22, color: Colors.black),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _addData();
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
