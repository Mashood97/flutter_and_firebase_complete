import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditData extends StatefulWidget {
  final duedate;
  final String title;
  final String note;
  final index;

  EditData({this.duedate, this.title, this.note,this.index});

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<EditData> {
  var _dueDate;
  String _dateText = '';
  String newTask = '';
  String newNote = '';
  final Firestore _firestore = Firestore.instance;

  TextEditingController _titlecontroller;
  TextEditingController _notecontroller;

  Future<Null> _selectedDueDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
    _dueDate = widget.duedate;
    _dateText = _dueDate.toString();
      _titlecontroller = TextEditingController(text: widget.title);
    _notecontroller = TextEditingController(text: widget.note);
  }

  void _updatetask() async {
    await _firestore.runTransaction((transaction)async{
      DocumentSnapshot snapshot = await transaction.get(widget.index);
      await transaction.update(snapshot.reference,{
        'title':newTask == ''? widget.title:newTask,
        'note':newNote =='' ? widget.note: newNote,
        'dueDate':_dueDate == '' ? widget.duedate: _dueDate,
      });
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
                controller: _titlecontroller,
                onChanged: (val) {
                  setState(() {
                    newTask = val;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Edit Task',
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
                controller: _notecontroller,
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
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _updatetask();
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
