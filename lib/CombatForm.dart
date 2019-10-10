import 'package:dice_roller/CombatCalculator.dart';
import 'package:dice_roller/CombatProperties.dart';
import 'package:dice_roller/CommonUtil.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';

class CombatForm extends StatefulWidget {
  CombatForm({Key key}) : super(key: key);

  @override
  _CombatFormState createState() => _CombatFormState();
}

typedef void SetValue(bool valueToChange);

class _CombatFormState extends State<CombatForm> {
  final _formKey = GlobalKey<FormState>();

  static AudioCache player = new AudioCache();
  String finalResultDamage = "0";

  CombatProperties combatProperties;

  CombatProperties getCombatProperties() {
    if (combatProperties == null) {
      combatProperties = new CombatProperties();
    }
    return combatProperties;
  }

  void calculateDamage() {
    const alarmAudioPath = "rollthedice.mp3";
    player.play(alarmAudioPath);
    finalResultDamage =
        CombatCalculator.calculateDamage(getCombatProperties()).toString();
    setState(() {});
  }

  Widget getPaddingWidget(Widget childWidget) {
    return new Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[Expanded(child: childWidget)],
        ),
      ),
    ));
  }

  Widget getCalcButton() {
    var submitButton = RaisedButton(
      onPressed: calculateDamage,
      child: Text('Calculate Damage'),
    );
    return getPaddingWidget(submitButton);
  }

  Widget getAttacksWidget() {
    var formField = new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Attacks are required';
          }
          return null;
        },
        decoration: InputDecoration(labelText: "Attacks", hintText: "4"),
        onChanged: (String value) {
          if (value.contains("d")) {
            if (value.contains("d3")) {
              getCombatProperties().attacks = CommonUtil.rollD3();
            }

            if (value.contains("d6")) {
              getCombatProperties().attacks = CommonUtil.rollD6();
            }
          } else {
            getCombatProperties().attacks = int.parse(value);
          }
        });

    return getPaddingWidget(formField);
  }

  Widget getHitWidget() {
    var formField = new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Hit is required';
          }

          return null;
        },
        decoration: InputDecoration(labelText: "Hit+", hintText: "4+"),
        onChanged: (String value) {
          getCombatProperties().hit = int.parse(value);
        });

    return getPaddingWidget(formField);
  }

  Widget getWoundWidget() {
    var formField = new TextFormField(
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Wound';
          }
          return null;
        },
        decoration: InputDecoration(labelText: "Wound+", hintText: "4+"),
        onChanged: (String value) {
          getCombatProperties().wound = int.parse(value);
        });

    return getPaddingWidget(formField);
  }

  Widget getRendWidget() {
    var formField = new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Rend';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Rend-", hintText: "2"),
        onChanged: (String value) {
          getCombatProperties().rend = int.parse(value);
        });

    return getPaddingWidget(formField);
  }

  Widget getDamageWidget() {
    var formField = new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Damage';
          }
          return null;
        },
        decoration: InputDecoration(labelText: "Damage", hintText: "d6"),
        onChanged: (String value) {
          getCombatProperties().damage = value;
        });

    return getPaddingWidget(formField);
  }

  Widget getSaveWidget() {
    var formField = new TextFormField(
        validator: (value) {
          if (value.isEmpty) {
            return 'Enter Save';
          }
          return null;
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Save+"),
        onChanged: (String value) {
          getCombatProperties().save = int.parse(value);
        });

    return getPaddingWidget(formField);
  }

  Widget getTotalDamage() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Total Damage:", textScaleFactor: .75),
        Text(finalResultDamage, textScaleFactor: 1.75),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingWoundOnesCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Wounds of 1", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollWoundOnes,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollWoundOnes = outValue;
              if (outValue) {
                getCombatProperties().rerollWounds = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingWoundCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Failed Wounds", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollWounds,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollWounds = outValue;
              if (outValue) {
                getCombatProperties().rerollWoundOnes = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingHitOnesCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Hits of 1", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollHitOnes,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollHitOnes = outValue;
              if (outValue) {
                getCombatProperties().rerollHits = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingHitCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Failed Hits", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollHits,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollHits = outValue;
              if (outValue) {
                getCombatProperties().rerollHitOnes = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingSaveOnesCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Saves of 1", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollSaveOnes,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollSaveOnes = outValue;
              if (outValue) {
                getCombatProperties().rerollSaves = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  Widget getRerollingSaveCheckBox() {
    var widget = new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text("Reroll Failed Saves", textScaleFactor: .75),
        Checkbox(
          value: getCombatProperties().rerollSaves,
          onChanged: (bool outValue) {
            setState(() {
              getCombatProperties().rerollSaves = outValue;
              if (outValue) {
                getCombatProperties().rerollSaveOnes = false;
              }
            });
          },
        ),
      ],
    );
    return getPaddingWidget(widget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0),
            child: AppBar(
              title: Text('Gloomspite Dice Roller'),
              centerTitle: true,
            )),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage("images/gloomspite.jpg"),
            fit: BoxFit.cover,
          )),
          child: GridView.count(
              // Create a grid with 2 columns. If you change the scrollDirection to
              // horizontal, this produces 2 rows.
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 2,
              childAspectRatio: 2,
              children: <Widget>[
                getAttacksWidget(),
                getHitWidget(),
                getWoundWidget(),
                getRendWidget(),
                getDamageWidget(),
                getSaveWidget(),
                getRerollingWoundOnesCheckBox(),
                getRerollingWoundCheckBox(),
                getRerollingHitOnesCheckBox(),
                getRerollingHitCheckBox(),
                getRerollingSaveOnesCheckBox(),
                getRerollingSaveCheckBox(),
                getCalcButton(),
                getTotalDamage()
              ]),
        ));
  }
}
