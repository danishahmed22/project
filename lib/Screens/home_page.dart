import 'package:flutter/material.dart';

import '../Widgets/navBar.dart';
import 'constants/background_video.dart';
import 'constants/glassMorphicContainer.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dynamic text data
    String hintText = '香りのいいものを\n寝室に置いてみよう';
    String hintTitle = '今日のヒント';
    String todayText = '今日のアリ';
    List<String> bulletPoints = [
      'アセロラジュース',
      'オーバーなくらい褒める',
      '些細な自己主張',
    ];

    return Scaffold(
      body: Stack(
        children: [
          const BackgroundVideoWidget(),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 30),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        hintTitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      hintText,
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 30),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'もっと詳しく 〉',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  GlassmorphicContainer(
                    child: Container(
                      width: MediaQuery.of(context).size.width ,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              todayText,
                              style: TextStyle(
                                fontSize: 48,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          for (var point in bulletPoints)
                            Text(
                              '• $point',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add the CustomNavBar at the bottom
          Positioned(
            bottom: 18, // Aligns the navbar at the bottom
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomNavBar(),
            ),
          ),
        ],
      ),
    );
  }
}

