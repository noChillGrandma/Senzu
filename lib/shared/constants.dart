import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

const textInputDecoration = InputDecoration(
  fillColor: Color(0xFF1e1f38),
  filled: true,
  hintStyle: textColor,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryButtonColor, width: 2.0,),
  ),
);


const textColor = TextStyle(color: Color(0xFFE0E0E0));

const titleTextStyle = TextStyle(
  color: Color(0xFFE0E0E0),
  fontSize: 24
);

Widget addMealCard(BuildContext context){
  return Card(
    color: Color(0xFF00C853),
    child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/select_food_test');
      },
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Text(''),
      ),
    ),
  );
}
Widget addMealButton(BuildContext context){
  return ElevatedButton(
    onPressed: () {
      Navigator.pushNamed(context, '/select_food_test');
    }, 
    child: Icon(
      Icons.ac_unit
      )
    );
}

const nutrientsDivider = Divider(
  color: Color(0xFF757575),
  indent: 10,
  endIndent: 10,
  thickness: 1.5,
);


const lowIntakeIcon = Icon(
  Icons.circle,
  color: Color(0xFFFDD835),
  size: 14,
);

const goodIntakeIcon = Icon(
  Icons.circle,
  color: Colors.green,
  size: 14,
);

const highIntakeIcon = Icon(
  Icons.circle,
  color: Colors.red,
  size: 14,
);

const primaryButtonColor = Color(0xFF29d990);

const primaryBackgroundColor = Color(0xFF121322);


final breakfastTitleCard = Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  color: Color(0xFF1e1f38),
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
    child: Text('Breakfast',
      style: textColor.copyWith(fontSize: 25, fontWeight: FontWeight.bold),),
    ),
  );

final lunchTitleCard = Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  color: Color(0xFF1e1f38),
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
    child: Text('Lunch',
      style: textColor.copyWith(fontSize: 25, fontWeight: FontWeight.bold),),
    ),
  );

final snacksTitleCard = Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  color: Color(0xFF1e1f38),
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
    child: Text('Snacks',
      style: textColor.copyWith(fontSize: 25, fontWeight: FontWeight.bold),),
    ),
  );

final dinnerTitleCard = Card(
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  ),
  color: Color(0xFF1e1f38),
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 4, 20, 4),
    child: Text('Dinner',
      style: textColor.copyWith(fontSize: 25, fontWeight: FontWeight.bold),),
    ),
  );

const loadingWidget = SpinKitDoubleBounce(
    color: Colors.white,
  );

const borderColor = Color(0xFFE0E0E0);

const foodDetailsBorderColor = Color(0xFFE0E0E0);

const thinDivider = Divider(height: 10, thickness: 1, color: Color(0xFFE0E0E0),);

const semiThickDivider = Divider(height: 0, thickness: 5, color: Color(0xFFE0E0E0),);

const notBoldTextOnLabel = TextStyle(
  color: Color(0xFFE0E0E0),
  fontSize: 18, 
  fontWeight: FontWeight.w500
);

const boldTextOnLabel = TextStyle(
  color: Color(0xFFE0E0E0),
  fontWeight: FontWeight.w900, 
  fontSize: 18,
);

final dbUsersCollection = FirebaseFirestore.instance.collection('users');

final dbFoodsCollection = FirebaseFirestore.instance.collection('foods');

final db = FirebaseFirestore.instance;


myUID(BuildContext context){
  var user = Provider.of<User>(context, listen: false);
  var myUID = user.uid;

  return myUID;
}

