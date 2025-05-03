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
                horizontal:
                    MediaQuery.of(context).size.width <
                            MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.width * 0.05
                        : MediaQuery.of(context).size.width * 0.2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "CFG Language Generator",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),

                  TextField(
                    decoration: InputDecoration(
                      hintText: "CFG Rules (In Json)",
                    ),
                    controller: prodRulesController,
                    maxLines: null,
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      bool result = generator.setProdRules(
                        prodRulesController.text,
                      );

                      if (result) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Rules Updated")),
                        );
                      } else {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid Rules!")),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text("Process Rules"),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Recursion Depth:"),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.1,
                    ),

                    child: Row(
                      children: [
                        Slider(
                          value: generator.maxDepth / 20,
                          onChanged: (x) {
                            x *= 20;
                            setState(() {
                              generator.maxDepth = x.toInt();
                            });
                          },
                        ),
                        Text(generator.maxDepth.toString()),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

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

                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (generator.root.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder:
                              (context) => SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: AlertDialog(
                                  title: Text(
                                    "Generated Sentences: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26,
                                    ),

                                    textAlign: TextAlign.center,
                                  ),
                                  content: FutureBuilder(
                                    future: generator.generateSentence(),
                                    builder: (context, snapshot) {
                                      if (snapshot.data == null) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.4,
                                        height:
                                            MediaQuery.of(context).size.height *
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
                                                            title: Text(
                                                              "Rules used, in order...",
                                                            ),
                                                            content: SizedBox(
                                                              height:
                                                                  MediaQuery.of(
                                                                        context,
                                                                      )
                                                                      .size
                                                                      .height *
                                                                  0.5,
                                                              width:
                                                                  MediaQuery.of(
                                                                    context,
                                                                  ).size.width *
                                                                  0.5,
                                                              child: SingleChildScrollView(
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
                                                          ),
                                                    );
                                                  },
                                                  child: Text(
                                                    generator
                                                        .generatedStrings
                                                        .keys
                                                        .toList()[index],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                        );
                      }
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
