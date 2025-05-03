import 'dart:convert';

import 'package:flutter/material.dart';

class CfgGenerator extends ChangeNotifier {
  List<String> terminSym = [];
  Map<String, dynamic> prodRules = {};

  Map<String, String> generatedStrings = {};
  String root = "";
  int maxDepth = 6;

  Future<bool> generateSentence() async {
    generatedStrings = {};
    debugPrint("generating...");
    await evaluate(root, maxDepth, 0, "");
    debugPrint("generated.");
    notifyListeners();

    return true;
  }

  void setProdRules(String rulesString) {
    prodRules = json.decode(rulesString);

    terminSym = [];
    for (List<dynamic> options in prodRules.values.toList()) {
      for (String option in options) {
        for (String element in option.split("+")) {
          if (!prodRules.containsKey(element) && !terminSym.contains(element)) {
            terminSym.add(element);
          }
        }
      }
    }

    print(terminSym);

    notifyListeners();
  }

  List<String> getNodes() {
    return prodRules.keys.toList();
  }

  Future<void> evaluate(String s, int d, int i, String rulesUsed) async {
    if (i > d) {
      return;
    }

    bool allTerminal = true;
    for (var node in s.split("+")) {
      if (!terminSym.contains(node)) {
        allTerminal = false;
        break;
      }
    }

    if (allTerminal) {
      s = s.replaceAll("+", " ");
      s = "${s[0].toUpperCase()}${s.substring(1)}.";
      // debugPrint("\nSentence complete");
      // debugPrint("s");
      generatedStrings[s] = rulesUsed;
      return;
    }

    for (var symbol in s.split("+")) {
      if (terminSym.contains(symbol)) {
      } else {
        if (prodRules.containsKey(symbol)) {
          for (var evaluation in prodRules[symbol]) {
            String newS = s.replaceFirst(symbol, evaluation, 0);
            String rule = "$symbol -> ${prodRules[symbol]}";
            String newRulesUsed = "$rulesUsed\n$rule\n$newS\n\n";

            evaluate(newS, d, i + 1, newRulesUsed);
          }
        }
      }
    }
  }
}
