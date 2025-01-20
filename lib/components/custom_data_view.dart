import 'dart:convert';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fala/components/area_chart_view.dart';
import 'package:fala/mode/custom_data_entity.dart';
import 'package:flutter/material.dart';

class CustomDataView extends StatelessWidget {
  final Uint8List? data;
  const CustomDataView(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    bool isError = false;
    CustomDataEntity? entity;
    if (data == null) {
      isError = true;
    } else {
      try {
        entity = CustomDataEntity.fromJson(jsonDecode(utf8.decode(data!)));
      } catch (err) {
        isError = true;
      }
    }
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isError ? Colors.red : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            color: isDarkMode(context) ? Colors.black : Colors.white
        ),
        padding: EdgeInsets.all(5),
        child: isError
            ? Center(
            child: Text("数据格式错误", style: TextStyle(color: Colors.red)))
            : Row(
          children: [
            if(entity?.data?.isEmpty != true)
              Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 15,
                      children: entity!.data!.sublist(0, 2).map((data) =>
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data.title!,
                                  style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)
                              ),
                              Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: AutoSizeText(data.value!,
                                    style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black, fontWeight: FontWeight.bold))
                              )
                            ],
                          )).toList(),
                    ),
                  )
              ),
            Expanded(
                child: AreaChartView(entity!.chart!, hint: entity.chartHint)
            ),
          ],
        ),
      ),
    );
  }

  bool isDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }
}