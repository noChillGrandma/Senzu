import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_breakfast.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_dinner.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_lunch.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_snacks.dart';
import 'package:senzu_app/screens/food_tracker/ui/nutrient_stats.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/screens/top_foods/top_foods_list.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/widgets/user_goals.dart';

class FoodTracker extends StatefulWidget {
  FoodTracker({Key key}) : super(key: key);

  @override
  _FoodTrackerState createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {

  @override  
  void initState() {  
    super.initState();  
  } 


  int _selectedIndex = 0;


    // static const TextStyle optionStyle =
    //   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static List<Widget> _widgetOptions = <Widget>[
    FoodOverview(),
    NutrientStats(),
    TopFoodsList(),
  ];

    void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Food',
          style: titleTextStyle,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: BottomNavigationBar(
            backgroundColor: Color(0xFF1e1f38),
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(FontAwesomeIcons.utensils),
                label: 'Food'
                ),
                BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.chartPie),
                label: 'Stats'
                ),
                BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.trophy),
                label: 'Top Foods'
                ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: primaryButtonColor,
            onTap: _onItemTapped,
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        // body: FoodOverview(),
        backgroundColor: primaryBackgroundColor,
      ),
    );
  }
} 



class FoodOverview extends StatefulWidget {

  @override
  _FoodOverviewState createState() => _FoodOverviewState();
}

class _FoodOverviewState extends State<FoodOverview> {

  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();

  Color _rightArrowColour = Color(0xffC1C1C1);




  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodEntries')
        .where("dateAdded", isEqualTo: currentDate)
        .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.data == null) 
          return Center(child: loadingWidget);
            final documents = snapshot.data.docs;
            final totalCaloriesSum = documents.fold(0, (s, n) => s + n['calories']);
            final breakfastCaloriesSum = documents.fold(0, (s, n) => s + n['breakfastCalories']);
            final lunchCaloriesSum = documents.fold(0, (s, n) => s + n['lunchCalories']);
            final snacksCaloriesSum = documents.fold(0, (s, n) => s + n['snacksCalories']);
            final dinnerCaloriesSum = documents.fold(0, (s, n) => s + n['dinnerCalories']);
            final carbsSum = documents.fold(0, (s, n) => s + n['totalCarbohydrate']);
            final fatSum = documents.fold(0, (s, n) => s + n['totalFat']);
            final proteinSum = documents.fold(0, (s, n) => s + n['protein']);

          fatPercentage() {
            var fatPercentage = fatSum / totalFatDailyValue;
            return fatPercentage;
          }
          carbsPercentage() {
            var carbsPercentage = carbsSum / totalCarbohydrateDailyValue;
            return carbsPercentage;
          }
          proteinPercentage() {
            var proteinPercentage = proteinSum / proteinDailyValue;
            return proteinPercentage;
          }


        return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
              child: Column(
                children: <Widget>[

                // Date picker 
                Row(
                  children: <Widget>[
                  // Left edge box
                  SizedBox(height: 10, width: 10,),

                  // Back 1 day arrow
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 25.0),
                    color: Colors.grey,
                    onPressed: () {
                      setState(() {
                        _value = _value.subtract(Duration(days: 1));
                        currentDate = currentDate.subtract(Duration(days: 1));
                        _rightArrowColour = Colors.grey;
                      });
                    },
                  ),

                  // Date picker pill shape
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(primaryButtonColor),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                        )
                      ),
                      onPressed: () => _selectDate(),
                      child: Text(_dateFormatter(_value),
                      style: TextStyle(
                        fontFamily: 'Open Sans',
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      )),
                    ),
                  ),

                  // forward 1 day arrow (disabled if date picker is on current date)
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 25.0),
                    color: _rightArrowColour,
                    onPressed: () {
                      if (today.difference(_value).compareTo(Duration(days: 1)) == -1)  {
                        setState(() {
                          _rightArrowColour = Colors.grey[900];
                        });
                      } else {
                        setState(() {
                          _value = _value.add(Duration(days: 1));
                        });
                        if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
                          setState(() {
                            _rightArrowColour = Colors.grey[900];
                          });
                        }
                      }
                      
                      if (today.difference(currentDate).compareTo(Duration(days: 1)) == -1)  {
                        setState(() {
                          _rightArrowColour = Colors.grey[900];
                        });
                      } else {
                        setState(() {
                          currentDate = currentDate.add(Duration(days: 1));
                        });
                        if (today.difference(currentDate).compareTo(Duration(days: 1)) == -1) {
                          setState(() {
                            _rightArrowColour = Colors.grey[900];
                          });
                          
                        }
                      }
                    }
                  ),

                  // Right edge box
                  SizedBox( height: 10, width: 20,),        
                  ],
                ),
                // Intake vs Target totals
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                  // Total intake for that day
                  Text('$totalCaloriesSum', style: textColor.copyWith(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    child: Text('/', style: textColor.copyWith(fontSize: 30)),
                  ),

                  // Calorie target from Firestore
                  dailyCalories(context),
                  ],
                ),
              ],
            ),
          ),

          // 'Add meals' overview panel

          Container(
            // padding: EdgeInsets.fromLTRB(15, 15.0, 15.0, 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 190,
                          width: 180,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Color(0xFF1e1f38),
                            child: InkWell(
                              splashColor: Color(0xFF2b2c4a),
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddToBreakfast(selectedDateValue: currentDate,)
                                  ));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,5,0),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20.0),
                                          splashColor: Colors.grey,
                                          onTap: () {
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AddToBreakfast(selectedDateValue: currentDate,)
                                              ));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 35,
                                            color: Color(0xFFc5c5c5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                        image: const AssetImage('assets/meal_icons/breakfast_medium.png')),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Breakfast',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 20
                                            ),),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('🔥 $breakfastCaloriesSum kcal',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 18
                                            ),),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,5),
                                    ),
                                  ],
                                  ),
                              ),
                              ),
                        ),
                        SizedBox(
                          height: 190,
                          width: 180,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Color(0xFF1e1f38),
                            child: InkWell(
                              splashColor: Color(0xFF2b2c4a),
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddToLunch(selectedDateValue: currentDate,)
                                  ));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,5,0),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20.0),
                                          splashColor: Colors.grey,
                                          onTap: () {
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AddToLunch(selectedDateValue: currentDate,)
                                              ));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 35,
                                            color: Color(0xFFc5c5c5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                        image: const AssetImage('assets/meal_icons/lunch_medium.png')),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Lunch',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 20
                                            ),)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('🔥 $lunchCaloriesSum kcal',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 18
                                            ),),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,5),
                                    ),
                                  ],
                                ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 190,
                          width: 180,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Color(0xFF1e1f38),
                            child: InkWell(
                              splashColor: Color(0xFF2b2c4a),
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddToSnacks(selectedDateValue: currentDate,)
                                  ));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,5,0),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20.0),
                                          splashColor: Colors.grey,
                                          onTap: () {
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AddToSnacks(selectedDateValue: currentDate,)
                                              ));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 35,
                                            color: Color(0xFFc5c5c5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                        image: const AssetImage('assets/meal_icons/snacks_medium.png')),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Snacks',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 20
                                            ),)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('🔥 $snacksCaloriesSum kcal',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 18
                                            ),),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,5),
                                    ),
                                  ],
                                ),
                            ),
                            ),
                        ),
                        SizedBox(
                          height: 190,
                          width: 180,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: Color(0xFF1e1f38),
                            child: InkWell(
                              splashColor: Color(0xFF2b2c4a),
                              borderRadius: BorderRadius.circular(20.0),
                              onTap: () {
                                Future.delayed(Duration(milliseconds: 200), () {
                                  Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => AddToDinner(selectedDateValue: currentDate,)
                                  ));
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(0,5,5,0),
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(20.0),
                                          splashColor: Colors.grey,
                                          onTap: () {
                                            Future.delayed(Duration(milliseconds: 200), () {
                                              Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AddToDinner(selectedDateValue: currentDate,)
                                              ));
                                            });
                                          },
                                          child: Icon(
                                            Icons.add_circle_outline_rounded,
                                            size: 35,
                                            color: Color(0xFFc5c5c5),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Image(
                                        height: 80,
                                        fit: BoxFit.fitHeight,
                                        image: const AssetImage('assets/meal_icons/dinner_medium.png')),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Dinner',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 20
                                            ),)
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('🔥 $dinnerCaloriesSum kcal',
                                          style: TextStyle(
                                              color: Color(0xFFc5c5c5),
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 18
                                            ),),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0,0,0,5),
                                    ),
                                  ],
                                ),
                            ),
                            ),
                        ),
                      ],
                    ),
                  ],
                )
                  ],
                ),
              ),

              // Nutrient intake summary panel
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Detailed Nutrients', style: textColor.copyWith(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Builder(
                    builder: (BuildContext context){
                      if (carbsPercentage() > 1) {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: 1.0,
                              center: Text("${(carbsPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.red,
                            ),
                            Text('Carbs',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),

                          ],
                        );
                        
                      } else {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: carbsPercentage(),
                              center: Text("${(carbsPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.green,
                            ),
                            Text('Carbs',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),

                          ],
                        );
                      }
                    }),
                    Builder(
                    builder: (BuildContext context){
                      if (proteinPercentage() > 1) {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: 1.0,
                              center: Text("${(proteinPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.green,
                            ),
                            Text('Protein',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        );
                        
                      } else {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: proteinPercentage(),
                              center: Text("${(proteinPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.green,
                            ),
                            Text('Protein',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),

                          ],
                        );
                      }
                    }),

                  Builder(
                    builder: (BuildContext context){
                      if (fatPercentage() > 1) {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: 1.0,
                              center: Text("${(fatPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.red,
                            ),
                            Text('Fat',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),

                          ],
                        );
                        
                      } else {
                        return Column(
                          children: [
                            CircularPercentIndicator(
                              circularStrokeCap: CircularStrokeCap.round,
                              radius: 80.0,
                              lineWidth: 13.0,
                              percent: fatPercentage(),
                              center: Text("${(fatPercentage() * 100).toStringAsFixed(0)}%",
                              style: textColor.copyWith(fontWeight: FontWeight.bold)),
                              progressColor: Colors.green,
                            ),
                            Text('Fat',
                            style: textColor.copyWith(fontWeight: FontWeight.bold)),

                          ],
                        );
                      }
                    }),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
              SizedBox(
                    height: 6,
                  ),

              // Nutrients intake values
              _nutrientsTotal(),
            ],
          ),
        ),
      ),
    );
          },
    );
  }

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: _value,
        firstDate: new DateTime(2015),
        lastDate: new DateTime.now(),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData().copyWith(
            primaryColor: Colors.black,
            backgroundColor: Colors.yellow,
            shadowColor: Colors.black,
            colorScheme: ColorScheme.light(primary: Colors.grey[900]),
            buttonTheme: ButtonThemeData(
              textTheme: ButtonTextTheme.primary
            ),
          ),
          child: child,
        );
      },
    );
    if(picked != null) setState(() => _value = picked);
    _stateSetter();
  }


  void _stateSetter() {
    if (today.difference(_value).compareTo(Duration(days: 1)) == -1) {
      setState(() => _rightArrowColour = Colors.grey);
    } else
      setState(() => _rightArrowColour = Colors.grey);
  }


  String _dateFormatter(DateTime tm) {
    DateTime today = new DateTime.now();
    Duration oneDay = new Duration(days: 1);
    Duration twoDay = new Duration(days: 2);
    String month;
    switch (tm.month) {
      case 1 : month = "Jan";
        break;
      case 2 :month = "Feb";
        break;
      case 3 :month = "Mar";
        break;
      case 4 :month = "Apr";
        break;
      case 5 :month = "May";
        break;
      case 6 : month = "Jun";
        break;
      case 7 : month = "Jul";
        break;
      case 8 : month = "Aug";
        break;
      case 9 : month = "Sep";
        break;
      case 10 : month = "Oct";
        break;
      case 11 : month = "Nov";
        break;
      case 12 : month = "Dec";
        break;
    }

    Duration difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return "Today";
    } else if (difference.compareTo(twoDay) < 1) {
      return "Yesterday";
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }


Widget _nutrientsTotal() {
  return StreamBuilder(
    stream: dbUsersCollection
      .doc(myUID(context))
      .collection('foodEntries')
      .where("dateAdded", isEqualTo: currentDate)
      .snapshots(),
    builder: _buildNutrientsTotal,
    );
}


Widget _buildNutrientsTotal(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if(snapshot.data == null) 
    return loadingWidget;

  final documents = snapshot.data.docs;
  final proteinSum = documents.fold(0, (s, n) => s + n['protein']);
  final dietaryFiberSum = documents.fold(0, (s, n) => s + n['dietaryFiber']);
  final potassiumSum = documents.fold(0, (s, n) => s + n['potassium']);
  final vitaminASum = documents.fold(0, (s, n) => s + n['vitaminA']);
  final vitaminCSum = documents.fold(0, (s, n) => s + n['vitaminC']);
  final vitaminDSum = documents.fold(0, (s, n) => s + n['vitaminD']);
  final calciumSum = documents.fold(0, (s, n) => s + n['calcium']);
  final ironSum = documents.fold(0, (s, n) => s + n['iron']);
  final saturatedFatSum = documents.fold(0, (s, n) => s + n['saturatedFat']);
  final sodiumSum = documents.fold(0, (s, n) => s + n['sodium']);
  final magnesiumSum = documents.fold(0, (s, n) => s + n['magnesium']);
  final zincSum = documents.fold(0, (s, n) => s + n['zinc']);

  return Container(
    padding: EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
    child: Column(
      children: <Widget>[
        Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (proteinSum > proteinDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Protein', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${proteinSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${proteinDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (dietaryFiberSum > dietaryFiberDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Dietary Fiber', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${dietaryFiberSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${dietaryFiberDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (potassiumSum > potassiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Potassium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${potassiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${potassiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminASum > vitaminADailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin A', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminASum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminADailyValue}mcg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminCSum > vitaminCDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin C', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminCSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminCDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminDSum > vitaminDDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin D', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminDSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminDDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (calciumSum > calciumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Calcium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${calciumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${calciumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (ironSum > ironDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Iron', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${ironSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${ironDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (saturatedFatSum == 0) {
                        return lowIntakeIcon;
                      } if (saturatedFatSum < saturatedFatDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Saturated Fat', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${saturatedFatSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${saturatedFatDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (sodiumSum == 0) {
                        return lowIntakeIcon;
                      } if (sodiumSum < sodiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Sodium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${sodiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${sodiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (sodiumSum == 0) {
                        return lowIntakeIcon;
                      } if (sodiumSum < sodiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Magnesium(placeholder)', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${magnesiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${magnesiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (sodiumSum == 0) {
                        return lowIntakeIcon;
                      } if (sodiumSum < sodiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Zinc(placeholder)', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${zincSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${zincDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(child: lowIntakeIcon,),
                      Text(' Low intake', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: goodIntakeIcon,),
                      Text(' Average', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: highIntakeIcon,),
                      Text(' High intake', style: textColor),
                    ]
                  ),
                ),
              ]),
            );
  }


   void saveNestedData() {
    dbUsersCollection
      .doc(myUID(context))
      .collection('foodEntries')
      .add({
      "foodId": '',
      "foodName": "foodName",
      "mealType": "dinner",
      "protein":  0,
      "dietaryFiber":  0,
      "potassium":  0,
      "vitaminA":  0,
      "vitaminC":  0,
      "calcium":  0,
      "iron": 0,
      "saturatedFat": 0,
      "sodium": 0,
      "sugars": 0,
      "dateAdded": currentDate,
    });
  }


}