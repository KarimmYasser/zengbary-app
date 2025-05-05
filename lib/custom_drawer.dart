import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:zengbary/find_ball_screen.dart';
import 'package:zengbary/hit_target_screen.dart';
import 'package:zengbary/home_screen.dart';
import 'package:zengbary/memory_screen.dart';
import 'package:zengbary/rubik_solver_screen.dart';
import 'package:zengbary/setting_screen.dart';
import 'package:zengbary/tictactoe_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
      {
        'title': 'Hit Target',
        'icon': Iconsax.game,
        'screen': HitTargetScreen(),
      },
      {
        'title': 'Rubik\'s Cube Solver',
        'icon': Iconsax.dcube,
        'screen': RubikSolverScreen(),
      },
      {'title': 'Memory Game', 'icon': Iconsax.cpu, 'screen': MemoryScreen()},
    ];

    return Drawer(
      child: Container(
        color: Colors.black, // Set the background color to black
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: 100,
              height: 200,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: BottomRoundedClipper(),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withValues(alpha: 0.8),
                        // Adjust opacity for darkness
                        BlendMode.darken,
                      ),
                      child: Image.asset(
                        'assets/robot.jpg',
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    bottom: 34,
                    child: Text(
                      'Zengbary Menu',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Iconsax.home, color: Colors.white),
              title: Text('Home', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
            Divider(color: Colors.grey, height: 20),
            ...games.map((game) {
              return ListTile(
                contentPadding: EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                leading: Icon(game['icon'], color: Colors.white),
                title: Text(
                  game['title'],
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => game['screen']),
                  );
                },
              );
            }).toList(),
            Divider(color: Colors.grey),
            ListTile(
              leading: Icon(Iconsax.setting, color: Colors.white),
              title: Text('Setting', style: TextStyle(color: Colors.white)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingScreen()),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0,vertical: 10),
              child: Text(
                'Copywrite @2025 Zengbary LLc.\nall rights reserved.',
                style: TextStyle(color: Colors.grey,fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BottomRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(
      firstCurve.dx,
      firstCurve.dy,
      lastCurve.dx,
      lastCurve.dy,
    );
    final secondFirstCurve = Offset(0, size.height - 20);
    final secondLastCurve = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(
      secondFirstCurve.dx,
      secondFirstCurve.dy,
      secondLastCurve.dx,
      secondLastCurve.dy,
    );
    final thirdFirstCurve = Offset(size.width, size.height - 20);
    final thirdLastCurve = Offset(size.width, size.height);
    path.quadraticBezierTo(
      thirdFirstCurve.dx,
      thirdFirstCurve.dy,
      thirdLastCurve.dx,
      thirdLastCurve.dy,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
