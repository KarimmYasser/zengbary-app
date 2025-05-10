import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dio/dio.dart';

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
  String baseUrl = 'http://192.168.1.16:5000'; // Default API URL
  String serverStatus = 'stopped'; // Initial server status
  late Dio dio; // Dio instance

  // Replace single isLoading with specific loading states
  bool isStartLoading = false;
  bool isStopLoading = false;
  bool isShootLoading = false;

  @override
  void initState() {
    super.initState();
    _initDio();
  }

  void _initDio() {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 7),
        receiveTimeout: const Duration(seconds: 7),
        sendTimeout: const Duration(seconds: 7),
      ),
    );
  }

  void _updateBaseUrl(String value) {
    setState(() {
      baseUrl = value; // Update the baseUrl
      _initDio(); // Reinitialize Dio with new baseUrl
    });
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  // Utility method to extract meaningful error messages from Dio errors
  String _handleDioError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timed out. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again later.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Server is taking too long to respond.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final responseData = error.response?.data;
          if (responseData is Map && responseData.containsKey('message')) {
            return 'Server error (${statusCode}): ${responseData['message']}';
          }
          return 'Server error (${statusCode}): ${error.response?.statusMessage}';
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.badCertificate:
          return 'Bad certificate. Please check server configuration.';
        case DioExceptionType.unknown:
          if (error.message?.contains('SocketException') ?? false) {
            return 'Cannot connect to server. Please check server availability.';
          }
          return 'An unexpected error occurred: ${error.message}';
      }
    }
    return error.toString();
  }

  // Show error message with SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Colors.red[200],
        duration: Duration(seconds: 7),
      ),
    );
  }

  // Start server function
  Future<void> _handleStartServer() async {
    setState(() {
      isStartLoading = true;
    });

    try {
      final response = await dio.post(
        '/start',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          serverStatus = data['status'] ?? 'unknown';
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server started successfully'),
            duration: Duration(seconds: 7),
          ),
        );
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/start'),
          response: response,
        );
      }
    } catch (error) {
      final errorMessage = _handleDioError(error);
      _showErrorSnackBar('Error starting server: $errorMessage');
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
      final response = await dio.post(
        '/stop',
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          serverStatus = data['status'] ?? 'unknown';
        });
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Server stopped successfully'),
            duration: Duration(seconds: 7),
          ),
        );
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/stop'),
          response: response,
        );
      }
    } catch (error) {
      final errorMessage = _handleDioError(error);
      _showErrorSnackBar('Error stopping server: $errorMessage');
    } finally {
      setState(() {
        isStopLoading = false;
      });
    }
  }

  // Fire color function
  Future<void> _handleFireColor(String color) async {
    // Check if server is started before sending request
    if (serverStatus != 'started') {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Server is not started. Please activate the server first.',
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 7),
        ),
      );
      return;
    }

    setState(() {
      isShootLoading = true;
    });

    try {
      final response = await dio.post(
        '/color',
        data: {'color': color},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Color $color fired successfully'),
            duration: Duration(seconds: 7),
          ),
        );
      } else {
        throw DioException(
          requestOptions: RequestOptions(path: '/color'),
          response: response,
        );
      }
    } catch (error) {
      final errorMessage = _handleDioError(error);
      _showErrorSnackBar('Error firing color: $errorMessage');
    } finally {
      setState(() {
        isShootLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if shoot action should be enabled based on server status
    bool canShoot = serverStatus == 'started' && !isShootLoading;

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
                              serverStatus == 'started'
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
                  onChanged: _updateBaseUrl,
                ),
                SizedBox(height: 20),
                Text(
                  'Select a Color to Shoot:',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                if (serverStatus != 'started')
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Activate the server before shooting',
                      style: TextStyle(color: Colors.orange, fontSize: 14),
                    ),
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
                      color: canShoot ? Colors.white : Colors.grey,
                      width: 5,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: CupertinoButton(
                    onPressed:
                        isShootLoading || serverStatus != 'started'
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
                    child:
                        isShootLoading
                            ? CupertinoActivityIndicator()
                            : Text(
                              'Shoot',
                              style: TextStyle(
                                color: canShoot ? Colors.white : Colors.grey,
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
