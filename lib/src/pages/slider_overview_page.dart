import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSliderPage extends StatefulWidget {
  @override
  _ImageSliderPageState createState() => _ImageSliderPageState();
}

class _ImageSliderPageState extends State<ImageSliderPage> {
  final PageController _controller = PageController();
  final List<Map<String, String>> images = [
    {
      'image': 'assets/images/maimai_bud.jpg',
      'title': 'Q I A N M O',
      'subtitle': 'Subtitle for Image 1',
    },
    {
      'image': 'assets/images/chuni_lmn.png',
      'title': 'Title 2',
      'subtitle': 'Subtitle for Image 2',
    },
    {
      'image': 'https://via.placeholder.com/800x600.png?text=Image+3',
      'title': 'Title 3',
      'subtitle': 'Subtitle for Image 3',
    },
    {
      'image': 'https://via.placeholder.com/800x600.png?text=Image+4',
      'title': 'Title 4',
      'subtitle': 'Subtitle for Image 4',
    },
    {
      'image': 'https://via.placeholder.com/800x600.png?text=Image+5',
      'title': 'Title 5',
      'subtitle': 'Subtitle for Image 5',
    },
    {
      'image': 'https://via.placeholder.com/800x600.png?text=Image+6',
      'title': 'Title 6',
      'subtitle': 'Subtitle for Image 6',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 图片滑动
          PageView.builder(
            controller: _controller,
            itemCount: images.length,
            itemBuilder: (context, index) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  // 背景图片
                  Image.asset(
                    images[index]['image']!,
                    fit: BoxFit.cover,
                  ),
                  // 遮罩层
                  Container(
                    color: Colors.black.withOpacity(0.4),
                  ),
                  // 标题和副标题
                  Positioned(
                    bottom: 72,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PlayerProfile(
                          name: "ＱＩＡＮＭＯ",
                          rating: 14469,
                          iconUrl:
                              "https://assets2.lxns.net/maimai/icon/355501.png",
                          courseRankUrl:
                              "https://maimai.lxns.net/assets/maimai/course_rank/7.webp",
                          classRankUrl:
                              "https://maimai.lxns.net/assets/maimai/class_rank/1.webp",
                          star: 254,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          // 指示器
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: images.length,
                effect: ExpandingDotsEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.white,
                  dotColor: Colors.white54,
                ),
                onDotClicked: (index) {
                  _controller.animateToPage(
                    index,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerProfile extends StatelessWidget {
  final String name;
  final int rating;
  final String iconUrl;
  final String courseRankUrl;
  final String classRankUrl;
  final int star;

  const PlayerProfile({
    Key? key,
    required this.name,
    required this.rating,
    required this.iconUrl,
    required this.courseRankUrl,
    required this.classRankUrl,
    required this.star,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // 头像
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              iconUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          // 文本部分
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UNKNOWN 和 DX RATING 行
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 名字
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Text(
                        "DX RATING: $rating",
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // 图标行
                Row(
                  children: [
                    // Course Rank 图标
                    Image.network(
                      courseRankUrl,
                      width: 60,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 4),
                    // Class Rank 图标
                    Image.network(
                      classRankUrl,
                      width: 60,
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 12),
                    // 星星
                    Row(
                      children: [
                        Image.network(
                          "https://maimai.lxns.net/assets/maimai/icon_star.webp",
                          width: 20,
                          height: 20,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "×$star",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
