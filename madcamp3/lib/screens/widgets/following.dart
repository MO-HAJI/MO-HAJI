import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../service/api_image.dart';
import '../../service/network.dart';
import '../all_users.dart';
import '../other_user_food.dart';

class FollowingPage extends StatefulWidget {
  const FollowingPage({super.key});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {
  List<Map<String, dynamic>> followings = [];

  Network network = Network();
  APIImage apiImage = APIImage();

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      var users = await network
          .getFollowings(User.current.email); // Use getFollowings method
      setState(() {
        followings = users;
      });
    } catch (e) {
      print(e);
    }
  }

  // Function to handle the follow action
  Future<void> followUser(String userEmail) async {
    try {
      // You can customize this part based on your UI/UX for the follow action
      Map<String, dynamic> followResult = await network.followUser(
        User.current.email,
        userEmail,
      );

      if (followResult.containsKey('error')) {
        // Handle error
        print('Failed to follow user: ${followResult['error']}');
      } else {
        // Follow successful
        print('Successfully followed user');
        // Optionally, you can update the UI to reflect the follow action
        fetchAllUsers(); // Update the user list after following
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Followings'),
      ),
      body: ListView.builder(
        itemCount: followings.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> user = followings[index];
          String profileImage = user['profile_image'] ?? '';

          // Check if the current user is the logged-in user
          bool isCurrentUser = user['email'] == User.current.email;

          return isCurrentUser
              ? SizedBox.shrink() // If it's the current user, hide the item
              : ListTile(
                  title: Text(user['name'] ?? ''),
                  subtitle: Text(user['email'] ?? ''),
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(apiImage.getImage(profileImage) ?? ''),
                  ),
                  trailing: FollowButton(
                    userEmail: User.current.email,
                    targetUserEmail: user['email'],
                    onFollowComplete: () {
                      // Reload the user list after following/unfollowing
                      fetchAllUsers();
                    },
                  ),
                  onTap: () {
                    // Navigate to other_user_food screen when a user is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            other_user_food(userEmail: user['email']),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
