import 'package:dio/dio.dart';
import 'package:fala/components/haptic_feedback_button.dart';
import 'package:fala/mode/store.dart';
import 'package:fala/views/home.dart';
import 'package:flutter/material.dart';

class InitializationView extends StatefulWidget {
  const InitializationView({super.key});

  @override
  State<StatefulWidget> createState() => _InitializationState();

}

class _InitializationState extends State<InitializationView> {

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_){
      Store.sharedPreferencesAsync.getBool("firstLaunch").then((firstLaunch) {
        if(firstLaunch != false) {
          Store.sharedPreferencesAsync.setBool("firstLaunch", false);
          firstLaunchCheck();
        } else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView()));
        }
      });
    });
    super.initState();
  }

  void firstLaunchCheck() {
    Dio().get("https://www.apple.com").then((res){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeView()));
    })
    .onError((e,t) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("网络权限请求"),
            content: Text("应用需要网络访问才能继续，请允许网络访问或检查网络设置。"),
            actions: [
              HapticFeedbackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  firstLaunchCheck();
                },
                child: Text("重试"),
              )
            ],
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/logo.png", scale: 3),
              Text("the world of subscriptions, is easy to use!", style: TextStyle(fontSize: 18)),
              SizedBox(height: 150)
            ],
          ),
        ),
      ),
    );
  }

}