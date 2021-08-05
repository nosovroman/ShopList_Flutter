class MyList {
  String listId;
  String name;

  MyList({
    required this.name,
    required this.listId
  });

  MyList.fromMap(Map map) :
        this.listId = map["id"],
        this.name = map["name"]
  ;


  Map toMap() {
    return {
      "id": this.listId,
      "name": this.name
    };
  }
}