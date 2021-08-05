class MyProduct {
  String productId;
  String name;
  bool done;
  double need;
  String unit;
  double basket;
  String description;

  MyProduct({
    required this.name,
    required this.productId,
    this.done = false,
    this.need = 1,
    this.unit = "шт",
    this.basket = 0,
    this.description = ""
  });

  MyProduct.fromMap(Map map) :
      this.productId = map["id"],
      this.name = map["name"],
      this.done = map["done"],
      this.need = map["need"].toDouble(),
      this.unit = map["unit"],
      this.basket = map["basket"].toDouble(),
      this.description = map["description"]
  ;


  Map toMap() {
    return {
      "id": this.productId,
      "name": this.name,
      "done": this.done,
      "need": this.need,
      "unit": this.unit,
      "basket": this.basket,
      "description": this.description
    };
  }
}