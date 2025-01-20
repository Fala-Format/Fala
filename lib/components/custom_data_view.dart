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
            if(entity?.data?.isNotEmpty == true)
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(left: 15),
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 0.0,
                        mainAxisSpacing: 5.0,
                        childAspectRatio: 0.33,
                      ),
                      itemCount: dataCount,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(entity!.data![index].title!,
                                style: TextStyle(color: mainColor, fontWeight: FontWeight.bold)
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 20),
                                child: AutoSizeText(entity.data![index].value!,
                                    style: TextStyle(color: isDarkMode(context) ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                )
                            )
                          ],
                        );
                      },
                    )
                  ),
              ),
            Expanded(
                flex: hasChart ? 1 : 0,
                child: hasChart ? AreaChartView(entity!.chart!, hint: entity.chartHint) : SizedBox()
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