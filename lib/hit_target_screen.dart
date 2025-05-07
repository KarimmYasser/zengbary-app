import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import 'custom_drawer.dart';
import 'home_screen.dart';

class HitTargetScreen extends StatefulWidget {
  const HitTargetScreen({super.key});

  @override
  _HitTargetScreenState createState() => _HitTargetScreenState();
}

class _HitTargetScreenState extends State<HitTargetScreen> {
  bool redSelected = false;
  bool yellowSelected = false;
  bool blueSelected = false;
  bool error = false;
  String baseUrl = 'https://example.com';

  void _updateBaseUrl(String value) {
    baseUrl = value; // Update the baseUrl
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Base URL updated successfully!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Hit Target',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: IconButton(
              icon: Icon(Iconsax.home, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ),
        ],
      ),
      drawer: CustomDrawer(),
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF232323)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          // Add scrolling capability
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: () {},
                      color: Colors.white,
                      child: Text(
                        'Activate',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    CupertinoButton(
                      onPressed: () {},
                      color: Colors.redAccent,
                      child: Text(
                        'Stop',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: 'Enter Target game server Base URL',
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  onSubmitted: _updateBaseUrl,
                ),
                SizedBox(height: 20),
                Text(
                  'Select a Color to Shoot:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          redSelected = !redSelected;
                          blueSelected = false;
                          yellowSelected = false;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          border: Border.all(
                            color:
                                redSelected
                                    ? Colors.purple
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (redSelected)
                                  Icon(
                                    Iconsax.tick_circle5,
                                    color: Colors.purple,
                                    size: 15,
                                  ),
                                SizedBox(width: 12, height: 15),
                              ],
                            ),
                            Icon(
                              Iconsax.book_square1,
                              color: Colors.red,
                              size: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Red',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          redSelected = false;
                          blueSelected = !blueSelected;
                          yellowSelected = false;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          border: Border.all(
                            color:
                                blueSelected
                                    ? Colors.purple
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (blueSelected)
                                  Icon(
                                    Iconsax.tick_circle5,
                                    color: Colors.purple,
                                    size: 15,
                                  ),
                                SizedBox(width: 12, height: 15),
                              ],
                            ),
                            Icon(
                              Iconsax.book_square1,
                              color: Colors.indigo,
                              size: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Blue',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          redSelected = false;
                          blueSelected = false;
                          yellowSelected = !yellowSelected;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          border: Border.all(
                            color:
                                yellowSelected
                                    ? Colors.purple
                                    : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (yellowSelected)
                                  Icon(
                                    Iconsax.tick_circle5,
                                    color: Colors.purple,
                                    size: 15,
                                  ),
                                SizedBox(width: 12, height: 15),
                              ],
                            ),
                            Icon(
                              Iconsax.book_square1,
                              color: Colors.amber,
                              size: 50,
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Yellow',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 5),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CupertinoButton(
                    onPressed: () {
                      if (yellowSelected || redSelected || blueSelected) {
                        error = false;
                      } else {
                        error = true;
                      }
                      setState(() {
                        redSelected = false;
                        blueSelected = false;
                        yellowSelected = false;
                      });
                    },
                    minSize: 100,
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red,
                    child: Text(
                      'Shoot',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (error)
                  Text(
                    'Please select a color to shoot first',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
