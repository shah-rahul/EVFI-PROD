// ignore_for_file: use_build_context_synchronously, prefer_const_constructors
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evfi/presentation/login/login.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/my_chargers.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/payments.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/user_profile.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/profilesection.dart';
import 'package:evfi/presentation/pages/screens/4accountPage/settings.dart';
import 'package:evfi/presentation/resources/color_manager.dart';
import 'package:evfi/presentation/resources/values_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'new_station.dart';

String username = "";
String firstname = "";
String lastname = "";
String phoneNo = "";
File? clickedImage;
String country = "";
String state = "";
String city = "";
String pincode = "";
String imageurl = "";
bool isProvider = false;
List<dynamic> chargers = [];

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      try {
        String imageUrl = await _uploadImageToFirebase(imageFile);
        await _updateUserImageUrl(imageUrl);
        imageurl = imageUrl;
        setState(() {});
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
  }

    Future<String> _uploadImageToFirebase(File imageFile) async {
    String fileName = 'profile_${auth.currentUser!.uid}.jpg';
    Reference ref = _storage.ref().child('profile_images').child(fileName);
    UploadTask uploadTask = ref.putFile(imageFile);
    TaskSnapshot taskSnapshot = await uploadTask;
    return await taskSnapshot.ref.getDownloadURL();
  }

  Future<void> _updateUserImageUrl(String imageUrl) async {
    await _firestore.collection('user').doc(auth.currentUser!.uid).update({
      'imageUrl': imageUrl,
    });
  }

  @override
  void initState() {
    super.initState();
    auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        // User is signed in, fetch user data from Firestore
        _fetchUserData(user.uid);
        print("I am fetching data");
        setState(() {});
      }
    });
  }

  Future<void> _fetchUserData(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('user').doc(userId).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      setState(() {
        _user = auth.currentUser;
        username = userData['firstName'];
        phoneNo = userData['phoneNumber'];
        firstname = userData['firstName'];
        lastname = userData['lastName'];
        country = userData['country'];
        state = userData['state'];
        city = userData['city'];
        pincode = userData['pinCode'];
        imageurl = userData["imageUrl"];
        isProvider = userData["level3"];
        chargers = userData["chargers"];
        print("In fetching block");
        print('username is : ${username}');
        print('phone number is :${phoneNo}');
      });
    } catch (e) {
      print('Error fetching user data: $e');
      print("In error block");
      print(e);
    }
  }

//........EDIT PROFILE.....................................................................
  void editProfile() async {
    final newDetails =
        await Navigator.of(context).push<UserProfile>(MaterialPageRoute(
      builder: (context) => EditProfileScreen(
        phoneNo: phoneNo,
        firstname: firstname,
        lastname: lastname,
        country: country,
        state: state,
        city: city,
        pincode: pincode,
      ),
    ));
    if (newDetails == null) {
      return;
    }
    setState(() {
      username = newDetails.name;
    });
  }

  void clickPayment() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const PaymentScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Section',
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontFamily: 'fonts/Poppins'),
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: width * 0.96,
        margin: EdgeInsets.symmetric(
            horizontal: width * 0.02, vertical: height * 0.02),
        padding: EdgeInsets.all(width * 0.02),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //...................PROFILE....................................................................
            profileSection(context),
            SizedBox(height: height * 0.015),
            //....................BUTTONS IN ROW............................................................
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                serviceSection(context, Icons.lightbulb_outline, 'Chargers'),
                GestureDetector(
                    onTap: clickPayment,
                    child:
                        serviceSection(context, Icons.credit_card, 'Payments')),
                serviceSection(context, Icons.drive_eta, 'Bookings'),
              ],
            ),
            //.............................COLUMN BUTTONS...................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              onTap: () {
                editProfile();
              },
              child: settingSection(
                  context, Icons.person_2_outlined, 'Edit Profile'),
            ),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
                onTap: _addStation,
                child: settingSection(
                    context, Icons.location_on_outlined, 'Add Station')),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            settingSection(context, Icons.contact_support_outlined, 'Support'),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              child: settingSection(context, Icons.settings, 'Settings'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ));
              },
            ),
            //..............................................................................................
            SizedBox(height: height * 0.015),
            GestureDetector(
              onTap: () async {
                await signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              },
              child: settingSection(context, Icons.logout, 'Logout'),
            ),
          ],
        ),
      ),
    );
  }

//..............ADD STATION AND SIGNOUT METHODS.................................................
  void _addStation() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.amberAccent[80],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      builder: (_) => GestureDetector(
        onTap: null,
        behavior: HitTestBehavior.opaque,
        child: const NewStation(),
      ),
    );
  }

  signOut() async {
    await auth.signOut();
    var sharedPref = await SharedPreferences.getInstance();
    await sharedPref.clear();
  }
}

//..............................................................................................
//......PROFILE SECTION.........................................................................

Widget profileSection(BuildContext context) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  Widget content = (imageurl == "")
      ? CircleAvatar(
          radius: height * 0.06,
          backgroundImage: AssetImage('assets/images/map/carphoto.jpeg'),
        )
      : CachedNetworkImage(
          imageUrl: imageurl,
          imageBuilder: (context, imageProvider) => CircleAvatar(
            radius: height * 0.06,
            backgroundImage: imageProvider,
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        );

  return Card(
    elevation: 4,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Container(
      padding: EdgeInsetsDirectional.all(width * 0.02),
      height: height * 0.13,
      decoration: BoxDecoration(
        // color: Colors.black,
        // boxShadow: [BoxShadow(blurRadius: 5,spreadRadius: 5,color: ColorManager.primary, offset: Offset(2, 2))],
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(width: 1.5, color: Colors.black26),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //1st row.....................................
          Stack(
            children: [
              content,
              Positioned(
                bottom: height * 0.01,
                left: width * 0.2,
                child: GestureDetector(
                  onTap: () => _AccountState()._pickImageFromGallery(),
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: ColorManager.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          //2nd row.....................................
          SizedBox(width: width * 0.05),
          //3rd row.....................................
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Hey ${username}!",
                  style: const TextStyle(
                      fontSize: AppSize.s20,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'fonts/Poppins')),
              Text('ID: ${phoneNo}',
                  style: const TextStyle(
                      fontSize: AppSize.s16,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'fonts/Poppins')),
            ],
          ),
          //4th row.....................................
          Spacer(),
        ],
      ),
    ),
  );
}

//..............................................................................................
//......SERVICE SECTION.........................................................................

Widget serviceSection(BuildContext context, IconData icon, String str) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return GestureDetector(
    onTap: () {
      if (str == "Chargers") {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MyChargersScreen(
            chargers: chargers,
          ),
        ));
      }
    },
    child: Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Container(
        padding: EdgeInsetsDirectional.all(width * 0.03),
        width: width * 0.28,
        height: height * 0.11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.02),
          border: Border.all(width: 1.5, color: Colors.black26),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: ColorManager.primary,
              size: height * 0.05,
            ),
            Spacer(),
            Text(str,
                style: const TextStyle(
                    fontSize: AppSize.s14,
                    fontWeight: FontWeight.w800,
                    fontFamily: 'fonts/Poppins')),
          ],
        ),
      ),
    ),
  );
}

//..............................................................................................
//......SETTING SECTION.........................................................................

Widget settingSection(BuildContext context, IconData icon, String str) {
  final width = MediaQuery.of(context).size.width;
  final height = MediaQuery.of(context).size.height;

  return Card(
    elevation: 4,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: width * 0.05),
      height: height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.02),
        border: Border.all(width: 1.5, color: Colors.black26),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: ColorManager.primary,
            size: height * 0.04,
          ),
          SizedBox(width: width * 0.03),
          Text(str,
              style: const TextStyle(
                  fontSize: AppSize.s16,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'fonts/Poppins')),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: ColorManager.primary,
          ),
        ],
      ),
    ),
  );
}
