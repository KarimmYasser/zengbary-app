import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zengbary/http_client.dart';
import 'package:zengbary/setting_screen.dart';

import 'custom_drawer.dart';
import 'home_screen.dart';

class TictactoeScreen extends StatefulWidget {
  const TictactoeScreen({super.key});

  @override
  State<TictactoeScreen> createState() => _TictactoeScreenState();
}

class _TictactoeScreenState extends State<TictactoeScreen> {
  // Replace single isLoading with specific loading states
  bool isStartLoading = false;
  bool isStopLoading = false;
  String selectedTurn = 'xoX'; // Default to X turn
  String baseUrl = 'http://192.168.1.16:5000'; // Default API URL

  // Start server function
  Future<void> _handleStartServer() async {
    setState(() {
      isStartLoading = true;
    });

    try {
      final response = await HttpHelper.get("changeGame?game=$selectedTurn");
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Tic Tac Toe',
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
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[850],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Select Your Turn',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Urbanist',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // X Turn Option
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTurn = 'xoX';
                                });
                              },
                              child: Container(
                                height: 120, // Fixed height
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      selectedTurn == 'xoX'
                                          ? Colors.red
                                          : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        selectedTurn == 'xoX'
                                            ? Colors.white
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'X',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'You play first',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          // O Turn Option
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTurn = 'xoO';
                                });
                              },
                              child: Container(
                                height: 120, // Fixed height
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color:
                                      selectedTurn == 'xoO'
                                          ? Colors.blue
                                          : Colors.grey[800],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color:
                                        selectedTurn == 'xoO'
                                            ? Colors.white
                                            : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'O',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Robot plays first',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        onPressed: isStartLoading ? null : _handleStartServer,
                        color: Colors.white,
                        disabledColor: Colors.grey[400]!,
                        child:
                            isStartLoading
                                ? CupertinoActivityIndicator(
                                  color: Colors.black,
                                )
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
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: CupertinoButton(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
