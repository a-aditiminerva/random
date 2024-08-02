import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MainPage(),
      theme: ThemeData.dark(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const PlaceholderWidget(color: Colors.red),
    const PlaceholderWidget(color: Colors.green),
    const PlaceholderWidget(color: Colors.blue),
    const NearbyThingsPage(),
    const PlaceholderWidget(color: Colors.yellow),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '',
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

class NearbyThingsPage extends StatefulWidget {
  const NearbyThingsPage({Key? key}) : super(key: key);

  @override
  _NearbyThingsPageState createState() => _NearbyThingsPageState();
}

class _NearbyThingsPageState extends State<NearbyThingsPage> {
  int _currentCategoryIndex = 0;
  final List<String> _categories = ['Categories', 'Pharmacy', 'Food Order', 'Laptop Mechanic'];
  final List<List<String>> _items = [
    List.generate(20, (index) => 'Categories ${index + 1}'),
    List.generate(20, (index) => 'Pharmacy Item ${index + 1}'),
    List.generate(20, (index) => 'Food Order Item ${index + 1}'),
    List.generate(20, (index) => 'Laptop Mechanic Item ${index + 1}')
  ];

  void _nextCategory() {
    setState(() {
      _currentCategoryIndex = (_currentCategoryIndex + 1) % _categories.length;
    });
  }

  void _previousCategory() {
    setState(() {
      _currentCategoryIndex =
          (_currentCategoryIndex - 1 + _categories.length) % _categories.length;
    });
  }

  Future<void> _launchCaller() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '1234567890');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make a call.')),
      );
    }
  }

  Future<void> _launchMaps() async {
    final Uri mapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=1600+Amphitheatre+Parkway,+Mountain+View,+CA');
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps.')),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final height = mediaQuery.size.height;
    final width = mediaQuery.size.width;
    final padding = mediaQuery.padding;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Nearby Things',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(
                vertical: padding.top * 0.5, horizontal: width * 0.05),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: _previousCategory,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _categories[_currentCategoryIndex],
                    style: TextStyle(
                        color: Colors.white, fontSize: height * 0.025),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                    onPressed: _nextCategory,
                  ),
                ],
              ),
            ),
          ),
          SliverGrid(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: width * 0.4, // Adjusted width for smaller items
                  height: height * 0.2, // Adjusted height for smaller items
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            _items[_currentCategoryIndex][index],
                            style: const TextStyle(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.phone, color: Colors.white),
                            onPressed: _launchCaller,
                          ),
                          const SizedBox(width: 20),
                          IconButton(
                            icon: const Icon(Icons.location_on, color: Colors.white),
                            onPressed: _launchMaps,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                );
              },
              childCount: _items[_currentCategoryIndex].length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: height * 0.02,
              crossAxisSpacing: width * 0.05,
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  const PlaceholderWidget({Key? key, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
