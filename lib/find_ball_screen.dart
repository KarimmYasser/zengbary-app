import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax/iconsax.dart';
import 'package:zengbary/http_client.dart';
import 'package:zengbary/setting_screen.dart';

import 'custom_drawer.dart';
import 'home_screen.dart';

class FindBallScreen extends StatefulWidget {
  const FindBallScreen({super.key});

  @override
  State<FindBallScreen> createState() => _FindBallScreenState();
}

class _FindBallScreenState extends State<FindBallScreen> {
  // Replace single isLoading with specific loading states
  bool isStartLoading = false;
  bool isStopLoading = false;
  bool isSendLoading = false;
  String baseUrl = 'http://192.168.1.16:5000'; // Default API URL
  int selectedNumber = 1; // Default selected number

  // Start server function
  Future<void> _handleStartServer() async {
    setState(() {
      isStartLoading = true;
    });

    try {
      final response = await HttpHelper.get("changeGame?game=cups");
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response)));
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error starting server: $error')));
    } finally {
      setState(() {
        isStartLoading = false;
      });
    }
  }

  // Stop server function
  Future<void> _handleStopServer() async {
    setState(() {
      isStopLoading = true;
    });

    try {
      final response = await HttpHelper.get("changeGame?game=idle");
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(response)));
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error stopping server: $error')));
    } finally {
      setState(() {
        isStopLoading = false;
      });
    }
  }

  void _updateBaseUrl(String value) {
    setState(() {
      baseUrl = value; // Update the baseUrl
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  // Send number function
  Future<void> _handleSendNumber() async {
    setState(() {
      isSendLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/cups/start?num_colors=$selectedNumber'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Number of colors sent successfully')),
        );
      } else {
        throw Exception(response.statusCode);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error sending number: $error')));
    } finally {
      setState(() {
        isSendLoading = false;
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
          'Find the Ball',
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
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: IconButton(
              icon: Icon(Iconsax.setting, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CupertinoButton(
                      onPressed: isStartLoading ? null : _handleStartServer,
                      color: Colors.white,
                      disabledColor: Colors.grey[400]!,
                      child:
                          isStartLoading
                              ? CupertinoActivityIndicator(color: Colors.black)
                              : Text(
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
                      onPressed: isStopLoading ? null : _handleStopServer,
                      color: Colors.redAccent,
                      disabledColor: Colors.redAccent.withAlpha(128),
                      child:
                          isStopLoading
                              ? CupertinoActivityIndicator()
                              : Text(
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
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: 'Enter Shell game server Base URL',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        onChanged: _updateBaseUrl,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Select Cup Number',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              if (selectedNumber > 1) {
                                setState(() {
                                  selectedNumber--;
                                });
                              }
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              selectedNumber.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Urbanist',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add_circle, color: Colors.white),
                            onPressed: () {
                              if (selectedNumber < 3) {
                                setState(() {
                                  selectedNumber++;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      CupertinoButton(
                        onPressed: isSendLoading ? null : _handleSendNumber,
                        color: Colors.green,
                        disabledColor: Colors.green.withAlpha(128),
                        child:
                            isSendLoading
                                ? CupertinoActivityIndicator()
                                : Text(
                                  'Send Cup Number',
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
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
