import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'dart:async';
import 'package:show_girl_img/entity/Poster.dart';
import 'package:show_girl_img/ui/PosterList.dart';
import 'package:show_girl_img/constant/ProjectConstant.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  List<Poster> posterList = new List<Poster>();

  Future<List<Poster>> findGroupList() async {
    //查找所有的套图的开头一张图片
    http.Response response =
        await http.get(ProjectConstant.BaseUrl + "/img/findGroupList");
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
      )
    );
  }
}





