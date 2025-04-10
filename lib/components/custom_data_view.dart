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
    bool hasChart = entity?.chart?.isNotEmpty == true;
    int dataCount = entity?.data?.length ?? 0;
    if(hasChart) {
      dataCount = dataCount > 2 ? 2 : dataCount;
    }

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              color: isError ? Colors.red : Colors.transparent),
          borderRadius: BorderRadius.circular(10),
          // 272729
          color: isDarkMode(context) ? Color(0xFF28282A) : Colors.white
      ),
      padding: EdgeInsets.all(5),
      child: isError
          ? Center(
          child: Text("数据格式错误", style: TextStyle(color: Colors.red)))
          : Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: [
            if(entity?.data?.isNotEmpty == true)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 10.0,
                      childAspectRatio: returnChildAspectRatio(hasChart),
                    ),
                    itemCount: dataCount,
                    itemBuilder: (context, index) => Column( // 一个小格子
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(// 标题副标题
                          children: [
                            Expanded(child: Text(entity!.data![index].title!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: mainColor,fontSize: 14, fontWeight: FontWeight.bold)
                            )),
                            if(entity.data![index].subTitle?.isNotEmpty == true)
                              Expanded(child: AutoSizeText(entity.data![index].subTitle!,
                                style: TextStyle(color: Colors.grey,fontSize: 12, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 6,
                                maxLines: 1,
                                softWrap: false,
                              ))
                          ],
                        ),
                        Expanded(  // 值
                          child: Container(
                            constraints: BoxConstraints(
                                minHeight: double.infinity
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 15, right: 5),
                              constraints: BoxConstraints(
                                  minWidth: double.infinity
                              ),
                              alignment: Alignment.centerRight,
                              child: AutoSizeText(entity.data![index].value!,
                                style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black, fontWeight: FontWeight.w900, fontSize: 20),
                                maxLines: 1,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            if(hasChart)
              Expanded(
                  flex: 3,
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

double returnChildAspectRatio(bool hasChart) {
  return hasChart ? 0.55 : 0.425;
}
