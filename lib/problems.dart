import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

import 'map.dart';

class ProblemListScreen extends StatelessWidget {
  const ProblemListScreen({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('raisedProblems').get();
    return snapshot.docs;
  }


  Color getColorBasedOnSeverity(String severity) {
    switch (severity) {
      case 'High Severity (7-10)':
        return Colors.red;
      case 'Moderate Severity (4-6)':
        return Colors.orange;
      case 'Low Severity (1-3)':
        return Colors.green;
      default:
        return Colors.cyan;
    }
  }

  // Function to display document details in an alert dialog
  void _showDocumentDetails(BuildContext context, Map<String, dynamic> documentData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Problem Details'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${documentData['Name']}'),
              Text('Number: ${documentData['Number']}'),
              Text('Problem: ${documentData['Problem']}'),
              Text('Discription: ${documentData['Discription']}'),
              Text('Severity: ${documentData['Severity']}'),
              Text('Location: ${documentData['Location']}'),
              Text('GeoTag: ${documentData['GeoTag']}'),
              Text('Image: ${documentData['Image']}'),
              Text('Time: ${documentData['TimeStamp']}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _copyToClipboard(documentData['Image']);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Text copied to clipboard'),
                  ),
                );
              },
              child: const Text('Copy Image link'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }


  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Problem'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Stack(children:[
          FutureBuilder(
            future: getUsers(),
            builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var userDocument = snapshot.data![index];
                    var userName = userDocument['Problem'];
                    var severity = userDocument['Severity'];
                    return Card(
                      child: ListTile(
                        title: Text(
                          userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(userDocument['Location']),
                        trailing: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: getColorBasedOnSeverity(severity),
                          ),
                        ),
                        onTap: () {
                          _showDocumentDetails(context, userDocument.data());
                        },
                      ),
                    );
                  },
                );
              }
            },
          ),
          Positioned(
            bottom: 16,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MapScreen(),
                  ),
                );
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*1,50)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
              ),
              child: const Text('Locate in Map'),
            ),
          ),
        ]),
      )
    );
  }
}