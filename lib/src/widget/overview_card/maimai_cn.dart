import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class MaimaiCn extends StatelessWidget {
  const MaimaiCn({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      0.0,
      7.0,
      13.0,
      2.0,
      0.0,
      0.0,
      0.0,
      4.0,
      20.0,
      9.0,
      1.0,
      5.0,
      2.0,
      0.0,
      0.0,
      0.0,
      0.0,
      7.0,
      10.0,
      3.0
    ];
    return Card(
      margin: const EdgeInsets.only(left: 32, right: 32, top: 16, bottom: 16),
      child: Container(
          height: 200,
          width: double.infinity,
          child: Stack(
            children: [
              // 背景图片
              Container(
                decoration: BoxDecoration(
                  image: const DecorationImage(
                    image: AssetImage('assets/images/maimai_bud.jpg'), // 替换为你的图片路径
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              // 渐变层
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(1), // 从黑色开始
                      Colors.black.withOpacity(0.7), // 到透明
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('QIANMO',
                                style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 4,
                                    fontFamily:
                                        "monospace")), // Adds a title to the card
                            Spacer(),
                            Expanded(
                                child: Chip(
                              side: BorderSide(width: 0),
                              label: Text('十段', style: TextStyle(color: Colors.white)),
                              backgroundColor:
                                  Color.fromARGB(255, 190, 108, 14),
                            )),
                            Expanded(
                                child: Chip(
                              side: BorderSide(width: 0),
                              label: Text('B3', style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 17, 148, 67),
                            ))
                          ],
                        ),
                        Text('舞萌 DX 2024',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    "monospace")) // Adds a subtitle to the card
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('DX\nRating',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        const SizedBox(width: 4),
                        const Text('14459',
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 205, 222, 17))),
                        const Spacer(),
                        Sparkline(
                          fallbackHeight: 30,
                          fallbackWidth: 150,
                          data: data,
                          lineWidth: 2.0,
                          lineGradient: const LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromARGB(255, 186, 87, 247),
                              Color.fromARGB(255, 200, 140, 209)
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
