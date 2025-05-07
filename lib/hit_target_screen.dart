import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  String baseUrl = 'http://localhost:5000'; // Default API URL
  String serverStatus = 'stopped'; // Initial server status
  bool isLoading = false; // Loading state for API calls

  void _updateBaseUrl(String value) {
    setState(() {
      baseUrl = value; // Update the baseUrl
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Base URL updated successfully!')));
  }

  // Start server function
  Future<void> _handleStartServer() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/start'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serverStatus = data['status'] ?? 'unknown';
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Server started successfully')));
      } else {
        throw Exception('Failed to start server');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error starting server: $error')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Stop server function
  Future<void> _handleStopServer() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/stop'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serverStatus = data['status'] ?? 'unknown';
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Server stopped successfully')));
      } else {
        throw Exception('Failed to stop server');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error stopping server: $error')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fire color function
  Future<void> _handleFireColor(String color) async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/color'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'color': color}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          serverStatus = data['status'] ?? 'unknown';
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Color $color fired successfully')),
        );
      } else {
        throw Exception('Failed to fire color');
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error firing color: $error')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Server Status Display
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Server Status: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        serverStatus,
                        style: TextStyle(
                          color:
                              serverStatus == 'running'
                                  ? Colors.green
                                  : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: isLoading ? null : _handleStartServer,
                      color: Colors.white,
                      disabledColor: Colors.grey[400]!,
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
                      onPressed: isLoading ? null : _handleStopServer,
                      color: Colors.redAccent,
                      disabledColor: Colors.redAccent.withAlpha(128),
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
                    border: Border.all(
                      color: isLoading ? Colors.grey : Colors.white,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CupertinoButton(
                    onPressed:
                        isLoading
                            ? null
                            : () {
                              if (redSelected) {
                                _handleFireColor('red');
                                error = false;
                              } else if (blueSelected) {
                                _handleFireColor('blue');
                                error = false;
                              } else if (yellowSelected) {
                                _handleFireColor('yellow');
                                error = false;
                              } else {
                                setState(() {
                                  error = true;
                                });
                                return;
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
                    disabledColor: Colors.red.withAlpha(128),
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
