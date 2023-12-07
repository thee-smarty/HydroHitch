// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class UserP extends StatelessWidget {
  final User? user = _auth.currentUser;

  Future<void> _signOut(BuildContext context) async {
    // Call your sign-out function
    await googleSignIn.signOut();
    await _auth.signOut();
    Navigator.pop(context);
  }

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

  Future<List<Map<String, dynamic>>> _getRaisedProblems() async {
    try {
      // Fetch problems from Firestore where the 'Uid' field is equal to the user's UID
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('raisedProblems').where('Uid', isEqualTo: user!.uid).get();

      // Check if there are any documents returned
      if (querySnapshot.size > 0) {
        // Extract the data from the documents
        List<Map<String, dynamic>> problems = querySnapshot.docs.map((doc) => doc.data()).toList();
        return problems;
      }

      // No documents found
      return [];
    } catch (error) {
      SnackBar(content:Text('Error fetching problems: $error'));
      return [];
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  UserP(BuildContext context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: SingleChildScrollView(child:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(user!.photoURL!),
            ),
            const SizedBox(height: 20),
            Text(
              '${user!.displayName}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 5),
            Text(
              '${user!.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Problems Raised:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            FutureBuilder(
              future: _getRaisedProblems(),
              builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child:CircularProgressIndicator()); // Show loading indicator while data is being fetched
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  List<Map<String, dynamic>> problems = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: problems.map((problem) {
                      return ListTile(
                        title: Text(problem['Problem'],style: const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text(problem['Location']),
                        onTap: (){
                          _showDocumentDetails(context, problem);
                        },
                        // Add more details as needed
                      );
                    }).toList(),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _signOut(context);
                // Add any additional functionality or navigation here
              },
              child: const Text('Sign Out'),
            ),
          ]),
        ),
      ),
    );
  }
}