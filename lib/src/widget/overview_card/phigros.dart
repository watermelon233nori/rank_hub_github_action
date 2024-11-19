import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class Phigros extends StatelessWidget {
  const Phigros({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      12.76,
      12.83,
      12.87,
      12.96,
      13.01,
      13.02,
      13.02,
      13.02,
      13.04,
      13.10,
      13.12,
      13.27,
      13.38,
      13.39,
      13.41,
      13.76,
      14.82,
      13.88,
      13.92,
      13.84
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
                    image:
                        AssetImage('assets/images/phigros.png'), // 替换为你的图片路径
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
                            Text('千沫qianmo',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), // Adds a title to the card
                            Spacer(),
                            Expanded(
                                child: Chip(
                              side: BorderSide(width: 0),
                              label: Text('40', style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 208, 75, 38),
                            )),
                          ],
                        ),
                        Text('Phigros',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    "monospace")) // Adds a subtitle to the card
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('RKS',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        const SizedBox(width: 4),
                        const Text('13.84',
                            style:
                                TextStyle(fontSize: 24, color: Colors.white)),
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
