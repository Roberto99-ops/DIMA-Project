import 'package:flutter/material.dart';


class SettingsWidgetLanguage extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SettingsWidgetLanguage({Key? key, required this.onChanged}) : super(key: key);

  @override
  _SettingsWidgetLanguageState createState() => _SettingsWidgetLanguageState();
}

class _SettingsWidgetLanguageState extends State<SettingsWidgetLanguage> {

  static const Map<String, String> _languages = {
    "Deutsch": "de",
    "English": "en",
    "Español":"es",
    "Français": "fr",
    "Hindi": "hi",
    "Italiano": "it",
    "русский": "ru",
    "Urdu": "ur",
    "中国人": "zh-cn",
  };

  String? _currentLanguage;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black26,
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
                    flex: 5,
                    child: Center(),
                  ),
                  const Expanded(
                    flex: 55,
                    child: Text("Please choose your language: "),
                  ),
                  Expanded(
                    flex: 40,
                    child:
                    Center(
                      child:
                      DropdownButton<String>(
                        borderRadius: BorderRadius.circular(20.0),
                        dropdownColor: Colors.black45,
                        value: _currentLanguage,
                        items: _languages
                            .map((string, value) {
                              return MapEntry(
                                string,
                                DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(string),
                                ),
                              );
                            })
                            .values
                            .toList(),


                        onChanged: (currentLanguage) => {
                          setState(() {
                            _currentLanguage = currentLanguage!;
                          }),
                          widget.onChanged(currentLanguage!),
                        },
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
}
