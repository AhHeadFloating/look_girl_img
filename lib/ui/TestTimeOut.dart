import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:show_girl_img/constant/ProjectConstant.dart';
import 'dart:convert' as JSON;

class TestTimeOut extends StatelessWidget {

  TextEditingController activationController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text("试用时间到期，请输入激活码继续使用"),
          ),
          body: new Column(
            children: <Widget>[
              new TextField(
                controller: activationController,
              ),
              new RaisedButton(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: new RaisedButton(
                        onPressed: () async {
                          DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
                          AndroidDeviceInfo androidInfo1 =
                              await deviceInfo.androidInfo;
                          var device = androidInfo1.device;
                          print(device);
                          var text = activationController.text;
                          print(text);
                          http.Response response = await http.get(
                              ProjectConstant.BaseUrl + "/project/activation?deviceId=" + device+"&activationNo="+text);
                          Map<String,Object> jsonDecode = JSON.jsonDecode(response.body);
                          String alertStr = "";
                          if(jsonDecode["status"] == "success"){
                            alertStr = "激活完成";
                          }else{
                            alertStr = "激活失败";
                          }
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(alertStr),
                              ));

                        },
                        color: Colors.blue,
                        child: new Text("确认激活"),
                      ),
                    )
                  ],
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  ClipboardData data = new ClipboardData(text: "");
                  Clipboard.setData(data);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text('复制完成'),
                          ));
                },
                color: Colors.blue,
                child: new Text("点击复制购买激活码链接"),
              ),
            ],
          )),
    );
  }
}
