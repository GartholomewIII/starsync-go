import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'sign_in_screen.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 2; // Default to Feed
  static const List<String> _titles = [
    'Connect', 'Leaderboards', 'Feed', 'Friends', 'Settings'
  ];
  static const List<IconData> _icons = [
    Icons.link, Icons.emoji_events, Icons.dynamic_feed, Icons.people, Icons.settings
  ];

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;
    if (_selectedIndex == 2) {
      // Feed tab
      final user = FirebaseAuth.instance.currentUser;
      bodyContent = Column(
        children: [
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    if (user != null)
                      StreamBuilder<UserModel?>(
                        stream: UserService().streamUser(user.uid),
                        builder: (context, snapshot) {
                          final userModel = snapshot.data;
                          if (userModel != null && userModel.profilePictureUrl != null && userModel.profilePictureUrl!.isNotEmpty) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                                );
                              },
                              child: CircleAvatar(
                                radius: 22,
                                backgroundImage: NetworkImage(userModel.profilePictureUrl!),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                                );
                              },
                              child: CircleAvatar(
                                radius: 22,
                                backgroundColor: Colors.grey[400],
                                child: const Icon(Icons.person, color: Colors.white, size: 28),
                              ),
                            );
                          }
                        },
                      )
                    else
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (_) => const ProfilePage()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[400],
                          child: const Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                      ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          filled: true,
                          fillColor: Colors.grey[200],
                          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                        ),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double spacing = 6;
                final int crossAxisCount = 3;
                final double width = constraints.maxWidth;
                final double itemSize = (width - (spacing * (crossAxisCount + 1))) / crossAxisCount;
                return GridView.builder(
                  padding: const EdgeInsets.all(6),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio: 1,
                  ),
                  itemCount: 30,
                  itemBuilder: (context, index) {
                    return Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      );
    } else if (_selectedIndex == 4) {
      // Settings tab
      bodyContent = Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const SignInScreen()),
                (route) => false,
              );
            }
          },
          child: const Text('Sign Out'),
        ),
      );
    } else {
      bodyContent = Center(
        child: Text(
          _titles[_selectedIndex],
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      );
    }
    return Scaffold(
      body: bodyContent,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFD32F2F),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: List.generate(5, (index) => BottomNavigationBarItem(
          icon: Icon(_icons[index]),
          label: _titles[index],
        )),
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
} 