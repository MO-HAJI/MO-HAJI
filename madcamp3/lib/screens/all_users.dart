import 'package:flutter/material.dart';
import '../models/user.dart';
import '../service/api_image.dart';
import '../service/network.dart';
import '../screens/other_user_food.dart'; // Import your other_user_food screen

class AllUsersScreen extends StatefulWidget {
  @override
  _AllUsersScreenState createState() => _AllUsersScreenState();
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  List<Map<String, dynamic>> allUsers = [];

  Network network = Network();
  APIImage apiImage = APIImage();

  @override
  void initState() {
    super.initState();
    fetchAllUsers();
  }

  Future<void> fetchAllUsers() async {
    try {
      List<Map<String, dynamic>> users = await network.allMember();
      setState(() {
        allUsers = users;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          Map<String, dynamic> user = allUsers[index];
          String profileImage = user['profile_image'] ?? '';

          bool isCurrentUser = user['email'] == User.current.email;

          return isCurrentUser
              ? SizedBox.shrink()
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

class FollowButton extends StatefulWidget {
  final String userEmail;
  final String targetUserEmail;
  final Function onFollowComplete;

  const FollowButton({
    required this.userEmail,
    required this.targetUserEmail,
    required this.onFollowComplete,
  });

  @override
  _FollowButtonState createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  int isFollowing = 0;
  Network network = Network();

  @override
  void initState() {
    super.initState();
    checkFollowingStatus();
  }

  Future<void> checkFollowingStatus() async {
    // Implement the logic to check if the user is already followed
    // Update the value of 'isFollowing' accordingly
    // For example:
    int following = await network.checkIfFollowing(
      widget.userEmail,
      widget.targetUserEmail,
    );
    setState(() {
      isFollowing = following;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (isFollowing == 1) {
          // If already following, unfollow
          await network.unfollowUser(
            widget.userEmail,
            widget.targetUserEmail,
          );
        } else {
          // If not following, follow
          await network.followUser(
            widget.userEmail,
            widget.targetUserEmail,
          );
        }

        // Toggle the value of 'isFollowing'
        setState(() {
          isFollowing = isFollowing == 1 ? 0 : 1;
        });

        // Call the callback function after following/unfollowing is complete
        widget.onFollowComplete();
      },
      child: Text(isFollowing == 1 ? 'Unfollow' : 'Follow'),
    );
  }
}
