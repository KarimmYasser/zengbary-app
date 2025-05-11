import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zengbary/http_client.dart';
import 'package:zengbary/setting_screen.dart';

import 'custom_drawer.dart';
import 'home_screen.dart';

class RubikSolverScreen extends StatefulWidget {
  const RubikSolverScreen({super.key});

  @override
  State<RubikSolverScreen> createState() => _RubikSolverScreenState();
}

class _RubikSolverScreenState extends State<RubikSolverScreen> {
  // Replace single isLoading with specific loading states
  bool isStartLoading = false;
  bool isStopLoading = false;

  // Start server function
  Future<void> _handleStartServer() async {
    setState(() {
      isStartLoading = true;
    });

    try {
      final response = await HttpHelper.get("changeGame?game=rubik");
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
          'Rubik\'s Cube Solver',
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
