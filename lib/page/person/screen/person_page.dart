import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonPage extends StatefulWidget {
  const PersonPage({super.key});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  List<dynamic> personList = [];
  bool isLoading = true;
  dynamic selectedPerson;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> getData() async {
    final res = await http.get(
      Uri.parse('https://apon06.github.io/bookify_api/person_api.json'),
    );
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      setState(() {
        personList = decoded['personInfo'];
        isLoading = false;
        selectedPerson = personList.isNotEmpty ? personList[0] : null;
      });
      await saveDataToPreferences();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveDataToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('personSave', json.encode(personList));
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('personSave');
    if (savedData != null) {
      setState(() {
        personList = json.decode(savedData);
        selectedPerson = personList.isNotEmpty ? personList[0] : null;
        isLoading = false;
      });
    }
    await getData();
  }

  Future<void> refreshData() async {
    setState(() {
      isLoading = true;
    });
    await getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        automaticallyImplyLeading: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: personList.length,
                    itemBuilder: (context, index) {
                      dynamic person = personList[index];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedPerson = person;
                          });
                        },
                        child: SizedBox(
                          height: 55,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5),
                                child: AutoSizeText(
                                  person['personName'],
                                  maxLines: 1,
                                ),
                              ),
                              const Divider(),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                VerticalDivider(
                  // color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                selectedPerson != null
                    ? Expanded(
                        child: PersonInfoPage(
                          personImage: selectedPerson['personImage'],
                          personName: selectedPerson['personName'],
                          personBirth: selectedPerson['personBirth'],
                          personDeath: selectedPerson['personDeath'],
                          personBio: selectedPerson['personBio'],
                          personBook: selectedPerson['personBook'],
                          personWiki: selectedPerson['personWiki'],
                        ),
                      )
                    : const Expanded(
                        child: Center(
                          child: Text('No person selected'),
                        ),
                      ),
              ],
            ),
    );
  }
}

class PersonInfoPage extends StatelessWidget {
  final String personImage;
  final String personName;
  final String personBirth;
  final String personDeath;
  final String personBio;
  final String personBook;
  final String? personWiki;

  const PersonInfoPage({
    super.key,
    required this.personImage,
    required this.personName,
    required this.personBirth,
    required this.personDeath,
    required this.personBio,
    required this.personBook,
    this.personWiki,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: CachedNetworkImageProvider(personImage),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Text(
                personName,
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date of Birth:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(personBirth),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Date of Death:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(personDeath),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Biography:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              personBio,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 24),
            const Text(
              'Famous poetry',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              personBook,
              style: const TextStyle(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
