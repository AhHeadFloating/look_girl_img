class Poster {
  String title;
  String url;
  String imgGroup;

  Poster({this.title, this.url, this.imgGroup});

  Poster.fromJson(Map<String, dynamic> json) {
    this.url = json["imgUrl"];
    this.imgGroup = json["imgGroup"];
  }
}