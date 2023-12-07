import 'package:flutter/material.dart';

class Application extends StatelessWidget {
  static const double heading = 17;
  static const double discription = 15;

  const Application({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Application'),),
      body:const Padding(padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
          // Your scrollable content goes here
                Text('1. Problem Reporting and Crowd-sourcing:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Users can easily report and submit water-related issues such as floods, drainage problems, and water quality concerns.
* Crowd-sourcing features allow multiple users to report and verify the same issues.
                ''',style: TextStyle(fontSize: discription),),

                Text('2. Real-Time Mapping:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Integration with maps for easy identification of problem locations.
* GPS functionality for accurate location tracking.
* Mapping tools that enable users to draw and highlight affected areas.
                ''',style: TextStyle(fontSize: discription),),

                Text('3. Data Visualization and Integration:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Integration with various data sources, including photos and text messages.
* Data analysis tools for administrators to identify patterns and trends.
* Visual representation of data through charts and graphs.
                ''',style: TextStyle(fontSize: discription),),

                Text('4. Crisis Management:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Emergency response features for quick reaction to critical situations.
* Communication channels between community heads, corporations, and emergency responders.
* Emergency notification system to alert users in affected areas.
                ''',style: TextStyle(fontSize: discription),),

                Text('5. Community Engagement:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Community forums or discussion boards for users to discuss issues.
* Voting or rating system for prioritizing reported problems.
* Regular updates on the status of reported issues.
                ''',style: TextStyle(fontSize: discription),),

                Text('6. Strategizing and Resource Allocating:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''
* Dashboard for administrators to view and manage reported issues.
* Resource allocation tools based on the severity and urgency of the problems.
* Historical data analysis to inform long-term planning.
                ''',style: TextStyle(fontSize: discription),),

                Text('7. Communication by Notifications:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Push notifications to keep users informed about updates on their reported issues.
* Automated messages for emergency alerts and community announcements.
* In-app messaging for direct communication between users and administrators.
                ''',style: TextStyle(fontSize: discription),),

                Text('8. User Authentication and Security:',style: TextStyle(fontSize: heading,fontWeight: FontWeight.bold),),
                Text('''* Secure login and authentication processes.
* User roles and permissions to control access for different stakeholders.
* Data encryption to ensure the security of user information.
                ''',style: TextStyle(fontSize: 15.0),),
          ]),
        )
      ),
    );
  }
}
