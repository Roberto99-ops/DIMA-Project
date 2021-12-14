import 'package:translator/translator.dart';

translate (String input, String language) async {
  //Use of free GoogleTranslator
  final translator = GoogleTranslator();

  //First method to traduce using a variable
  final translation = await translator
  .translate(input, to: language);

  return translation.toString();

  /**
  * Other method:
  *
  * print('Something... ${await input.translate(to: language)}');
  *
  *
  * For countries that default base URL doesn't work, like China:
  *
  * translator.baseUrl = 'translate.google.cn';
  * translator.translateAndPrint("Something to traduce", to 'zh-cn');
  *
  **/
}