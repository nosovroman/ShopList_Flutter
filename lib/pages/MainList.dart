import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/MyList.dart';
import 'package:flutter_app/pages/CurrentList.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class MainList extends StatefulWidget {
  const MainList({Key? key}) : super(key: key);

  @override
  _MainListState createState() => _MainListState();
}

class _MainListState extends State<MainList> {
  List<MyList> lists = <MyList>[];
  late SharedPreferences sharedPreferences;

  String listName = "";
  var textFieldController = TextEditingController();

  final marginOfCards = 20.0;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]
    );

    return Scaffold(

        appBar: AppBar(
          title: Text("Список покупок"),
          centerTitle: true,
          backgroundColor: myAppBarColor,
        ),

        body: Container(
          color: myMainColor,
          child: Column(
            children: [
              // поле для создания нового списка
              Container(
                padding: EdgeInsets.only(top: 20.0, bottom: 15.0, left: 20, right: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // поле для ввода, TextField
                    new Flexible(
                      child: TextField(
                        controller: textFieldController,
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (String value) {
                          listName = value;
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Название списка",
                          hintStyle: TextStyle(color: Colors.cyan),
                          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                          // свойства при наведении на инпут
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0)),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                bottomLeft: Radius.circular(15.0)),
                            borderSide: BorderSide(
                              color: Colors.cyan,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // кнопка "Создать"
                    SizedBox(
                      height: 48.0,
                      //color: Colors.yellow,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15.0),
                                    bottomRight: Radius.circular(15.0)),
                              )),
                          onPressed: () {
                            if (listName.trim() != "") {
                              var uuid = Uuid();
                              setState(() {
                                lists.add(new MyList(name: listName, listId: uuid.v4()));
                              });
                              saveData();
                              listName = "";
                              textFieldController.clear();
                            }
                          },
                          child: Text("Создать")),
                    ),
                  ],
                ),
              ),

              // список продуктов
              new Flexible(
                child: Container(
                  //key: key1,
                  margin: EdgeInsets.symmetric(horizontal: marginOfCards, vertical: 0.0),
                  child: ListView.builder(
                    itemCount: lists.length,
                    itemBuilder: (BuildContext context, int index) {
                      int listMaxIndex = lists.length - 1;

                      return
                        //Dismissible(
                      //   direction: DismissDirection.none,
                      //   key: Key(lists[index].listId),
                      //   child:

                        // конкретный список
                        Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          //padding: EdgeInsets.only(left: 1.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: Color(0x00ffffff),
                              border: Border.all(color: myDarkBlueColor)
                          ),

                          child: Stack(
                            children: [
                              ListTile(
                                title: Text(lists[listMaxIndex-index].name, style: TextStyle(fontWeight: FontWeight.bold)),//products[index].name), // style: TextStyle(decoration: TextDecoration.lineThrough),),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // кнопка удаления списка
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_sweep,
                                        color: Colors.blue,//Color(0xff4c9eff),
                                      ),
                                      onPressed: () {
                                        //print("---------------------removed:" + lists[index].listId);
                                        sureDeleteList(lists, listMaxIndex-index);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  //print(lists[index].name);
                                  toCurrentList(lists[listMaxIndex-index].listId, lists[listMaxIndex-index].name);
                                },
                              ),
                            ],
                          ),
                        //),
                        // onDismissed: (direction) {
                        //   setState(() {
                        //     lists.removeAt(index);
                        //     saveChanges();
                        //   });
                        // },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }

  // ------------------------------ Методы
  void saveData() {
    saveChanges();
  }

  void loadData() {
    List<String>? spList = sharedPreferences.getStringList("lists");
    if (spList != null) {
      setState(() {
        lists = spList.map((item) => MyList.fromMap(json.decode(item))).toList();
      });
    }

    getAllSP();
  }

  void saveChanges() {
    List<String> spList = lists.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList("lists", spList);

    //print(spList);
    getAllSP();
  }

  void sureDeleteList(List<MyList> currentList, int index) {
    MyList deletingList = currentList[index];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: myMainColor,
            title: Text("Удаление \"${deletingList.name}\""),
            content: Text("Вы действительно хотите удалить список \"${deletingList.name}\"?"),

            actions: [
              Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // кнопка отмена
                  Flexible(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: myMainColor, // background
                        onPrimary: myDarkBlueColor,
                      ),

                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                      child: Text("Отмена"),
                    ),
                  ),

                  // кнопка удаление списка
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () {

                          removeSharedPrefData(lists[index].listId);
                          setState(() {
                            lists.removeAt(index);
                            saveChanges();
                          });

                          Navigator.of(context).pop();
                        },
                        child: Text("Удалить", textAlign: TextAlign.center)
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  void removeSharedPrefData(String listId) async {
    await sharedPreferences.remove(listId);

    //await sharedPreferences.clear();
  }

  void toCurrentList(String curListId, String curListName) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CurrentList(listId: curListId, listName: curListName),
        ));
  }

  void getAllSP() {
    final keys = sharedPreferences.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
      prefsMap[key] = sharedPreferences.get(key);
    }
    print(prefsMap);
  }
}


// ElevatedButton(onPressed: () {
// //Navigator.pushReplacementNamed(context, "/list");
// //Navigator.pushNamedAndRemoveUntil(context, "/list", (route) => false);
// Navigator.pushNamed(context, "/list");
// },
// child: Text("Запуск")
// ),