import 'package:bharathbiomedpharma/services/firebase_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'product_list_screen.dart';
import 'login_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User?>(
      future: _checkUserLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/bnewlogo.jpeg',
                    height: 150), // Display the logo
                const SizedBox(height: 20),
                const CircularProgressIndicator(), // Display the loading indicator
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('An error occurred while checking login status'),
                ElevatedButton(
                  onPressed: () {
                    // Retry the check
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const InitialScreen(),
                      ),
                    );
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        } else if (snapshot.hasData) {
          return ProductListScreen();
        } else {
          return LoginScreen();
        }
      },
    );
  }

  // Future<User?> _checkUserLoginStatus() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     // Fetch user profile from Firestore
  //     try {
  //       DocumentSnapshot userDoc = await FirebaseFirestore.instance
  //           .collection('users')
  //           .doc(user.uid)
  //           .get();
  //       if (userDoc.exists) {
  //         // User profile exists
  //         debugPrint('User profile: ${userDoc.data()}');

  //         await FirebaseFirestoreService().syncData();

  //         return user;
  //       }
  //     } catch (e) {
  //       debugPrint('Error fetching user profile: $e');
  //       rethrow; // Rethrow the error to be caught by FutureBuilder
  //     }
  //   }
  //   return null;
  // }

  Future<User?> _checkUserLoginStatus() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch user profile from Firestore
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get(GetOptions(source: Source.cache)); // Read from cache
        if (!userDoc.exists) {
          // If not found in cache, fetch from server
          userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(GetOptions(source: Source.server));
        }

        if (userDoc.exists) {
          // User profile exists
          debugPrint('User profile: ${userDoc.data()}');

          await FirebaseFirestoreService().syncData();

          return user;
        }
      } catch (e) {
        debugPrint('Error fetching user profile: $e');
        rethrow; // Rethrow the error to be caught by FutureBuilder
      }
    }
    return null;
  }
}
