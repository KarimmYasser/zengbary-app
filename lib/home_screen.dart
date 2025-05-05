import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zengbary/find_ball_screen.dart';
import 'package:zengbary/hit_target_screen.dart';
import 'package:zengbary/memory_screen.dart';
import 'package:zengbary/rubik_solver_screen.dart';
import 'package:zengbary/tictactoe_screen.dart';

import 'custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, dynamic>> games = [
    {
      'title': 'Tic Tac Toe',
      'icon': Icons.grid_3x3,
      'screen': TictactoeScreen(),
    },
    {
      'title': 'Find the Ball',
      'icon': Icons.sports_baseball,
      'screen': FindBallScreen(),
    },
    {'title': 'Hit Target', 'icon': Iconsax.game, 'screen': HitTargetScreen()},
    {
      'title': 'Rubik\'s Cube Solver',
      'icon': Iconsax.dcube,
      'screen': RubikSolverScreen(),
    },
    {'title': 'Memory Game', 'icon': Iconsax.cpu, 'screen': MemoryScreen()},
  ];

  HomeScreen({super.key});

  void sendCommand(String game) {
    // TODO: Connect to Arduino and send specific command for each game
    print('Sending command for: $game');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Zengbary Controller',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
        ),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color(0xFF151515)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: games.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.blueGrey.shade900,
              color: Color(0xFF1C1C1E),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => games[index]['screen'],
                    ),
                  );
                  sendCommand(games[index]['title']);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Color(0xFF1D1D23), Color(0xFF3A3A3E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: Colors.white,
                          child: Icon(
                            games[index]['icon'],
                            color: Colors.black,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          games[index]['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
