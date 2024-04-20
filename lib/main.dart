import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var a = 3;
  var name = ["김영숙", "홍길동", "피자집"];
  var likes = [0, 0, 0];

  getPermission() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      print('허락됨');
    } else if (status.isDenied) {
      print('거절됨');
      Permission.contacts.request();
      openAppSettings();
    }
  }

  setA() {
    setState(() {
      a++;
    });
  }

  setName(person) {
    setState(() {
      name.add(person);
    });
  }

  deleteName(person) {
    setState(() {
      name = name.where((e) => e != person).toList();
    });
  }

  setSort() {
    setState(() {
      name.sort();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: TextButton(
          onPressed: () {
            setSort();
          },
          child: Text("정렬하기"),
        ),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return Test(state: a, setA: setA, setName: setName);
                  });
            },
          );
        }),
        appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () {
                    getPermission();
                  },
                  icon: Icon(Icons.contacts))
            ],
            title: Text(name.length.toString()),
            leading: Icon(Icons.alarm_rounded)),
        body: ListView.builder(
            itemCount: name.length,
            itemBuilder: (context, index) {
              return Row(
                children: [
                  Expanded(
                    // Expanded 추가하여 ListTile이 사용 가능한 최대 공간을 채우도록 함
                    child: ListTile(
                      title: Text(name[index]),
                      trailing: TextButton(
                        child: Text("hey"),
                        onPressed: () {
                          setState(() {
                            likes[index]++;
                          });
                        },
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        deleteName(name[index]);
                      },
                      child: Text("삭제하기")),
                ],
              );
            }));
  }
}

class Test extends StatefulWidget {
  Test({key, this.state, this.setA, this.setName}) : super(key: key);
  final state;
  final setA;
  final inputData = TextEditingController();
  final setName;
  var value = "";

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: SizedBox(
      width: 150,
      height: 200,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 10), child: Text("Contact")),
          TextField(
            controller: widget.inputData,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Hint'),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      if (widget.inputData.text.isEmpty) {
                        return;
                      }
                      widget.setName(widget.inputData.text);
                      Navigator.of(context).pop();
                    },
                    child: Text("완료")),
              ],
            ),
          )
        ]),
      ),
    ));
  }
}
