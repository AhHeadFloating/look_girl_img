import 'package:flutter/material.dart';
import 'package:show_girl_img/constant/ProjectConstant.dart';
import 'package:show_girl_img/ui/PosterShow.dart';
import 'package:device_info/device_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;



class PosterDetail extends StatefulWidget {

  int testState;
  String group;
  int store=0;

  PosterDetail({Key key,@required this.testState,@required this.group}):super(key:key);

  @override
  _PosterDetailState createState() {
    return _PosterDetailState();
  }
}

class _PosterDetailState extends State<PosterDetail>{

  @override
  void initState() {
    super.initState();
    sendDeviceId();
  }

  @override
  Widget build(BuildContext context) {

    if(widget.testState == null){
      return new CircularProgressIndicator();
    }else if(widget.testState == 1){
      return TextField();
    }else if(widget.testState == 0 || widget.testState == 2){
       return PosterShow(
        store:widget.store,
        group: widget.group,
      );
    }
  }

  Future<Map<String, Object>> sendDeviceId() async {
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo1 = await deviceInfo.androidInfo;
    var device = androidInfo1.device;
    http.Response response = await http.get(
        ProjectConstant.BaseUrl + "/project/updateDevice?deviceId=" + device);
    Map<String, Object> map = JSON.jsonDecode(response.body);
    int state = 0;
    if (map["state"] == 0) {
      print("体验中");
      state = 0;
    } else if (map["state"] == 1) {
      print("体验结束");
      state = 1;
    } else if (map["state"] == 2) {
      print("已经开通会员");
      state = 2;
    }
    setState(() {
      widget.testState = state;
    });
    print(deviceInfo);
    return map;
  }
}