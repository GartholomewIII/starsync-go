import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/user_service.dart';
import '../models/user_model.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _loading = false;
  String? _error;
  String? _profilePictureUrl;
  File? _pickedImage;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      UserService().getUser(user.uid).then((userModel) {
        if (userModel != null) {
          _usernameController.text = userModel.username;
          _bioController.text = userModel.bio;
          setState(() {
            _profilePictureUrl = userModel.profilePictureUrl;
          });
        }
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() { _loading = true; _error = null; });
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await UserService().updateUserUsername(user.uid, _usernameController.text.trim());
        await UserService().updateUserBio(user.uid, _bioController.text.trim());
        if (mounted) Navigator.of(context).pop();
      } catch (e) {
        setState(() { _error = 'Failed to save profile.'; });
      }
    }
    setState(() { _loading = false; });
  }

  Future<void> _changeProfilePicture() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() { _pickedImage = File(picked.path); });
      try {
        final ref = FirebaseStorage.instance.ref().child('profile_pictures/${user.uid}.jpg');
        await ref.putFile(_pickedImage!);
        final url = await ref.getDownloadURL();
        await UserService().updateUserProfilePicture(user.uid, url);
        setState(() { _profilePictureUrl = url; });
      } catch (e) {
        setState(() { _error = 'Failed to upload profile picture.'; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;
    if (_pickedImage != null) {
      avatarWidget = CircleAvatar(
        radius: 48,
        backgroundImage: FileImage(_pickedImage!),
      );
    } else if (_profilePictureUrl != null && _profilePictureUrl!.isNotEmpty) {
      avatarWidget = CircleAvatar(
        radius: 48,
        backgroundImage: NetworkImage(_profilePictureUrl!),
      );
    } else {
      avatarWidget = CircleAvatar(
        radius: 48,
        backgroundColor: Colors.grey[400],
        child: const Icon(Icons.person, color: Colors.white, size: 56),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
        title: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  avatarWidget,
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _changeProfilePicture,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFD32F2F),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Username', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 12),
            TextField(
              controller: _usernameController,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your username',
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Bio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            const SizedBox(height: 12),
            TextField(
              controller: _bioController,
              maxLines: 3,
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tell the world about yourself!',
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD32F2F),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: _loading ? null : _saveProfile,
                child: _loading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 