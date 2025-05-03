import 'package:cfg_language_generator_flutter/data/cfg_generator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController prodRulesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CfgGenerator>(
      builder: (context, generator, widget1) {
        List<DropdownMenuItem> nodes =
            generator
                .getNodes()
                .map((x) => DropdownMenuItem(value: x, child: Text(x)))
                .toList();

        nodes.add(DropdownMenuItem<String>(value: "", child: Text("NULL")));
        return Scaffold(
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      hintText: "CFG Rules (In Json)",
                    ),
                    controller: prodRulesController,
                    maxLines: null,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      generator.setProdRules(prodRulesController.text);
                    },
                    child: Text("Process Rules"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Root: "),
                      SizedBox(width: 10),
                      IgnorePointer(
                        ignoring: generator.prodRules.isEmpty,
                        child: DropdownButton(
                          value: generator.root,
                          items: nodes,
                          onChanged: (x) {
                            setState(() {
                              generator.root = x ?? "";
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: AlertDialog(
                                title: Text(
                                  "Generated Sentences: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),

                                  textAlign: TextAlign.center,
                                ),
                                content: Center(
                                  child: FutureBuilder(
                                    future: generator.generateSentence(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return CircularProgressIndicator();
                                      }
                                      return SingleChildScrollView(
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.4,
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                          child: Scrollbar(
                                            thumbVisibility: true,
                                            child: ListView.builder(
                                              itemCount:
                                                  generator
                                                      .generatedStrings
                                                      .length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 8.0,
                                                      ),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder:
                                                            (
                                                              context,
                                                            ) => AlertDialog(
                                                              content: Center(
                                                                child: Text(
                                                                  generator
                                                                          .generatedStrings[generator
                                                                          .generatedStrings
                                                                          .keys
                                                                          .toList()[index]] ??
                                                                      "",
                                                                ),
                                                              ),
                                                            ),
                                                      );
                                                    },
                                                    child: Text(
                                                      generator
                                                          .generatedStrings
                                                          .keys
                                                          .toList()[index],
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                      );
                    },
                    child: Text("Generate"),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
