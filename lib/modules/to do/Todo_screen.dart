/*import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/services/toast.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<TodoItem> items = [];
  late TextEditingController _textEditingController;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    fetchTodoItems();
  }

  void fetchTodoItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection('todoItems')
          .get();

      List<TodoItem> fetchedItems = [];
      snapshot.docs.forEach((doc) {
        TodoItem item = TodoItem(
          title: doc['title'],
          isChecked: doc['isChecked'],
        );
        fetchedItems.add(item);
      });

      setState(() {
        items = fetchedItems;
        isloading = false;
      });
    }
  }

  void removeTodoItem(int index) {
    if (items.isEmpty || index < 0 || index >= items.length) {
      print('Invalid index or empty list');
      return;
    }

    final itemToRemove = items[index]; // Get the item to be removed

    setState(() {
      items.removeAt(index);
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('todoItems')
          .doc(itemToRemove.title) // Use the title of the removed item
          .delete();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: mainColor, size: 40.0),
                Text(
                  'Todo List',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: SpinKitFoldingCube(
            color: mainColor,
            size: 50,
          ),
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: TodoListItem(
                            todoItem: items[index],
                            onCheckboxChanged: (value) async {
                              setState(() {
                                items[index].isChecked = value!;
                              });

                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('todoItems')
                                    .doc(items[index].title)
                                    .update({'isChecked': value});
                              }
                            },
                            onRemove: () {
                              removeTodoItem(index);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No todo items',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextFormField(
                  controller: _textEditingController,
                  autofocus: true,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Add a new task',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_textEditingController.text.trim().isEmpty) {
                        // Show a toast message
                        showToast(message: 'Please enter a todo item');
                        return;
                      }

                      setState(() {
                        items.add(TodoItem(
                          title: _textEditingController.text,
                          isChecked: false,
                        ));
                      });

                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('todoItems')
                            .doc(_textEditingController.text)
                            .set({
                          'title': _textEditingController.text,
                          'isChecked': false,
                        });
                      }

                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: mainColor,
        elevation: 1,
      ),
    );
  }
}

class TodoItem {
  final String title;
  bool isChecked;

  TodoItem({required this.title, this.isChecked = false});
}

class TodoListItem extends StatelessWidget {
  final TodoItem todoItem;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onRemove;

  TodoListItem({
    required this.todoItem,
    required this.onCheckboxChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
        top: 10,
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.4),
            offset: Offset(0, 4),
            blurRadius: 9,
            spreadRadius: -4,
          )
        ],
        borderRadius: BorderRadius.circular(5),
        color: Color.fromARGB(255, 234, 234, 234),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Checkbox(
              value: todoItem.isChecked,
              onChanged: onCheckboxChanged,
              checkColor: Colors.white,
              activeColor: mainColor,
            ),
            Expanded(
              child: Text(
                todoItem.title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  decoration: todoItem.isChecked
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            IconButton(
              onPressed: onRemove,
              icon: Icon(
                Icons.delete_outline_sharp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:nile_quest/services/toast.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  late List<TodoItem> items = [];
  late TextEditingController _textEditingController;
  bool isloading = true;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    fetchTodoItems();
  }

  void fetchTodoItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .collection('todoItems')
          .get();

      List<TodoItem> fetchedItems = [];
      snapshot.docs.forEach((doc) {
        TodoItem item = TodoItem(
          title: doc['title'],
          isChecked: doc['isChecked'],
        );
        fetchedItems.add(item);
      });

      setState(() {
        items = fetchedItems;
        isloading = false;
      });
    }
  }

  void removeTodoItem(int index) {
    if (items.isEmpty || index < 0 || index >= items.length) {
      print('Invalid index or empty list');
      return;
    }

    final itemToRemove = items[index]; // Get the item to be removed

    setState(() {
      items.removeAt(index);
    });

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('todoItems')
          .doc(itemToRemove.title) // Use the title of the removed item
          .delete();
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check, color: mainColor, size: 40.0),
                Text(
                  'Todo List',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Visibility(
        visible: isloading,
        child: Center(
          child: SpinKitFoldingCube(
            color: mainColor,
            size: 50,
          ),
        ),
        replacement: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {},
                          child: TodoListItem(
                            todoItem: items[index],
                            onCheckboxChanged: (value) async {
                              setState(() {
                                items[index].isChecked = value!;
                              });

                              User? user = FirebaseAuth.instance.currentUser;
                              if (user != null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .collection('todoItems')
                                    .doc(items[index].title)
                                    .update({'isChecked': value});
                              }
                            },
                            onRemove: () {
                              removeTodoItem(index);
                            },
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'No todo items',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Todo'),
                content: TextFormField(
                  controller: _textEditingController,
                  autofocus: true,
                  cursorColor: mainColor,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: 'Add a new task',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      if (_textEditingController.text.trim().isEmpty) {
                        // Show a toast message
                        showToast(message: 'Please enter a todo item');
                        return;
                      }

                      setState(() {
                        items.add(TodoItem(
                          title: _textEditingController.text,
                          isChecked: false,
                        ));
                      });

                      User? user = FirebaseAuth.instance.currentUser;
                      if (user != null) {
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.uid)
                            .collection('todoItems')
                            .doc(_textEditingController.text)
                            .set({
                          'title': _textEditingController.text,
                          'isChecked': false,
                        });
                      }

                      _textEditingController.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
        label: const Text(
          'Add Task',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: mainColor,
        elevation: 1,
      ),
    );
  }
}

class TodoItem {
  final String title;
  bool isChecked;

  TodoItem({required this.title, this.isChecked = false});
}

class TodoListItem extends StatelessWidget {
  final TodoItem todoItem;
  final ValueChanged<bool?> onCheckboxChanged;
  final VoidCallback onRemove;

  TodoListItem({
    required this.todoItem,
    required this.onCheckboxChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(todoItem.title),
      background: Container(
        color: Colors.red,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (_) {
        onRemove();
      },
      direction: DismissDirection.endToStart,
      child: Container(
        margin: EdgeInsets.only(
          left: 10,
          right: 10,
          bottom: 10,
          top: 10,
        ),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.4),
              offset: Offset(0, 4),
              blurRadius: 9,
              spreadRadius: -4,
            )
          ],
          borderRadius: BorderRadius.circular(5),
          color: Color.fromARGB(255, 234, 234, 234),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Checkbox(
                value: todoItem.isChecked,
                onChanged: onCheckboxChanged,
                checkColor: Colors.white,
                activeColor: mainColor,
              ),
              Expanded(
                child: Text(
                  todoItem.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    decoration: todoItem.isChecked
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
