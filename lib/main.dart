import 'dart:io';

import 'package:accountmamager/desh_board_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    home: AccountPin(),
    debugShowCheckedModeBanner: false,
  ));
}

class AccountPin extends StatefulWidget {
  AccountPin({Key? key}) : super(key: key);

  static SharedPreferences? prefs;

  @override
  State<AccountPin> createState() => _AccountPinState();
}

class _AccountPinState extends State<AccountPin> {
  @override

  void initState() {
    super.initState();
    get_password_sherd();
    q1_is = que1[0];
    q2_is = que2[0];
    sq1 = TextEditingController(text: q1_is);
    sq2 = TextEditingController(text: q2_is);
    currncy = TextEditingController(text: "₹");
  }
  get_password_sherd() async {
    AccountPin.prefs = await SharedPreferences.getInstance();
    set_pass.text = (AccountPin.prefs!.getString("password")) ?? "";
    print("set_pass.text := ${set_pass.text}");
    await first_dialog_box();
  }

  TextEditingController set_pass = TextEditingController();
  TextEditingController Digit_4 = TextEditingController();
  TextEditingController sq1 = TextEditingController();
  TextEditingController ans1 = TextEditingController();
  TextEditingController sq2 = TextEditingController();
  TextEditingController ans2 = TextEditingController();
  TextEditingController currncy = TextEditingController();

  List<String> que1 = [
    "Security Question 1",
    "What Was the first modile that you purchased",
    "What Was the name of your best friend at childhood",
    "What Was name of your first pet?",
    "What is your favorite children's book?",
    "What was the first film you saw in the cinema?",
    "What was the name of your favorite teacher at primary school"
  ];
  List<String> que2 = [
    "Security Question 2",
    "What Was the first modile that you purchased",
    "What Was the name of your best friend at childhood",
    "What Was name of your first pet?",
    "What is your favorite children's book?",
    "What was the first film you saw in the cinema?",
    "What was the name of your favorite teacher at primary school"
  ];
  String q1_is = "";
  String q2_is = "";
  List<bool> borders = List.filled(4, false);
  List<String> pass = [];
  bool pass_is_metch = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: ()async {
          await showDialog(context: context, builder: (context) {
            return AlertDialog(
              title: Text("exit a page "),
              actions: [
                ElevatedButton(onPressed: () {
                  exit(0);
                }, child: Text("exit"))
              ],
            );
          },);
          return false;
        }, child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage("asset/image/splash.png"))),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height / 5,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image:
                          AssetImage("asset/image/ic_notification.png"))),
                ),
                Text(
                  "Account Manager",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "FORGOT PASSWORD?",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                ),
                PassWord_container()
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  first_dialog_box() {
    print(set_pass.text.isEmpty);
    if (set_pass.text.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
            (_) {
          // Execute callback if page is mounted
          showDialog(
            barrierColor: Colors.black54,
            context: context,
            builder: (context) {
              return StatefulBuilder(
                builder: (context, setState2) {
                  return AlertDialog(
                    titlePadding: EdgeInsets.all(0),
                    titleTextStyle: TextStyle(fontSize: 25),
                    title: Container(
                      height: 50,
                      alignment: Alignment.center,
                      color: Colors.deepPurple,
                      child: Text("Setting", textAlign: TextAlign.center),
                      margin: EdgeInsets.all(0),
                    ),
                    content: Container(
                      width: MediaQuery.of(context).size.width / 1.2,
                      height: MediaQuery.of(context).size.height / 1.8,
                      child: SingleChildScrollView(
                        child: Column(children: [
                          TextField(
                            controller: set_pass,
                            cursorColor: Colors.orange,
                            decoration: const InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.orange)),
                                labelText: "Set Password",
                                suffix: Icon(Icons.abc)),
                          ),
                          TextField(
                            controller: Digit_4,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.orange)),
                                labelText:
                                "Password must be 4 character long."),
                          ),
                          ListTile(
                            title: TextField(
                              enabled: false,
                              controller: sq1,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState3) {
                                          return AlertDialog(
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  2,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.3,
                                              child: ListView.builder(
                                                itemCount: que1.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      q1_is = que1[index];
                                                      sq1.text = q1_is;
                                                      setState(() {});
                                                      setState3(() {});
                                                      setState2(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    title:
                                                    Text("${que1[index]}"),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_drop_down)),
                          ),
                          TextField(
                            controller: ans1,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.orange)),
                                labelText: "Answer *"),
                          ),
                          ListTile(
                            title: TextField(
                              enabled: false,
                              controller: sq2,
                            ),
                            trailing: IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState3) {
                                          return AlertDialog(
                                            content: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                                  2,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                                  1.3,
                                              child: ListView.builder(
                                                itemCount: que2.length,
                                                itemBuilder: (context, index) {
                                                  return ListTile(
                                                    onTap: () {
                                                      q2_is = que2[index];
                                                      sq2.text = q2_is;
                                                      setState(() {});
                                                      setState3(() {});
                                                      setState2(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    title:
                                                    Text("${que2[index]}"),
                                                  );
                                                },
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                icon: Icon(Icons.arrow_drop_down)),
                          ),
                          TextField(
                            controller: ans2,
                            decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.orange)),
                                labelText: "Answer *"),
                          ),
                        ]),
                      ),
                    ),
                    actionsAlignment: MainAxisAlignment.center,
                    actions: [
                      Container(
                        height: MediaQuery.of(context).size.height / 15,
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Colors.deepPurple)),
                        alignment: Alignment.center,
                        child: Text("EXIT",
                            style: TextStyle(color: Colors.deepPurple)),
                      ),
                      InkWell(
                        onTap: () {
                          AccountPin.prefs!
                              .setString("password", set_pass.text);
                          second_dialog_box();
                        },
                        child: Container(
                          height: MediaQuery.of(context).size.height / 15,
                          width: MediaQuery.of(context).size.width / 3,
                          decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          alignment: Alignment.center,
                          child: Text("SET",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  second_dialog_box() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          titlePadding: EdgeInsets.all(0),
          titleTextStyle: TextStyle(fontSize: 25),
          title: Container(
            height: 50,
            alignment: Alignment.center,
            color: Colors.deepPurple,
            child: Text("Select currency", textAlign: TextAlign.center),
            margin: EdgeInsets.all(0),
          ),
          content: Column(
            children: [
              TextField(
                controller: currncy,
                decoration: InputDecoration(hintText: " Search currency "),
              ),
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                height: MediaQuery.of(context).size.height / 11.5,
                width: MediaQuery.of(context).size.width / 2.8,
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(50),
                ),
                alignment: Alignment.center,
                child: Text("DONE", style: TextStyle(color: Colors.white)),
              ),
            )
          ],
        );
      },
    );
  }

  Widget PassWord_container() {
    return SingleChildScrollView(
      child: Card(
        // color: Colors.black,
        elevation: 20,
        child: Container(
          margin: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height / 2.3,
          width: MediaQuery.of(context).size.width / 1.3,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25)),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 10,
                width: MediaQuery.of(context).size.width / 1.6,
                padding: EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                            color: borders[0]?Colors.white:Colors.black12,
                            shape: BoxShape.circle,
                            border: borders[0]
                                ? Border.all(color: Colors.deepPurple, width: 15)
                                : null)),
                    Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                            color: borders[1]?Colors.white:Colors.black12,
                            shape: BoxShape.circle,
                            border: borders[1]
                                ? Border.all(color: Colors.deepPurple, width: 15)
                                : null)),
                    Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                            color: borders[2]?Colors.white:Colors.black12,
                            shape: BoxShape.circle,
                            border: borders[2]
                                ? Border.all(color: Colors.deepPurple, width: 15)
                                : null)),
                    Container(
                        height: MediaQuery.of(context).size.height / 18,
                        width: MediaQuery.of(context).size.width / 10,
                        decoration: BoxDecoration(
                            color: borders[3] ? Colors.white : Colors.black12,
                            shape: BoxShape.circle,
                            border: borders[3]
                                ? Border.all(
                                    color: Colors.deepPurple, width: 15)
                                : null)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  number_button("1"),
                  number_button("2"),
                  number_button("3"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  number_button("4"),
                  number_button("5"),
                  number_button("6"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  number_button("7"),
                  number_button("8"),
                  number_button("9"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height / 12,
                    width: MediaQuery.of(context).size.width / 4.5,
                    child: IconButton(
                        onPressed: () {
                          if (pass.isNotEmpty && pass.length != 5) {
                            borders[pass.length - 1] = false;
                            pass.removeAt(pass.length - 1);
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: Colors.deepPurple,
                        )),
                  ),
                  number_button("0"),
                  InkWell(
                    onTap: () {
                      print(pass.length);
                      if (pass.length == 4) {
                        for (int i = 0; i < set_pass.text.length; i++) {
                          if (pass[i] == set_pass.text[i]) {
                            pass_is_metch = true;
                          } else {
                            pass_is_metch = false;
                            break;
                          }
                        }
                      } else {
                        pass_is_metch = false;
                      }

                      print("pass_is_metch := ${pass_is_metch}");

                      if (pass_is_metch) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                          return DashBoard();
                        },));
                      } else {
                        print("password is not match");
                      }
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 12,
                      width: MediaQuery.of(context).size.width / 4.5,
                      alignment: Alignment.center,
                      child: Text("OK",
                          style:
                              TextStyle(fontSize: 20, color: Colors.deepPurple)),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget number_button(String data) {
    return InkWell(
      onTap: () {
        if (pass.length != 4) {
          pass.add(data);
          for (int i = 0; i < pass.length; i++) {
            borders[i] = true;
          }
        }
        setState(() {});
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        width: MediaQuery.of(context).size.width / 4.5,
        // color: Colors.white60,
        alignment: Alignment.center,
        child: Text("${data}",
            style: TextStyle(fontSize: 20, color: Colors.black45)),
      ),
    );
  }
}
