import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';

class ChuniCn extends StatelessWidget {
  const ChuniCn({super.key});

  @override
  Widget build(BuildContext context) {
    var data = [
      14.76,
      14.83,
      14.87,
      14.96,
      14.95,
      14.94,
      14.96,
      14.98,
      15.00,
      15.01,
      15.74,
      15.77,
      15.79,
      15.82,
      15.89,
      16.13,
      16.15,
      16.16,
      16.20,
      16.33
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
                        AssetImage('assets/images/chuni_lmn.png'), // 替换为你的图片路径
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
                                    letterSpacing: 4,
                                    color: Colors.white,
                                    fontFamily:
                                        "monospace")), // Adds a title to the card
                            Spacer(),
                            Expanded(
                                child: Chip(
                              side: BorderSide(width: 0),
                              label: Text('Max 16.33', style: TextStyle(color: Colors.white)),
                              backgroundColor: Color.fromARGB(255, 60, 84, 239),
                            )),
                          ],
                        ),
                        Text('中二节奏 2025',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    "monospace")) // Adds a subtitle to the card
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('RATING',
                            style:
                                TextStyle(fontSize: 12, color: Colors.white)),
                        const SizedBox(width: 4),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              colors: <Color>[
                                Color.fromARGB(255, 93, 255, 104),
                                Color.fromARGB(255, 255, 138, 70),
                                Color.fromARGB(255, 244, 92, 255)
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ).createShader(bounds);
                          },
                          child: const Text(
                            '16.33',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.white, // 设置文字颜色为白色，用于渐变效果
                            ),
                          ),
                        ),
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
