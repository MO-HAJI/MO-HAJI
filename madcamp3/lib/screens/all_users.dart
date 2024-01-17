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
      }
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
          String profileImage =
              user['profile_image'] ?? ''; // Default to an empty string if null

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
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Call the followUser function when the Follow button is pressed
                      followUser(user['email']);
                    },
                    child: Text('Follow'),
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
