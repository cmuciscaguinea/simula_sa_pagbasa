import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'aralin_page.dart';
import 'tungkol_page.dart';
import 'laro_page.dart';
import 'splash_screen.dart'; // Import the splash screen

void main() => runApp(SimulaSaPagbasaApp());

class SimulaSaPagbasaApp extends StatelessWidget {
  const SimulaSaPagbasaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
       debugShowCheckedModeBanner: false, // Hides the debug banner
      home: SplashScreen(), // Set the SplashScreen as the initial screen
      theme: ThemeData(
        primaryColor: Colors.green,
        textTheme: GoogleFonts.lexendDecaTextTheme(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> clearCache(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    imageCache.clear();
    imageCache.clearLiveImages();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache cleared successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Marungko Approach', style: GoogleFonts.lexendDeca()),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/blue.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/logo1.jpg',
                width: 500,
                height: 400,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AralinPage()),
                  );
                },
                child: Text(
                  'MGA ARALIN',
                  style: GoogleFonts.lexendDeca(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(200, 50),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LaroPage()),
                  );
                },
                child: Text(
                  'LARO',
                  style: GoogleFonts.lexendDeca(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TungkolPage()),
                  );
                },
                child: Text(
                  'TUNGKOL',
                  style: GoogleFonts.lexendDeca(
                      fontSize: 18, color: Colors.green),
                ),
              ),
              const SizedBox(height: 20),
              // ElevatedButton(
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     minimumSize: const Size(200, 50),
              //   ),
              //   onPressed: () => clearCache(context),
              //   child: Text(
              //     'CLEAR CACHE',
              //     style: GoogleFonts.lexendDeca(fontSize: 18, color: Colors.white),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
