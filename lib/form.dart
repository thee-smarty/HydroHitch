// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


class RForm extends StatefulWidget {
  const RForm({super.key});

  @override
  MyForm createState()=> MyForm();
}


class MyForm extends State<RForm> {
  User? user = FirebaseAuth.instance.currentUser;
  bool _showButtons = false;
  File? _image;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController name = TextEditingController();
  final TextEditingController num = TextEditingController();
  final TextEditingController loc = TextEditingController();
  final TextEditingController dis = TextEditingController();
  final imagePicker = ImagePicker();
  String? url,problem,severity;

  Future<String> captureImage() async {
    String userId = user!.uid;
    final pickedFile = await imagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (pickedFile == null) {
      return 'no image given';
    }

      final file = File(pickedFile.path);
    Reference storageRef = FirebaseStorage.instance.ref().child('ProblemImages/${userId+DateTime.now().toString()}.jpeg');

    try {
      await storageRef.putFile(file);
      String downloadURL = await storageRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      return 'error uploading image';
    }
  }


  Future<String> selectImage() async {
    String userId = user!.uid;
    final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final storageRef = FirebaseStorage.instance.ref().child('/ProblemImages/${userId+DateTime.now().toString()}.jpeg');
      final uploadTask = storageRef.putFile(file);

      await uploadTask.whenComplete(() => null);

      return storageRef.getDownloadURL();
    } else {
      // Handle no image selected
      return 'no image given';
    }
  }


  @override
  Widget build(BuildContext context) {
    int s=0;
    return Scaffold(
      appBar: AppBar(title: const Text('Raise your problem'),),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Form(
          child: SingleChildScrollView(
            key: _formKey,
            child: Column(
              children:[

              TextFormField(
                controller: name,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Your name',
                ),
              ),

              const SizedBox(height: 5.0),

              TextFormField(
                controller: num,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Mobile number',
                ),
              ),

                const SizedBox(height: 5.0),

              FormBuilderDropdown<String>(
                name: 'Problem Type',
                decoration: InputDecoration(
                  labelText: 'Choose your problem type',
                  //initialValue: 'Other',
                  suffix: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _formKey.currentState!.fields['Choose your problem type']
                          ?.reset();
                    },
                  ),
                  hintText: 'Choose your problem type',
                ),
                items: <String>[
                  'Lack of Sanitation',
                  'Water Leakage',
                  'Floods',
                  'Drought',
                  'Water Scarcity',
                  'Water Pollution'
                ].map((String value) {
                 // problem = _formKey.currentState?.fields['Problem Type']?.value;
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    problem = value ?? ''; // Update the selected value
                  });
                },
              ),

              const SizedBox(height: 5.0),

              TextFormField(
                controller: dis,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter problem description',
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),

              const SizedBox(height: 5.0),

                FormBuilderDropdown<String>(
                  name: 'Severity',
                  decoration: InputDecoration(
                    labelText: 'Choose problem severity',
                    //initialValue: 'Other',
                    suffix: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _formKey.currentState!.fields['Choose your problem type']
                            ?.reset();
                      },
                    ),
                    hintText: 'Choose problem severity',
                  ),
                  items: <String>[
                    'Low Severity (1-3)',
                    'Moderate Severity (4-6)',
                    'High Severity (7-10)'
                    ].map((String value) {
                    //severity = _formKey.currentState?.fields['Severity']?.value;
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      severity = value ?? ''; // Update the selected value
                    });
                  },
                ),

              const SizedBox(height: 5.0),

              TextFormField(
                controller: loc,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Location',
                ),
              ),

              const SizedBox(height: 5.0),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  )
                else
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _showButtons ? Row(
                    key: ValueKey<bool>(_showButtons),
                    children: [

                    SizedBox(width: MediaQuery.of(context).size.width*0.06,),

                    ElevatedButton(
                      onPressed: () async{
                        url = await captureImage();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.4,50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                      child: const Text('Capture Image'),
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width*0.02,),

                    ElevatedButton(
                      onPressed: () async {
                        url = await selectImage();
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.4,50)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
                      child: const Text('Select from Device'),
                    ),

                    SizedBox(width: MediaQuery.of(context).size.width*0.06,),

                    ],
                  ) : ElevatedButton(
                    key: ValueKey<bool>(_showButtons),
                    onPressed: () {
                      setState(() {
                        _showButtons = true;
                      });
                    },
                    child: const Text('Add Image'),
                  ),
                ),
              ]),

              const SizedBox(height: 15.0),

              Row(
              children:[
                SizedBox(width: MediaQuery.of(context).size.width*0.06,),

                ElevatedButton(
                  onPressed: () async{
                    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
                    if(s==1){
                      _showDone(context);
                    }
                    else if(name.text.isNotEmpty && num.text.isNotEmpty && url != null && problem != null && severity != null && dis.text.isNotEmpty && loc.text.isNotEmpty) {
                      s=1;
                      addToFirebase(
                          name.text,
                          num.text,
                          url,
                          problem,
                          severity,
                          dis.text,
                          loc.text,
                          position);
                      _showSuccess(context);
                    }
                    else{
                      _showError(context);
                    }
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.4,50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      )
                    ),
                  ),
                  child: const Text('Submit'),
                ),

                SizedBox(width: MediaQuery.of(context).size.width*0.02,),

                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.4,50)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                        )
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ]),
            ]),
          ),
        ),
      ),
    );
  }
}


void addToFirebase(String name, String number,String? url,String? problem, String? severity, String discription, String location, Position position) async{
  User? user = FirebaseAuth.instance.currentUser;
  String userId = user!.uid;
  DateTime currentTime = DateTime.now();
  Timestamp timestamp = Timestamp.fromDate(currentTime);

  FirebaseFirestore.instance.collection('raisedProblems').doc(userId+DateTime.now().toString()).set({
    'Name': name,
    'Number': number,
    'Problem': problem,
    'Discription': discription,
    'Severity': severity,
    'Location': location,
    'GeoTag': {
      'latitude': position.latitude,
      'longitude': position.longitude,
    },
    'Image' : url,
    'TimeStamp': timestamp,
    'Uid' : userId,
  });
}


void _showError(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Enter details'),
        content: const Text('Name, Number, Problem, Discription, Severity, Location. These helps us to identify.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}


void _showSuccess(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Completed'),
        content: const Text('Your problem has been submitted.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      );
    },
  );
}


void _showDone(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Accomplished'),
        content: const Text('Your problem is already submitted. You can go back.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Done'),
          ),
        ],
      );
    },
  );
}