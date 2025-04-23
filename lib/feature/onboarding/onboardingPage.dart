import 'package:drivex/constants/localVariables.dart';
import 'package:flutter/material.dart';


class PageViewFoodApp extends StatefulWidget {
  @override
  _PageViewFoodAppState createState() => _PageViewFoodAppState();
}

class _PageViewFoodAppState extends State<PageViewFoodApp> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": 'Welcome to food world',
      "description": 'The right place to get that quick bite and at your comfort',
      "image": 'assets/image1/food_world.jpg',
    },
    {
      'title': 'Choose your food',
      'description': 'Easily find your type of food craving and you will get delivery in wide range',
      'image': 'assets/image1/food_choose.jpg',
    },
    {
      'title': 'Fast Delivery',
      'description': 'We provide fastest delivery system,We will reach your home within 30 minutes',
      'image': 'assets/image1/food_deliveryyy.avif',
    },

  ];

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(

      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Image.asset(onboardingData[index]['image']!),
                  SizedBox(height: 20),
                  Text(
                    onboardingData[index]['title']!,
                    style: TextStyle(fontSize:width*0.1, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    onboardingData[index]['description']!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: width*0.05),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: width*0.1,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      onboardingData.length - 1,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: Text('Skip'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => Container(
                      height: 10,
                      width: 10,
                      margin: EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: _currentIndex == index ? Colors.black : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (_currentIndex == onboardingData.length - 1) {
                      // Navigate to the main screen
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainScreen()));
                    } else {
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    }
                  },
                  child: Text(_currentIndex == onboardingData.length - 1 ? 'Done' : 'Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
