import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Review extends StatefulWidget {
  const Review({super.key, 
    required this.chargerId,
    required this.chargerName,
  });
  final String chargerId;
  final String chargerName;

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> {
  double rating = 3;
  final commentFocusNode = FocusNode();
  TextEditingController commentController = TextEditingController();
  final CollectionReference reviewCollection =
      FirebaseFirestore.instance.collection('reviews');

  //submitting function.......................................................
  void submit() {
    print("rating is : $rating");
    print("comment is : ${commentController.text}");

    reviewCollection.add({
      'chargerId': widget.chargerId,
      'chargerName': widget.chargerName,
      'ratings': rating,
      'suggestion': commentController.text,
    }).then((value) {
      print('Data stored successfully in Firestore');
      Navigator.pop(context);
    }).catchError((error) {
      print('Failed to store data in Firestore: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Review',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: ColorManager.primary,
      ),
      body: Container(
        width: width * 0.96,
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //column 1 - Text......................................................
            const Center(
              child: Text(
                "How likely would you recommend EVFI to a friend or a colleague?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: AppSize.s28,
                    fontFamily: 'fonts/Poppins'),
              ),
            ),
            const SizedBox(height: 15),
            //column 2 - Stars......................................................
            Center(
              child: RatingBar.builder(
                initialRating: rating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (value) {
                  rating = value;
                },
              ),
            ),
            const SizedBox(height: 60),
            //column 3 - textarea......................................................
            const Padding(
              padding: EdgeInsets.only(left: 5, bottom: 5),
              child: Text('Comment(optional)',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'fonts/Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: AppSize.s18,
                  )),
            ),
            const SizedBox(height: 2),
            Card(
              elevation: 4,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: TextFormField(
                controller: commentController,
                style: TextStyle(color: ColorManager.darkGrey),
                decoration: const InputDecoration(
                    hintText: 'Enter your message',
                    fillColor: Colors.white,
                    filled: true,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    )),
                focusNode: commentFocusNode,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
              ),
            ),
            const SizedBox(height: 40),
            //column 4 - submit......................................................
            GestureDetector(
              onTap: submit,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.065,
                width: MediaQuery.of(context).size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: ColorManager.primary,
                ),
                child: const Center(
                  child: Text(
                    'Send',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: AppSize.s18,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'fonts/Poppins',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
