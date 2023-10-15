// ignore_for_file: duplicate_import

import 'dart:async';
import 'dart:io';

import 'package:evfi/presentation/pages/screens/2Bookings/BookingsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/pricing_model.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:time_interval_picker/time_interval_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../models/encode_geohash.dart';
import '../../../resources/color_manager.dart';
import '../../../storage/UserChargingData.dart';
import '../../../storage/UserChargingData.dart';
import '../../../storage/UserChargingData.dart';
import '../../../storage/UserChargingDataProvider.dart';
import 'package:evfi/presentation/resources/font_manager.dart';
import 'package:evfi/presentation/pages/models/header_ui.dart';
import 'package:evfi/presentation/resources/assets_manager.dart';
import 'package:evfi/presentation/storage/UserChargingDataProvider.dart';
import 'package:evfi/presentation/pages/screens/3Chargings/MyChargingScreen.dart';
import 'package:evfi/presentation/resources/values_manager.dart';

class ListChargerForm extends StatefulWidget {
  const ListChargerForm({Key? key}) : super(key: key);

  @override
  State<ListChargerForm> createState() => _ListChargerFormState();
}

class _ListChargerFormState extends State<ListChargerForm> {
  // Chargers charger = Chargers();
  late GoogleMapController _controller;

  final _formKey = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _aadharFocusNode = FocusNode();
  final _hostsFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _amenitiesFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _pinCodeFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile>? _imageList = [];
  final List<String> imageUrls = [];
  late LatLng _selectedLocation;
  late LatLng _position;

  String? StationName, StationAddress, aadharNumber, city, pinCode;
  String? hostNames,
      amenities,
      state,
      _startAvailabilityTime,
      _endAvailabilityTime; //later define hosts as list<string>
  double? amount, latitude = 0.0, longitude = 0.0;
  bool _isPinning = false;
  var _isLoading = false;
  typeCharger? _type;

  void _submitForm() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return; //Invalid
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: const MyChargingScreen()));
  }

  Widget _makeTitle({required String title}) {
    return Padding(
        padding: const EdgeInsets.only(left: 5, bottom: 5),
        child:
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)));
  }

  late Marker _station = const Marker(markerId: MarkerId('Station'));
  _pinMarkerOnMap(LatLng position) async {
    // BitmapDescriptor chargerIcon = await BitmapDescriptor.fromAssetImage(
    //     ImageConfiguration.empty, ImageAssets.mapSourceMarker);
    setState(() {
      _station = Marker(
        markerId: const MarkerId('Station'),
        position: position,
        infoWindow: InfoWindow(
            title: 'Your Station/Charger',
            snippet: '${position.latitude}, ${position.longitude}'),
        icon: BitmapDescriptor.defaultMarker,
      );
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 17)));
    });
  }

  _showMap() {
    setState(() {});
    return Card(
      elevation: 4,
        child: Container(
          height: 250,
          width: double.infinity,
          child: GoogleMap(
            onMapCreated: (argController) {
              _controller = argController;
            },
            initialCameraPosition: const CameraPosition(
                target: LatLng(29.946658, 76.817938), zoom: 16.3),
            mapType: MapType.normal,
            mapToolbarEnabled: false,
            compassEnabled: false,
            gestureRecognizers: Set()
              ..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),
            onTap: (coordinates) {
              _pinMarkerOnMap(coordinates);
              setState(() {
                _position = coordinates;
              });
            },
            markers: {_station},
          )),
    );
  }

  Widget _takeChargerLocation() {
    return _isPinning
        ? _showMap()
        : Card(
            elevation: 4,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: ListTile(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              tileColor: ColorManager.primaryWithOpacity,
              textColor: Colors.black,
              selectedColor: Colors.green,
              title: const Text('Select Charger location',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              leading: CircleAvatar(
                backgroundColor: ColorManager.grey3,
                child: const Icon(Icons.bolt, color: Colors.green),
              ),
              onTap: () {
                setState(() {
                  _isPinning = true;
                });
              },
            ),
          );
  }

  int chargerType = -1;
  Widget _chargerTypeRadioButtons() {
    return Row(
      children: <Widget>[
        Expanded(
            child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: RadioListTile<typeCharger>(
            contentPadding: const EdgeInsets.all(0.0),
            dense: true,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            activeColor: Colors.transparent,
            value: typeCharger.Level1,
            groupValue: _type,
            tileColor: (chargerType == 0) ? Colors.green[400] : Colors.white,
            onChanged: (val) {
              setState(() {
                // debugPrint('Selected Charger: \t$val');
                _type = val;
                chargerType = _type!.index;
                // print('8***********************$chargerType');
              });
            },
            title: const Text(
              'Level 1',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: RadioListTile<typeCharger>(
            contentPadding: const EdgeInsets.all(0.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            activeColor: Colors.transparent,
            dense: true,
            value: typeCharger.Level2,
            groupValue: _type,
            tileColor: (chargerType == 1) ? Colors.green[400] : Colors.white,
            onChanged: (val) {
              setState(() {
                debugPrint('Selected Charger: \t$val');
                _type = val;
                chargerType = _type!.index;
              });
            },
            title: const Text(
              'Level 2',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        )),
        const SizedBox(width: 12),
        Expanded(
            child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 4,
          child: RadioListTile<typeCharger>(
            contentPadding: const EdgeInsets.all(0.0),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            dense: true,
            activeColor: Colors.transparent,
            value: typeCharger.Level3,
            groupValue: _type,
            tileColor: (chargerType == 2) ? Colors.green[400] : Colors.white,
            onChanged: (val) {
              setState(() {
                debugPrint('Selected Charger: \t$val');
                _type = val;
                chargerType = _type!.index;
              });
            },
            title: const Text(
              'Level 3',
              style: TextStyle(color: Colors.black87),
            ),
          ),
        )),
      ],
    );
  }

  Future<void> _takeChargerImages(ImageSource source) async {
    if (source == ImageSource.gallery) {
      final List<XFile> selectedImage = await imagePicker.pickMultiImage();
      if (selectedImage.isNotEmpty) {
        _imageList!.addAll(selectedImage);
      }
    } else {
      final XFile? sekectedImage =
          await imagePicker.pickImage(source: ImageSource.camera);
      if (sekectedImage != null) {
        _imageList!.add(sekectedImage);
      }
    }

    setState(() {});
  }

  Future<List<String>> uploadImages(List<XFile> imageFiles) async {
    for (XFile imageFile in imageFiles) {
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('charger_images')
          .child('$imageName.jpg');

      await ref.putFile(File(imageFile.path));
      String imageUrl = await ref.getDownloadURL();

      imageUrls.add(imageUrl);
      // print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx");
      // print(imageUrls);
    }

    return imageUrls;
  }

  Future<void> _showPhotoOptionsDialog() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Pick station images using'),
              actions: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await _takeChargerImages(ImageSource.camera)
                        .then((value) => Navigator.of(context).pop());
                  },
                  icon: Icon(Icons.camera_alt_outlined,
                      color: ColorManager.primary),
                  label: const Text('Camera'),
                  style: Theme.of(context).elevatedButtonTheme.style,
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    await _takeChargerImages(ImageSource.gallery)
                        .then((value) => Navigator.of(context).pop());
                  },
                  icon: Icon(Icons.image_outlined, color: ColorManager.primary),
                  label: const Text('Gallery'),
                  style: Theme.of(context).elevatedButtonTheme.style,
                ),
              ],
            ));
  }

  Widget _showChargerImages() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Row(
            children: [
              _makeTitle(title: 'Charger Images'),
              const Spacer(),
              IconButton(
                icon: Icon(Icons.add_a_photo_outlined,
                    color: ColorManager.darkPrimary),
                onPressed: _showPhotoOptionsDialog,
              ),
            ],
          ),
        ),
        Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                border: Border.all()),
            padding: const EdgeInsets.all(4),
            height: 150,
            width: double.infinity,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 1),
              itemCount: _imageList!.length,
              itemBuilder: (context, index) => Image.file(
                File(_imageList![index].path),
                fit: BoxFit.cover,
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final userChargingDataProvider =
        Provider.of<UserChargingDataProvider>(context);
    // Storing users charging information using provider

    void StoreStationName(String StationName) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.stationName = StationName;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreStationAddress(String StationAddress) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.address = StationAddress;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void Storeg(LatLng position) {
      //   double latitude = position.latitude;
      // double longitude = position.longitude;

      String geohash =
          encodeGeohash(position.latitude, position.longitude, precision: 9);
      GeoPoint gpoint = GeoPoint(position.latitude, position.longitude);

      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.geohash = geohash;
      userChargingData.geopoint = gpoint as GeoPoint;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreAadharNumber(String aadharNumber) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.aadharNumber = aadharNumber;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreHostName(String hostName) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.hostName = hostName;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreChargerType(int type) {
      String chargerType = 'Level $type';
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.chargerType = chargerType;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreAvailability(String start, String end) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;

      userChargingData.startAvailability = start;
      userChargingData.endAvailability = end;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StorePrice(String Price) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.price = Price;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void Storeamenities(String amenities) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.amenities = amenities;

      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreImageurl(List<String> imageUrls) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.imageUrl = imageUrls;
      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreCity(String city) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.city = city;
      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StorePin(String pin) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.pin = pin;
      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    void StoreState(String state) {
      UserChargingData userChargingData =
          userChargingDataProvider.userChargingData;
      userChargingData.state = state;
      userChargingDataProvider.setUserChargingData(userChargingData);
    }

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.black,
              )),
          title: const Text('List your Charger',
              style: TextStyle(color: Colors.black)),
          elevation: 0,
        ),
        backgroundColor: ColorManager.lightGrey,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(15.0),
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _makeTitle(title: 'Station Name'),
                          Card(
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: TextFormField(
                              onChanged: StoreStationName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid station name.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Amog Public Charging Station',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_addressFocusNode),
                              onSaved: (newValue) {
                                setState(() {
                                  StationName = newValue!;
                                });
                                // StoreStationName(StationName!);
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'Address'),
                          Card(
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: TextFormField(
                              onChanged: StoreStationAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid address.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText:
                                      '255-A, Himadri Society, Hudson Lane',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              keyboardType: TextInputType.streetAddress,
                              textInputAction: TextInputAction.next,
                              focusNode: _addressFocusNode,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_cityFocusNode),
                              onSaved: (newValue) {
                                setState(() {
                                  StationAddress = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'City'),
                          Card(
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8))),
                            child: TextFormField(
                              onChanged: StoreCity,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your city.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Ambala',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              focusNode: _cityFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_pinCodeFocusNode),
                              onSaved: (newValue) {
                                city = newValue!;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              _makeTitle(title: 'Pin/Postal Code'),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.19,
                              ),
                              _makeTitle(title: 'State/Province')
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: TextFormField(
                                    onChanged: StorePin,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Pin.';
                                      }
                                      if (value.length < 6) {
                                        return 'Enter Valid Code.';
                                      }
                                      return null;
                                    },
                                    textInputAction: TextInputAction.done,
                                    style:
                                        TextStyle(color: ColorManager.darkGrey),
                                    decoration: InputDecoration(
                                      hintText: '80085',
                                      fillColor: Colors.white,
                                      filled: true,
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    keyboardType: TextInputType.number,
                                    focusNode: _pinCodeFocusNode,
                                    onFieldSubmitted: (_) =>
                                        FocusScope.of(context)
                                            .requestFocus(_stateFocusNode),
                                    onSaved: (newValue) {
                                      pinCode = newValue!;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              Expanded(
                                child: Card(
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8))),
                                  child: DropdownButtonFormField<String>(
                                    value: state,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                    decoration: const InputDecoration(
                                        hintText: 'Select State',
                                        fillColor: Colors.white,
                                        filled: true,
                                        // : ColorManager.primary.withOpacity(0.17),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide.none,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)))),
                                    items: States.values
                                        .map<DropdownMenuItem<String>>(
                                            (States st) {
                                      return DropdownMenuItem<String>(
                                        value: st.toString().split('.')[1],
                                        child:
                                            Text(st.toString().split('.')[1]),
                                      );
                                    }).toList(),
                                    onChanged: (val) {
                                      if (val != null) StoreState(val);
                                      setState(() {
                                        state = val;
                                      });
                                    },
                                    style:
                                        TextStyle(color: ColorManager.darkGrey),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _takeChargerLocation(),
                          const SizedBox(
                            height: 15,
                          ),
                          // _askCoordinates(),
                          // const SizedBox(
                          //   height: 15,
                          // ),
                          _makeTitle(title: 'Aadhar No.'),
                          Card(
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TextFormField(
                              onChanged: StoreAadharNumber,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid aadhar number.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'XXXX-XXXX-XXXX-XXXX',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              focusNode: _aadharFocusNode,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_hostsFocusNode),
                              onSaved: (newValue) {
                                aadharNumber = newValue!;
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'Host Names'),
                          Card(
                            elevation: 4,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TextFormField(
                              onChanged: StoreHostName,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid names.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText:
                                      'Priyanshu Maikhuri\nArshdeep Singh\nRaj',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              maxLines: 3,
                              keyboardType: TextInputType.name,
                              focusNode: _hostsFocusNode,
                              textInputAction: TextInputAction.newline,
                              onSaved: (newValue) {
                                setState(() {
                                  hostNames = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'Charger Type'),
                          _chargerTypeRadioButtons(),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'Availability'),
                          TimeIntervalPicker(
                              borderColor: Colors.black,
                              fillColor: ColorManager.primaryWithOpacity,
                              borderRadius: 10,
                              endLimit: DateTimeExtension.todayMidnight,
                              startLimit: DateTimeExtension.todayStart,
                              onChanged: (start, end, isAllDay) {
                                _startAvailabilityTime = DateFormat('h:mm a')
                                    .format(start!)
                                    .toString();
                                _endAvailabilityTime = DateFormat('h:mm a')
                                    .format(end!)
                                    .toString();
                              }),
                          const SizedBox(
                            height: 15,
                          ),
                          _makeTitle(title: 'Price (₹KW/h)'),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TextFormField(
                              onChanged: StorePrice,
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  prefixText: '₹\t',
                                  prefixStyle:
                                      TextStyle(fontSize: FontSize.s16),
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              focusNode: _priceFocusNode,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_amenitiesFocusNode),
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a price greater than zero.';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                setState(() {
                                  amount = double.parse(newValue!);
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          _makeTitle(title: 'Amenities'),
                          Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)),
                            ),
                            child: TextFormField(
                              onChanged: Storeamenities,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a list of available services';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Cafeteria/Toilets/Rest Room',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)),
                                  )),
                              focusNode: _amenitiesFocusNode,
                              maxLines: 5,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              onSaved: (newValue) {
                                setState(() {
                                  amenities = newValue!;
                                });
                              },
                            ),
                          ),
                          // const SizedBox(width: 40),
                          Container(
                            margin: const EdgeInsets.only(top: 25),
                            child: _imageList!.isNotEmpty
                                ? _showChargerImages()
                                : SizedBox(
                                    width: double.infinity,
                                    height: MediaQuery.sizeOf(context).height *
                                        0.05,
                                    child: ElevatedButton(
                                        onPressed: () {
                                          _showPhotoOptionsDialog();
                                        },
                                        style: //Theme.of(context).elevatedButtonTheme.style!.copyWith(backgroundColor: ColorManager.primaryWithOpacity,),
                                            ElevatedButton.styleFrom(
                                                backgroundColor: ColorManager.primaryWithOpacity,
                                                foregroundColor:
                                                    ColorManager.appBlack,
                                                elevation: 6,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8))),
                                        child: const Text(
                                          'Charger-Location Images',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )),
                                  ),
                          )
                        ]),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: MediaQuery.sizeOf(context).height * 0.05,
                      child: ElevatedButton(
                          onPressed: () async {
                            _submitForm;
                            StoreChargerType(++chargerType);
                            StoreAvailability(
                                _startAvailabilityTime!, _endAvailabilityTime!);
                            Storeg(_position);
                            await uploadImages(_imageList!)
                                .then((value) => {StoreImageurl(imageUrls)});

                            await FirebaseFirestore.instance
                                .collection('user')
                                .where('uid',
                                    isEqualTo:
                                        FirebaseAuth.instance.currentUser!.uid)
                                .get()
                                .then((QuerySnapshot<Map<String, dynamic>>
                                    querySnapshot) {
                              if (querySnapshot.docs.isNotEmpty) {
                                var doc = querySnapshot.docs[0];
                                doc.reference.update({'isProvider': true});
                              }
                            });
                            final prefs = await SharedPreferences.getInstance();
                            prefs.setBool('isProvider', true);

                            userChargingDataProvider
                                .saveUserChargingData()
                                .then((_) => Navigator.pop(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.fade,
                                        child: const BookingsScreen())));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorManager.primary,
                              elevation: 6,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8))),
                          child: const Text(
                            'Add',
                            style: TextStyle(fontSize: 15),
                          )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                )));
  }
}
