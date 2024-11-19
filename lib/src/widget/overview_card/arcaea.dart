import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class Arcaea extends StatelessWidget {
  const Arcaea({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      10.76,
      10.83,
      10.87,
      10.96,
      10.95,
      10.94,
      10.96,
      10.98,
      11.00,
      11.01,
      11.02,
      11.05,
      11.08,
      11.07,
      11.09,
      11.13,
      11.15,
      11.16,
      11.20,
      11.23
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
                    image: AssetImage('assets/images/arcaea.jpg'), // 替换为你的图片路径
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
                            Text('qianmo2233',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), // Adds a title to the card
                            Spacer(),
                            Expanded(
                                child: Chip(
                              side: BorderSide(width: 0),
                              label: Text('Max 11.26', style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 253, 40, 40),
                            )),
                          ],
                        ),
                        Text('Arcaea',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    "monospace")) // Adds a subtitle to the card
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('PTT',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        const SizedBox(width: 4),
                        const Text('11.23',
                            style: TextStyle(
                                fontSize: 24,
                                color: Color.fromARGB(255, 183, 46, 46))),
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
