import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FoodInfoWidget extends StatelessWidget {
  final String recipe;
  final String allergy;

  FoodInfoWidget({required this.recipe, required this.allergy});

  @override
  Widget build(BuildContext context) {
    List<String> recipeSections = recipe.split('[');
    if (recipeSections.isNotEmpty) {
      // Remove the empty string before the first "[" and any content inside "[...]"
      recipeSections.removeAt(0);
      recipeSections = recipeSections.map((section) => section.split(']').last).toList();
    }

    // Split the allergy string and remove leading empty string
    List<String> allergySections = allergy.split('[');
    if (allergySections.isNotEmpty && allergySections[0].isEmpty) {
      allergySections.removeAt(0);
    }

    // Define the title style
    var titleStyle = TextStyle(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    // Define the section style
    var sectionStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
    );

    // Define different background colors for each section
    var sectionDecorations =
    BoxDecoration(
      color: Colors.deepPurple[50],
      borderRadius: BorderRadius.circular(10.0),
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the first section (Ingredients) with scrolling
          if (recipeSections.length > 0)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Container(
                    width: 320,
                    decoration: sectionDecorations,
                    child: ListTile(
                        title: Text(
                          '재료',
                          style: titleStyle,
                        ),
                        subtitle: Text(
                          recipeSections[0].trim(),
                          style: sectionStyle,
                        ),
                    ),
                  ),
                ),
              ),
            ),

          // Display the second and allergy sections side by side with scrolling
          if (recipeSections.length > 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Second section (Cooking Time) with scrolling
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: sectionDecorations,
                        child: SingleChildScrollView(
                          child: ListTile(
                            title: Text(
                              '조리 시간',
                              style: titleStyle,
                            ),
                            subtitle: Text(
                              recipeSections[1].trim(),
                              style: sectionStyle,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16.0), // Add some spacing between the sections
                    // Allergy section with title and scrolling
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 150,
                        height: 100,
                        decoration: sectionDecorations,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  '알러지',
                                  style: titleStyle,
                                ),
                                subtitle: Text(
                                  allergySections.isNotEmpty
                                      ? allergySections[0].replaceAll(']', '').trim()
                                      : '', // Use the first non-empty section
                                  style: sectionStyle,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Remaining sections (if any) with scrolling
          for (int i = 2; i < recipeSections.length; i++)
            if (recipeSections[i].isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Container(
                      width: 320,
                      decoration: sectionDecorations,
                      child: ListTile(
                          title: Text(
                            '조리법',
                            style: titleStyle,
                          ),
                          subtitle: Text(
                            recipeSections[i].trim(),
                            style: sectionStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}