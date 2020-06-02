import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:news/data/settings/SettingRepository.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  SettingRepository repository;

  String _privacyPolicy = '';

  @override
  void initState() {
    super.initState();
    repository = SettingRepository.create();
    repository.fetchAndGet().then((value) {
      updatePrivacyPolicy();
    });

    updatePrivacyPolicy();
  }

  void updatePrivacyPolicy() {
    repository.getPrivacyPolicy().then((value) {
      setState(() {
        _privacyPolicy = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Privacy Policy"),
        ),
        body: SingleChildScrollView(
          child: Html(
            data: (_privacyPolicy == null || _privacyPolicy.isEmpty)
                ? '<h3>Not available</h3>'
                : _privacyPolicy,
         //   baseURL: "",
           /* onLaunchFail: () {
              print('Failed');
            },
          */),
        ));
  }
}
