import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoastalert/FlutterToastAlert.dart';
import 'package:intl/intl.dart';

import 'package:toast_message_bar/toast_message_bar.dart';

import 'package:todo/contants.dart';

List tasknames = [];
List dateList = [];
List isChecked = [];
List mainlist = [];
TextEditingController Tasktextcontroller = TextEditingController();
TextEditingController edittextcontroller = TextEditingController();

final FireRef = FirebaseFirestore.instance
    .collection("sampleuser")
    .doc("45qdqifG6XBn5182rfCD");

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  @override
  void initState() {
    super.initState();
    loginAndAuthenticateUser();
    fetchDetails();
  }

  fetchDetails() async {
    List detailsList = await getDetailsList();
    if (detailsList == null) {
      print('Unable to Retrieve data');
    } else {
      setState(() {
        mainlist = detailsList;
        if (mainlist != null) {
          tasknames = mainlist[0]['tasknames'];
          isChecked = mainlist[0]['isChecked'];
          dateList = mainlist[0]['time'];
        }

        print(mainlist[0]['tasknames']);
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("To-Do App"),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: Text("Add"),
            onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Create new Task'),
                    content: const Text('Task Description'),
                    actions: <Widget>[
                      TextFormField(
                        controller: Tasktextcontroller,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, 'Cancel');
                                Tasktextcontroller.clear();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                tasknames.add(Tasktextcontroller.text);

                                isChecked.add(false);
                                print(isChecked);
                                print(tasknames);
                                DateTime now = DateTime.now();
                                String formattedDate =
                                    DateFormat('kk:mm - dd-MM-yyyy')
                                        .format(now);
                                dateList.add(formattedDate);

                                Navigator.pop(context, 'OK');
                                FireRef.update({
                                  "tasknames": tasknames,
                                  "isChecked": isChecked,
                                  "time": dateList
                                });
                                Tasktextcontroller.clear();

                                setState(() {});
                                await FlutterToastAlert.showToastAndAlert(
                                    type: Type.Success,
                                    androidToast: "Task Added Successfully",
                                    toastDuration: 3,
                                    toastShowIcon: true);
                              },
                              child: const Text('OK'),
                            ),
                          ]),
                    ],
                  ),
                ),
            backgroundColor: Colors.orange,
            icon: const Icon(Icons.add)),
        body: Container(
            child: ListView.builder(
          itemCount: tasknames.length,
          itemBuilder: (context, index) {
            if (tasknames != null && dateList != null && isChecked != null) {
              return Card(
                  margin: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 15.0, 12.0, 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Checkbox(
                            value: isChecked[index],
                            activeColor: Colors.deepOrangeAccent,
                            onChanged: (newBool) {
                              if (newBool == false) {
                                isChecked[index] = false;
                              } else if (newBool == true) {
                                isChecked[index] = true;
                                print(isChecked);

                                var temp;
                                temp = tasknames[index];
                                tasknames.removeAt(index);
                                tasknames.add(temp);

                                bool temp2 = isChecked[index];
                                isChecked.removeAt(index);
                                isChecked.add(temp2);
                                print(isChecked);

                                var temp3 = dateList[index];
                                dateList.removeAt(index);
                                dateList.add(temp3);
                              }
                              FireRef.update({
                                "tasknames": tasknames,
                                "isChecked": isChecked,
                                "time": dateList
                              });
                              setState(() {});
                            }),
                        Expanded(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                              Text(
                                tasknames[index],
                                style: const TextStyle(
                                    fontSize: 22.0, fontFamily: 'Raleway'),
                              ),
                              SizedBox(
                                height: 6.0,
                              ),
                              Text(
                                'Added: ${dateList[index]}',
                                style: TextStyle(fontSize: 11),
                              ),
                            ])),
                        IconButton(
                          onPressed: () {
                            edittextcontroller.text = tasknames[index];
                            showDialog<String>(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                title: const Text('Edit Task'),
                                content: const Text('Task Description'),
                                actions: <Widget>[
                                  TextFormField(
                                    controller: edittextcontroller,
                                    decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 10),
                                    ),
                                  ),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            print(tasknames);
                                            tasknames[index] =
                                                edittextcontroller.text;
                                            edittextcontroller.clear();
                                            FireRef.update({
                                              "tasknames": tasknames,
                                              "isChecked": isChecked,
                                              "time": dateList
                                            });
                                            setState(() {});
                                            Navigator.pop(context, 'OK');
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ]),
                                ],
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          onPressed: () async {
                            tasknames.removeAt(index);
                            isChecked.removeAt(index);
                            dateList.removeAt(index);
                            FireRef.update({
                              "tasknames": tasknames,
                              "isChecked": isChecked,
                              "time": dateList
                            });
                            setState(() {});
                            await FlutterToastAlert.showToastAndAlert(
                                type: Type.Error,
                                androidToast: "Task Deleted Successfully",
                                toastDuration: 3,
                                toastShowIcon: true);
                          },
                          icon: const Icon(Icons.delete),
                          tooltip: 'Delete',
                        )
                      ],
                    ),
                  ));
            } else {
              print("LIST IS NULL");
            }
          },
        )));
  }
}
