import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Poster> posterList = new List<Poster>();

//  List<Poster> posterList = new List<Poster>.generate(20, (i)=>new Poster("title:$i","url$i"));
  Future<List<Poster>> findGroupList() async {
    http.Response response =
        await http.get("http://192.168.43.130:8080/img/findGroupList");
    print(response);
    List list = JSON.jsonDecode(response.body);

    for (int i = 0; i < list.length; i++) {
      Poster poster = Poster.fromJson(list[i]);
      posterList.add(poster);
    }
    return posterList;
  }

  @override
  Widget build(BuildContext context) {
    findGroupList();
    return MaterialApp(
        title: 'Flutter Demo',
        home: Scaffold(
            body: new FutureBuilder<List<Poster>>(
          future: findGroupList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return new PosterList(
//                    group:posterList[0].imgGroup,
                  items: posterList);
            } else {
              return new CircularProgressIndicator();
            }
          },
        )
            // body:new PosterShow(
            //   store: 1,
            // )
            ));
  }
}

class PosterList extends StatelessWidget {
  final List<Poster> items;

//  final String group;

  PosterList({Key key, @required this.items /*,@required this.group*/
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10.0,
          // mainAxisSpacing: 10.0,//Y
          crossAxisSpacing: 7.0, //X
          childAspectRatio: 0.7),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return new GestureDetector(
          child: Image.network(items[index].url),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return new PosterShow(
                group: this.items[index].imgGroup,
                store: 0,
              );
            }));
          },
        );
      },
    );
  }
}

class PosterShow extends StatelessWidget {
  final int store;
  final String group;
  List<Poster> posterList = null;

  PosterShow(
      {Key key, @required this.store, @required this.group, this.posterList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screen = ScreenUtil.getInstance();
    return MaterialApp(
      home: Scaffold(
          body: new GestureDetector(
              child: new FutureBuilder(
                  future: findByGroup(this.group),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (this.store >= posterList.length) {
                        return Container(
                          width: screen.width/1,
                          height: screen.height+0.0,
                          child: Text(
                            "最后一张啦\n点击返回上一张",
                            style: TextStyle(fontSize: 40.0),
                            textAlign: TextAlign.center,
                          ),
                          alignment: Alignment.center,
                        );
                      }
                      return new Image.network(posterList[store].url);
                    } else {
                      return new CircularProgressIndicator();
                    }
                  }),
              onHorizontalDragEnd: (endDetails) async {
                if ((endDetails.velocity.pixelsPerSecond.dx -
                        endDetails.velocity.pixelsPerSecond.dy <
                    0)) {
//              http.Response response = await http.get("https://www.baidu.com");
//              print(response.body);
                  print("左");
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return new PosterShow(
                        group: this.posterList[0].imgGroup,
                        store: this.store + 1,
                        posterList: this.posterList);
                  }));
                } else {
                  print("右");
                  Navigator.pop(context);
                }
              })),
    );
  }

  Future<List<Poster>> findByGroup(String group) async {
    http.Response response = await http
        .get("http://192.168.43.130:8080/img/findByGroup?group=" + group);
    print(response);
    List list = JSON.jsonDecode(response.body);
    posterList = new List<Poster>();
    for (int i = 0; i < list.length; i++) {
      Poster poster = Poster.fromJson(list[i]);
      posterList.add(poster);
    }
    return posterList;
  }
}

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
