import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/user_service.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder<UserModel?>(
                  stream: user != null ? UserService().streamUser(user.uid) : null,
                  builder: (context, snapshot) {
                    final userModel = snapshot.data;
                    if (userModel != null && userModel.profilePictureUrl != null && userModel.profilePictureUrl!.isNotEmpty) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userModel.profilePictureUrl!),
                      );
                    } else {
                      return CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[400],
                        child: const Icon(Icons.person, color: Colors.white, size: 48),
                      );
                    }
                  },
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StreamBuilder<UserModel?>(
                        stream: user != null ? UserService().streamUser(user.uid) : null,
                        builder: (context, snapshot) {
                          final userModel = snapshot.data;
                          final username = userModel?.username ?? '';
                          final email = user?.email ?? 'No email';
                          return Text(
                            username.isNotEmpty ? username : email,
                            style: const TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      if (user != null)
                        StreamBuilder<UserModel?>(
                          stream: UserService().streamUser(user.uid),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Text('Loading bio...', style: TextStyle(fontSize: 16, color: Colors.black87));
                            }
                            final bio = snapshot.data?.bio ?? '';
                            return Text(
                              bio.isEmpty ? 'This is your bio. Tell the world about yourself!' : bio,
                              style: const TextStyle(fontSize: 16, color: Colors.black87),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        )
                      else
                        const Text('This is your bio. Tell the world about yourself!', style: TextStyle(fontSize: 16, color: Colors.black87)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const EditProfilePage()),
                  );
                },
                child: const Text('Edit Profile'),
              ),
            ),
            const SizedBox(height: 24),
            // User's posts grid
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1,
                ),
                itemCount: 12, // Placeholder for user's posts
                itemBuilder: (context, index) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Create Post'),
                      content: const Text('Post creation coming soon!'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Close'),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD32F2F),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add, color: Colors.white, size: 32),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
} 