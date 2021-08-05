import 'dart:convert';
//import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/assets/my_flutter_app_icons.dart';
//import 'package:flutter_app/for_fonts/check_mark_icon_1.dart';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/models/MyProduct.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
//import CustomIcons from '../lib/for_fonts/custom_icons_icons.dart'

class CurrentList extends StatefulWidget {
  final String listId, listName;
  const CurrentList({Key? key, required this.listId, required this.listName,}) : super(key: key);

  @override
  _CurrentListState createState() => _CurrentListState(listId, listName);
  
}

class _CurrentListState extends State<CurrentList> {
  String listId, listName, temp = "4673fa48-8899-4801-9fee-941c5f569464";
  _CurrentListState(this.listId, this.listName);

  List<MyProduct> products = <MyProduct>[];
  late SharedPreferences sharedPreferences;

  String productName = "";
  var textFieldNewProductController = TextEditingController();

  final marginOfCards = 20.0;
  final keyListView = GlobalKey();
  double width = -1.0;

  @override
  void initState() {
    super.initState();

    initSharedPreferences();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      RenderBox box = keyListView.currentContext!.findRenderObject() as RenderBox;
      setState(() {
        width = box.size.width - 2*(marginOfCards);
      });
    });
  }

  initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  // void menuOpen() {
  //   Navigator.of(context)
  //       .push(MaterialPageRoute(builder: (BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(title: Text("Меню")),
  //       body: Row(
  //         children: [
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pop(context);
  //                 Navigator.pushNamedAndRemoveUntil(
  //                     context, "/", (route) => false);
  //               },
  //               child: Text("На главную")),
  //           Padding(padding: EdgeInsets.only(left: 15)),
  //           Text("Менюшка")
  //         ],
  //       ),
  //     );
  //   }));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        title: Text("Список покупок"),
        centerTitle: true,
        backgroundColor: myAppBarColor,
        // actions: [
        //   IconButton(onPressed: menuOpen, icon: Icon(Icons.menu)),
        // ],
      ),

      body: Container(
        color: myMainColor,
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // название списка и галочка
            Container(
              //color: Colors.white,
              height: 40,
              padding: EdgeInsets.only(bottom: 10.0),
              margin: EdgeInsets.only(left: 29, right: 29),
              child: Row(
                children: [

                  // название списка
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.only(top: 10, right: 0),

                        child:
                        Container(
                          //color: Colors.white,
                          height: 20,
                          child:
                          TextField(
                            controller: new TextEditingController(text: "$listName"),
                            toolbarOptions: ToolbarOptions(
                              copy: false,
                              cut: false,
                              paste: false,
                              selectAll: false,
                            ),
                            enableInteractiveSelection: false,
                            style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                            textCapitalization: TextCapitalization.sentences,
                            textAlignVertical: TextAlignVertical.center,
                            readOnly: true,
                            decoration: //myDecorTextField("$listName", 10.0, myTransparentColor, myTransparentColor),
                            InputDecoration(
                              //hintText: "$listName",
                              //hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                              contentPadding: EdgeInsets.zero,
                              counterText: "",
                              filled: true,
                              fillColor: myTransparentColor,

                              // свойства при наведении на инпут
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: myTransparentColor,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: myTransparentColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                borderSide: BorderSide(
                                  color: myTransparentColor,
                                ),
                              ),
                            ),
                            //minLines: 1,
                            //maxLines: 2,
                          ),
                        ),
                        //Text(listName, style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                    ),
                  ),

                  // галочка
                  checkAllDone(products) && products.isNotEmpty ?
                  Container(
                    //color: Colors.black,
                    margin: EdgeInsets.only(top: 8.5, left: 5.0),
                    child: Icon(
                      MyFlutterApp.ok, color: myCheckMarkColor,
                    ),
                  )
                      :
                  Text(""),

                ],
              ),
            ),

            // поле для добавления нового продукта
            Container(
              padding: EdgeInsets.only(top: 0.0, bottom: 15.0, left: 20, right: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [

                  // поле для ввода, TextField
                  new Flexible(
                    child: TextField(
                      controller: textFieldNewProductController,

                      maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                      maxLength: 50,

                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (String value) {
                        // if (value.length > 50) { value = value.substring(0, 50); }
                        // productName = value;
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        counterText: "",
                        hintText: "Введите название товара",
                        hintStyle: TextStyle(color: Color(0x5E049CAF), fontStyle: FontStyle.italic),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),

                        // свойства при наведении на инпут
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: myButtonAddProductColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: myButtonAddProductColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0)),
                          borderSide: BorderSide(
                            color: myButtonAddProductColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // кнопка "Добавить"
                  SizedBox(
                    height: 48.0,
                    //color: Colors.yellow,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: myButtonAddProductColor, // background// 0xFF3C94A3
                          onPrimary: Color(0xffffffff), // foreground
                          shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(15.0),
                              bottomRight: Radius.circular(15.0)),
                        )),
                        onPressed: () {
                          if (textFieldNewProductController.text.trim() != "") {
                            var uuid = Uuid();
                            setState(() {
                              products.add(new MyProduct(name: textFieldNewProductController.text.trim(), productId: uuid.v4()));
                            });
                            saveData();
                            textFieldNewProductController.text = "";
                            textFieldNewProductController.clear();
                          }
                        },
                        child: Text("Добавить")),
                  ),
                ],
              ),
            ),

            // список продуктов
            new Flexible(
              child: Container(
                key: keyListView,
                margin: EdgeInsets.symmetric(horizontal: marginOfCards, vertical: 0.0),
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (BuildContext context, int index) {
                    double percentDone = products[index].basket/products[index].need;
                    TextEditingController nameCardProductController = new TextEditingController(text: "${products[index].name}");

                    return
                      // Dismissible(
                      // direction: DismissDirection.none,
                      // key: Key(products[index].productId),
                      // child:

                      // конкретный продукт
                      Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
                            //padding: EdgeInsets.only(bottom: 3.0, top: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: products[index].need >= products[index].basket ? myMainColor : myMegaFillColor,
                              border: Border.all(color: myBorderProgressColor),
                            ),

                            child: Stack(
                              children: [
                                Padding(padding: EdgeInsets.only(top: 10)),

                                // заполнители
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: myFillProgressColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(13.5), bottomLeft:  Radius.circular(13.5),
                                              topRight: getRadiusProduct(percentDone), bottomRight: getRadiusProduct(percentDone)
                                          ),
                                        ),

                                        height:
                                            percentDone < 0.01 ? 0 :
                                            percentDone <= 0.0125 ? 44.2 :
                                            percentDone <= 0.015 ? 47.2 :
                                            percentDone <= 0.02 ? 49.8 :
                                            percentDone <= 0.025 ? 52.2 :
                                            percentDone <= 0.03 ? 54 :
                                            percentDone <= 1 ? 56 :

                                            percentDone <= 200/6 ? 56 :
                                            percentDone <= 200/5 ? 52.2 :
                                            percentDone <= 200/4 ? 49.8 :
                                            percentDone <= 200/3 ? 47.2 :
                                            percentDone <= 200/2 ? 44.2 : 0
                                            //percentDone < 200/1 ? 0 : 0,

                                      ),
                                      flex: products[index].need > products[index].basket ? (products[index].basket*1000).toInt() : (products[index].need*1000).toInt(),
                                    ),
                                    Expanded(
                                      child: Container(
                                        //color: products[index].need >= products[index].basket ? Color(0x00ffffff) : Colors.red,
                                          height: 56,
                                      ),
                                        flex: ((products[index].need - products[index].basket).abs()*1000).toInt(),
                                    ),
                                  ],
                                ),

                                // аналог ListTile
                                Container(
                                  height: 56,
                                  child: Align(
                                    alignment: Alignment.center,

                                    // строка с элементами ListTile
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [

                                        // иконка (галочка) с текстом
                                        Flexible(
                                          child: GestureDetector(
                                            onDoubleTap: () {
                                              setDoneElement(products, index);
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                products[index].done ?
                                                Container(
                                                  margin: EdgeInsets.only(left: 10.0),
                                                  //color: Colors.black,
                                                  child: Icon(
                                                    MyFlutterApp.ok, color: myCheckMarkColor,
                                                  ),
                                                )
                                                    : Text(""),

                                                Expanded(
                                                  child: Container(
                                                    margin: EdgeInsets.only(left: 10.0),
                                                    //height: 40,
                                                    //color: Colors.white,
                                                    child: TextFormField(
                                                      controller: nameCardProductController,
                                                      toolbarOptions: ToolbarOptions(
                                                        copy: false,
                                                        cut: false,
                                                        paste: false,
                                                        selectAll: false,
                                                      ),
                                                      enableInteractiveSelection: false,
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                      textCapitalization: TextCapitalization.sentences,
                                                      textAlignVertical: TextAlignVertical.center,
                                                      readOnly: true,
                                                      decoration:
                                                      InputDecoration(
                                                        contentPadding: EdgeInsets.zero,
                                                        counterText: "",
                                                        filled: true,
                                                        fillColor: myTransparentColor,

                                                        // свойства при наведении на инпут
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                          borderSide: BorderSide(
                                                            color: myTransparentColor,
                                                          ),
                                                        ),
                                                        enabledBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                          borderSide: BorderSide(
                                                            color: myTransparentColor,
                                                          ),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                          borderSide: BorderSide(
                                                            color: myTransparentColor,
                                                          ),
                                                        ),
                                                      ),
                                                      minLines: 1,
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        Container(
                                          //color: Colors.yellow,
                                          height: 25, width: 25,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                              onPressed: () async {
                                                await showProductInfo(context, products, index);
                                              },
                                              icon: Icon(Icons.info_outline_rounded)
                                          ),
                                        ),

                                        // popup меню
                                        showPopupMenu(products, index),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          //),
                          // onDismissed: (direction) {
                          //   setState(() {
                          //     products.removeAt(index);
                          //     saveChanges();
                          //   });
                          // },
                          ),

                          // подпись кол-во
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                color: myMainColor,
                                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                                border: Border.all(color: myBorderProgressColor),
                              ),
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                              child: Text(
                                  "${products[index].basket.round()==products[index].basket ?
                                  products[index].basket.toInt() : products[index].basket}"
                                      "/${products[index].need.round()==products[index].need ?
                                  products[index].need.toInt() : products[index].need} "
                                      "${products[index].unit}.", style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
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
    List<String>? spList = sharedPreferences.getStringList(listId);
    if (spList != null) {
      setState(() {
        products = spList.map((item) => MyProduct.fromMap(json.decode(item))).toList();
      });
    }


    final keys = sharedPreferences.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
      prefsMap[key] = sharedPreferences.get(key);
    }
    //print(prefsMap);
  }

  void saveChanges() {
    List<String> spList = products.map((item) => json.encode(item.toMap())).toList();
    sharedPreferences.setStringList(listId, spList);

    //("--------------------------------------------");
    //print(spList);
    getAllSP();
  }

  void getAllSP() {
    final keys = sharedPreferences.getKeys();
    final prefsMap = Map<String, dynamic>();
    for(String key in keys) {
      prefsMap[key] = sharedPreferences.get(key);
    }
    print(prefsMap);
  }

  void toIntIfInteger(double convertingValue) {

  }

  Radius getRadiusProduct(double percentDone) {
    return
      percentDone < 0.98 ? Radius.circular(0) :
      percentDone <= 0.985 ? Radius.circular(5) :
      percentDone <= 0.99 ? Radius.circular(7) :
      percentDone <= 0.995 ? Radius.circular(10) :
      percentDone <= 1.0 ? Radius.circular(14):
      percentDone >= 1.03 ? Radius.circular(0) :
      percentDone >= 1.02 ? Radius.circular(3) :
      percentDone >= 1.015 ? Radius.circular(5) :
      percentDone >= 1.01 ? Radius.circular(7) :
      percentDone >= 1.005 ? Radius.circular(10) : Radius.circular(0);
  }

  InputDecoration myDecorTextField(String hint, double radius, Color color, Color borderColor) {
    return InputDecoration(
      hintText: "$hint",
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
      contentPadding: color != myTransparentColor ? EdgeInsets.symmetric(horizontal: 10.0) : EdgeInsets.zero,
      counterText: "",
      filled: true,
      fillColor: color,
      //labelStyle: TextStyle(decoration: TextDecoration.lineThrough),

      // свойства при наведении на инпут
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        borderSide: BorderSide(
          color: borderColor,
        ),
      ),
    );
  }

  ToolbarOptions mySettingsToolBarOptions() {
    return ToolbarOptions(
      copy: true,
      cut: true,
      paste: false,
      selectAll: true,
    );
  }

  // метод редактирования продукта
  void editProduct(List<MyProduct> productList, int index) {
    MyProduct editingProduct = productList[index];
    // контроллеры
    // имя списка
    TextEditingController nameListController = new TextEditingController(text: "$listName");
    // имя
    TextEditingController nameController = new TextEditingController(text: "${editingProduct.name}");
    // необходимо
    TextEditingController needController = new TextEditingController(
        text: editingProduct.need.round() == editingProduct.need ?
        "${editingProduct.need.toInt()}" : "${editingProduct.need}"
    );
    // ед.измерения
    TextEditingController unitController = new TextEditingController(text: "${editingProduct.unit}");
    // в корзине
    TextEditingController basketController = new TextEditingController(
        text: editingProduct.basket.round() == editingProduct.basket ?
        "${editingProduct.basket.toInt()}" : "${editingProduct.basket}"
    );
    // добавить в корзину
    TextEditingController addController = new TextEditingController(text: "1");
    // убрать из корзины
    TextEditingController subController = new TextEditingController(text: "1");

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: myMainColor,
            title: Text("Редактирование"),
            content:
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // "Название списка"
                      Text("Название списка:"),
                      Padding(padding: EdgeInsets.only(top: 3.0)),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: nameListController,
                          textCapitalization: TextCapitalization.sentences,
                          textAlignVertical: TextAlignVertical.center,
                          // onChanged: (String value) {
                          //   productName = value;
                          // },
                          readOnly: true,
                          decoration: myDecorTextField("$listName", 10.0, myMainColor, Colors.cyan),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0)),

                      // "Название продукта"
                      Text("Название продукта:"),
                      Padding(padding: EdgeInsets.only(top: 3.0)),
                      SizedBox(
                        height: 40,
                        child: TextField(
                          controller: nameController,

                          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                          maxLength: 50,

                          // запрет вставки
                          //toolbarOptions: mySettingsToolBarOptions(),

                          textCapitalization: TextCapitalization.sentences,
                          textAlignVertical: TextAlignVertical.center,
                          // onChanged: (String value) {
                          //   if (value.length > 50) { productName = value.substring(0, 50); }
                          //   productName = value;
                          // },
                          decoration: myDecorTextField("${editingProduct.name}", 10.0, Colors.white, Colors.cyan),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0)),

                      // "Необходимо"
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Необходимо:"),
                          Padding(padding: EdgeInsets.only(right: 5.0)),
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: TextField(
                              controller: needController,

                              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                              maxLength: 8,

                              // запрет вставки
                              toolbarOptions: mySettingsToolBarOptions(),

                              // ввод только чисел
                              inputFormatters: myRegexDigitsDot(),
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                try {
                                  if (value != "" && double.parse(value) > 10000000) needController.text = "10000000";
                                }
                                catch(err) {
                                  // print("oh! " + err.toString());
                                  needController.text = "";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: myDecorTextField("${editingProduct.need}", 8.0, Colors.white, Colors.cyan),
                            ),
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0)),

                      // "Ед.измерения"
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Ед.измерения:"),
                          Padding(padding: EdgeInsets.only(right: 5.0)),
                          SizedBox(
                            width: 70,
                            height: 30,
                            child: TextField(
                              controller: unitController,

                              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                              maxLength: 5,

                              // запрет вставки
                              toolbarOptions: mySettingsToolBarOptions(),

                              onChanged: (String value) {
                                if (value[value.length-1] == ".") {
                                  unitController.text = value.substring(0, value.length-1);
                                  unitController.selection = TextSelection.fromPosition(TextPosition(offset: unitController.text.length));
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: myDecorTextField("${editingProduct.unit}", 8.0, Colors.white, Colors.cyan),
                            ),
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0)),

                      // "В корзине"
                      Text("В корзине (${editingProduct.unit}.):"),
                      Padding(padding: EdgeInsets.only(top: 3.0)),
                      SizedBox(
                        width: 100,
                        height: 30,
                        child: TextField(
                          controller: basketController,

                          maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                          maxLength: 8,

                          // запрет вставки
                          toolbarOptions: mySettingsToolBarOptions(),

                          // ввод только чисел
                          inputFormatters: myRegexDigitsDot(),
                          keyboardType: TextInputType.number,
                          onChanged: (String value) {
                            try{
                              if (value != "" && double.parse(value) > 10000000) basketController.text = "10000000";
                            }
                            catch(err) {
                              //print("oh BASKET! " + err.toString());
                              basketController.text = "";
                            }
                          },
                          textAlign: TextAlign.center,
                          decoration: myDecorTextField("${editingProduct.basket}", 8.0, Colors.white, Colors.cyan),
                        ),
                      ),

                      Padding(padding: EdgeInsets.only(top: 20.0)),

                      // "Добавить в корзину:"
                      Text("Добавить в корзину:"),
                      Padding(padding: EdgeInsets.only(top: 3.0)),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: TextField(
                              controller: addController,

                              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                              maxLength: 8,

                              // запрет вставки
                              toolbarOptions: mySettingsToolBarOptions(),

                              // ввод только чисел
                              inputFormatters: myRegexDigitsDot(),
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                // productName = value;
                                try{
                                  if (value != "" && double.parse(value) > 10000000) addController.text = "10000000";
                                }
                                catch(err) {
                                  // print("oh! " + err.toString());
                                  addController.text = "";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: myDecorTextField("1", 8.0, Colors.white, Colors.cyan),
                            ),
                          ),

                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text("${editingProduct.unit}."),

                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.add_box_rounded),
                            color: Colors.blue,
                            onPressed: (){
                              double basketVal = (basketController.text != "" ? double.parse(basketController.text) : 0.0);
                              double addVal = (addController.text != "" ? double.parse(addController.text) : 1);
                              if (basketVal > 10000000 || addVal > 10000000 || (basketVal + addVal > 10000000)) {
                                basketController.text = "10000000";
                              } else {
                                basketController.text = (basketVal + addVal).toStringAsFixed(3);
                              }
                            },
                          ),
                        ],
                      ),

                      Padding(padding: EdgeInsets.only(top: 10.0)),

                      // "Убрать из корзины:"
                      Text("Убрать из корзины:"),
                      Padding(padding: EdgeInsets.only(top: 3.0)),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 30,
                            child: TextField(
                              controller: subController,

                              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                              maxLength: 8,

                              // запрет вставки
                              toolbarOptions: mySettingsToolBarOptions(),

                              // ввод только чисел
                              inputFormatters: myRegexDigitsDot(),
                              keyboardType: TextInputType.number,
                              onChanged: (String value) {
                                try {
                                  if (value != "" && double.parse(value) > 10000000) subController.text = "10000000";
                                }
                                catch(err) {
                                  // print("oh! " + err.toString());
                                  subController.text = "";
                                }
                              },
                              textAlign: TextAlign.center,
                              decoration: myDecorTextField("1", 8.0, Colors.white, Colors.cyan),
                            ),
                          ),

                          Padding(padding: EdgeInsets.only(left: 5.0)),
                          Text("${editingProduct.unit}."),

                          IconButton(
                            iconSize: 30,
                            icon: Icon(Icons.indeterminate_check_box_rounded),
                            color: Colors.blue,
                            onPressed: (){
                              // проверка на отрицательные числа
                              double basketVal = (basketController.text != "" ? double.parse(basketController.text) : 0);
                              double subVal = (subController.text != "" ? double.parse(subController.text) : 1);
                              if (subVal < basketVal) {
                                basketController.text = (basketVal - subVal).toStringAsFixed(3);
                              }
                              else {
                                basketController.text = "0";
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

            actions: [
              Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
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
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () {
                          editingProduct.productId = products[index].productId;
                          editingProduct.name = nameController.text != "" ? nameController.text : editingProduct.name;
                          editingProduct.need = needController.text != "" ? double.parse(needController.text) : editingProduct.need;
                          editingProduct.unit = unitController.text != "" ? unitController.text : editingProduct.unit;
                          editingProduct.basket = basketController.text != "" ? double.parse(basketController.text) : editingProduct.basket;
                          bool resDone;
                          if (editingProduct.basket >= editingProduct.need) {
                            editingProduct.done = true;
                          } else {editingProduct.done = false;}
                          //String resDescription = products[index].description;

                          setState(() {
                            products[index] = editingProduct;
                          });
                          saveData();
                          Navigator.of(context).pop();
                        },
                        child: Text("Сохранить изменения", textAlign: TextAlign.center)
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }

  List<TextInputFormatter>? myRegexDigitsDot () {
    return [
      FilteringTextInputFormatter.deny(RegExp('-'))
    ];
  }

  void sureDeleteProduct(List<MyProduct> productList, int index) {
    MyProduct editingProduct = productList[index];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: myMainColor,
            title: Text("Удаление \"${editingProduct.name}\""),
            content: Text("Вы действительно хотите удалить продукт \"${editingProduct.name}\" из списка \"$listName\?"),

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

                  // кнопка удаление продукта
                  Flexible(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            products.removeAt(index);
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

  void setDoneElement(List<MyProduct> productList, int index) {
    MyProduct doneProduct = productList[index];
    if (doneProduct.done == false) {
      doneProduct.basket = doneProduct.need;
    } else {doneProduct.basket = 0;}
    doneProduct.done = !doneProduct.done;

    setState(() {
      products[index] = doneProduct;
    });
    saveData();
  }

  Future <void> showProductInfo(BuildContext context, List<MyProduct> productList, int index) async  {
    MyProduct currentProduct = productList[index];
    TextEditingController infoProductController = new TextEditingController(text: "${currentProduct.description}");
    bool editMode = currentProduct.description == "" ? true : false;
    Color borderColor = Colors.cyan;
    double radius = 10.0;



    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              backgroundColor: myMainColor,
              title: Text("Описание \"${currentProduct.name}\""),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Stack(
                        children: [
                          Container(
                            margin: editMode ? EdgeInsets.zero : EdgeInsets.only(top: 12.0, right: 12.0),
                            //padding: EdgeInsets.only(right: 10.0),
                            child: TextField(
                              controller: infoProductController,

                              maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
                              maxLength: 200,

                              textCapitalization: TextCapitalization.sentences,
                              //textAlignVertical: TextAlignVertical.center,
                              readOnly: editMode ? false : true,
                              decoration: InputDecoration(
                                hintText: "Добавьте описание к продукту",
                                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                                contentPadding: editMode ? EdgeInsets.all(10.0) : EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 15.0),
                                counterText: "",
                                filled: true,
                                fillColor: editMode ? Colors.white : myMainColor,

                                // свойства при наведении на инпут
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(radius)),
                                  borderSide: BorderSide(
                                    color: borderColor,
                                  ),
                                ),
                              ),
                              minLines: 1,
                              maxLines: 10,
                            ),
                          ),
                          !editMode ?
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: myMainColor,
                                borderRadius: BorderRadius.all(Radius.circular(7.0),
                                ),
                                border: Border.all(
                                  color: Colors.cyan,
                                ),
                              ),
                              //padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                              child: SizedBox(
                                height: 25,
                                width: 25,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    setState(() {
                                      editMode = true;
                                    });
                                    infoProductController.selection = TextSelection.fromPosition(TextPosition(offset: infoProductController.text.length));
                                  },
                                  icon: Icon(
                                    Icons.edit_outlined,
                                  ),
                                  color: Colors.cyan,
                                ),
                              ),
                            ),
                          )
                              :
                          Text("")
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                Row(
                  //mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: editMode ? MainAxisAlignment.spaceAround : MainAxisAlignment.center,
                  children: [
                    // кнопка назад
                    Flexible(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: myMainColor, // background
                          onPrimary: myDarkBlueColor,
                            // shape: RoundedRectangleBorder(
                            //     borderRadius: BorderRadius.circular(10.0),
                            //     side: BorderSide(color: myDarkBlueColor)
                            // )
                        ),

                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text("Назад", style: TextStyle(fontSize: editMode ? 14 : 16)),
                      ),
                    ),

                    // кнопка сохранения описания
                    editMode ?
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () {
                            //infoProductController.text
                            currentProduct.description = infoProductController.text.trim();
                            setState(() {
                              products[index] = currentProduct;
                              editMode = false;
                            });
                            saveData();

                            //Navigator.of(context).pop();
                          },
                          child: Text("Сохранить", textAlign: TextAlign.center)
                      ),
                    )
                        :
                    Text("")
                  ],
                )
              ],
            );
          });
        });
  }

  bool checkAllDone(List<MyProduct> productList) {
    for(MyProduct product in productList) {
      if (!product.done) {
        return false;
      }
    }
    return true;
  }

  // менюшка продукта
  PopupMenuButton showPopupMenu(List<MyProduct> productList, int index) {
    return PopupMenuButton(
      color: Color(0xffe7fcff),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text("Редактировать"),
        ),
        PopupMenuItem(
            value: 2,
            child: Text("Удалить")
        ),
      ],

      onSelected: (value) {
        switch(value) {
          // редактирование
          case 1:
            editProduct(products, index);
            break;

          // удаление
          case 2:
            sureDeleteProduct(products, index);
            break;
        }
      },
    );
  }
}
