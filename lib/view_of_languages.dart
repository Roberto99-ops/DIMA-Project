import 'package:flutter/material.dart';


class SettingsWidgetLanguage extends StatefulWidget {
  const SettingsWidgetLanguage({Key? key}) : super(key: key);

  @override
  _SettingsWidgetLanguageState createState() => _SettingsWidgetLanguageState();
}

class _SettingsWidgetLanguageState extends State<SettingsWidgetLanguage> {

  final List _languages =
  ["en", "it", "fr", "es", "ru"];

  late List<DropdownMenuItem<String>> _dropDownMenuItems;
  String? _currentLanguage;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentLanguage = _dropDownMenuItems[0].value!;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String language in _languages) {
      items.add(DropdownMenuItem(
          value: language,
          child: Text(language)
      ));
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(5),
              ),
              Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: Text("Please choose your language: "),
                  ),
                  Expanded(
                    flex: 1,
                    child:
                    Center(
                      child:
                      DropdownButton<String>(
                        value: _currentLanguage,
                        items: _dropDownMenuItems,
                        onChanged: (_currentLanguage) => setState(() {
                          this._currentLanguage = _currentLanguage;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
      ),
    );
  }

  void changedDropDownItem(String selectedLanguage) {
    setState(() {
      _currentLanguage = selectedLanguage;
    });
  }

}