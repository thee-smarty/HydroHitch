// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getDocuments() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await FirebaseFirestore.instance.collection('raisedProblems').get();
    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getDocuments(),
      builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot<Map<String, dynamic>>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          return _buildMap(context, snapshot.data!);
        }
      },
    );
  }


  Widget _buildMap(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem Map'),
      ),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(16.48, 80.69),
          initialZoom: 12.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _buildMarkers(context, documents),
          ),
        ],
      ),
    );
  }


  List<Marker> _buildMarkers(BuildContext context, List<QueryDocumentSnapshot<Map<String, dynamic>>> documents) {
    return documents.map((document) {
      var geoTag = document['GeoTag'] as Map<String, dynamic>?;
      var severity = document['Severity'];

      if (geoTag != null) {
        var latitude = geoTag['latitude'] as double?;
        var longitude = geoTag['longitude'] as double?;

        if (latitude != null && longitude != null) {
          return Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(latitude, longitude),
            child: IconButton(
              icon: const Icon(Icons.location_pin),
              color: getColorBasedOnSeverity(severity),
              onPressed: () {
                _showDocumentDetails(context, document.data());
              },
            ),
          );
        }
      }
      return const Marker(
        width: 0.0,
        height: 0.0,
        point: LatLng(0, 0),
        child: Icon(
          Icons.wrong_location_outlined,
          color: Colors.blue,
          size: 35.0,
        ),
      );
    }).toList();
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
        return Colors.cyan; // Default color for unknown severity
    }
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
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}