import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/screens/authentication/utils/snackbar.dart';
import 'package:senzu_app/shared/constants.dart';

class NutritionGoals extends StatefulWidget {
  NutritionGoals({Key key}) : super(key: key);

  @override
  _NutritionGoalsState createState() => _NutritionGoalsState();
}

class _NutritionGoalsState extends State<NutritionGoals> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrition Goals'),
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
      ),
      body: nutritionGoalsBody(),
      backgroundColor: primaryBackgroundColor,
    );
  }

Widget nutritionGoalsBody(){

    return StreamBuilder(
    stream: dbUsersCollection
      .doc(myUID(context))
      .snapshots(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
      if (!snapshot.hasData) {
        return Text("Loading");
      }

      final documents = snapshot.data;
      final dailyCaloriesGoal = documents.get('dailyCaloriesGoal');
      final usernameController = TextEditingController(text: dailyCaloriesGoal.toString());
      // return Text(username.toString());
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Daily Calories Goal: ',
                style: textColor.copyWith(fontSize: 20),),
                SizedBox(
                  width: 70,
                  height: 40,
                  child: TextFormField(
                    style: textColor.copyWith(fontSize: 18),
                    decoration: textInputDecoration,
                    controller: usernameController,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: primaryButtonColor
            ),
            child: MaterialButton(
              onPressed: () async {
                try {
                  dbUsersCollection
                    .doc(myUID(context))
                    .update({'dailyCaloriesGoal': usernameController.text});
                    CustomSnackBar(context, const Text('Daily calories intake goal updated successfully!'));
                } catch (e) {
                }
              },
              child: Text('Update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      );
    }
  );
}

}