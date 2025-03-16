import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/src/features/home/presentation/pages/home_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 3; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  Future<void> _setHasSeenOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          PageView(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: <Widget>[
              // Screen 1: Welcome
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/600x400/00FF00/000000?text=Agriwise+Welcome'), // Replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Welcome to Agriwise',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      },
                      child: Text('Next'),
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              ),
              // Screen 2: What Agriwise Offers
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/600x400/0000FF/FFFFFF?text=Real-time+Insights'), // Replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Real-time insights. Personalized advice.',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            _pageController.nextPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.ease,
                            );
                          },
                          child: Text('Next'),
                        ),
                        SizedBox(width: 20.0),
                        TextButton(
                          onPressed: () {
                            _setHasSeenOnboarding();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          },
                          child: Text(
                            'Skip',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                  ],
                ),
              ),
              // Screen 3: Get Started & Data Collection
              Container(
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Help us personalize your experience.',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(labelText: 'Preferred Language'),
                        items: <String>['English', 'Spanish', 'French']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          // Handle language selection
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Location'),
                        onChanged: (value) {
                          // Handle location input
                        },
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              _setHasSeenOnboarding();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            },
                            child: Text('Continue'),
                          ),
                          SizedBox(width: 20.0),
                          TextButton(
                            onPressed: () {
                              _setHasSeenOnboarding();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => HomePage()),
                              );
                            },
                            child: Text('Skip'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20.0,
            left: 0.0,
            right: 0.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}
