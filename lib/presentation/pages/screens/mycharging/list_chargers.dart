import 'dart:async';
import 'dart:io';

import 'package:EVFI/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '../../../Data_storage/UserData.dart';
import '../../../Data_storage/UserDataProvider.dart';
import '../../../resources/color_manager.dart';
import '../../models/my_charging.dart';
import 'chargers_data.dart';
import 'package:EVFI/presentation/pages/models/header_ui.dart';
import 'package:EVFI/presentation/pages/screens/mycharging/MyChargingScreen.dart';
import 'package:EVFI/presentation/resources/assets_manager.dart';

class ListCharger extends StatefulWidget {
  const ListCharger({Key? key}) : super(key: key);

  @override
  State<ListCharger> createState() => _ListChargerState();
}

class _ListChargerState extends State<ListCharger> {
  Chargers charger = Chargers();
  // final Completer<GoogleMapController> _mapController =
  //     Completer<GoogleMapController>();
  late GoogleMapController _controller;

  final _saveForm = GlobalKey<FormState>();
  final _priceFocusNode = FocusNode();
  final _aadharFocusNode = FocusNode();
  final _hostsFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _amenitiesFocusNode = FocusNode();
  final ImagePicker imagePicker = ImagePicker();
  final List<XFile>? _imageList = [];

  String? StationName, StationAddress, aadharNumber;
  String? hostNames, amenities; //later define hosts as list<string>
  double? amount, latitude = 0.0, longitude = 0.0;
  bool _isPinning = false;

  var _isLoading = false;
  typeCharger? _type;

  void _submitForm() async {
    final isValid = _saveForm.currentState!.validate();
    if (!isValid) {
      return;
    }
    _saveForm.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    await charger.addCharger(
        StationAddress: StationAddress!,
        StationName: StationName!,
        amount: amount!,
        position: LatLng(latitude!, longitude!));
    setState(() {
      _isLoading = false;
    });
    Navigator.pop(
        context,
        PageTransition(
            type: PageTransitionType.fade, child: const MyChargingScreen()));
  }

  Widget _makeTitle({required String title}) {
    return Text(title, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  // _askCoordinates() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         child: TextFormField(
  //           style: TextStyle(color: ColorManager.darkGrey),
  //           decoration: const InputDecoration(
  //               enabled: false,
  //               labelText: 'Station Latitude',
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //               )),
  //           keyboardType: TextInputType.none,
  //         ),
  //       ),
  //       const SizedBox(
  //         width: 10,
  //       ),
  //       Expanded(
  //         child: TextFormField(
  //           style: TextStyle(color: ColorManager.darkGrey),
  //           decoration: const InputDecoration(
  //               enabled: false,
  //               labelText: 'Station Longitude',
  //               enabledBorder: OutlineInputBorder(
  //                 borderRadius: BorderRadius.all(Radius.circular(10)),
  //               )),
  //           keyboardType: TextInputType.none,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  late Marker _station = const Marker(markerId: MarkerId('Station'));
  _pinMarkerOnMap(LatLng position) async {
    BitmapDescriptor chargerIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, ImageAssets.mapSourceMarker);
    setState(() {
      _station = Marker(
        markerId: const MarkerId('Station'),
        position: position,
        infoWindow: InfoWindow(
            title: 'Station/Charger location',
            snippet: '${position.latitude}, ${position.longitude}'),
        icon: Platform.isIOS ? BitmapDescriptor.defaultMarker : chargerIcon,
      );
      _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(target: position, zoom: 18)));
    });
  }

  _showMap() {
    return Container(
        height: 250,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 3.5, color: ColorManager.appBlack),
            boxShadow: [
              BoxShadow(
                  color: ColorManager.CardshadowBottomRight,
                  blurRadius: 8,
                  offset: const Offset(0, 2))
            ]),
        child: GoogleMap(
          onMapCreated: (argController) {
            _controller = argController;
          },
          initialCameraPosition: const CameraPosition(
              target: LatLng(29.946658, 76.817938), zoom: 16.3),
          mapType: MapType.normal,
          mapToolbarEnabled: false,
          compassEnabled: false,
          onTap: (coordinates) {
            _pinMarkerOnMap(coordinates);
          },
          markers: {_station},
        ));
  }

  Widget _takeChargerLocation() {
    return _isPinning
        ? _showMap()
        : Card(
            elevation: 2,
            child: ListTile(
              tileColor: ColorManager.primary.withOpacity(0.17),
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

  Widget _makeChargerOptions() {
    return Row(
      children: <Widget>[
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level1,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level1',
            style: TextStyle(color: Colors.black87),
          ),
        )),
        const SizedBox(width: 8),
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level2,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level2',
            style: TextStyle(color: Colors.black87),
          ),
        )),
        const SizedBox(width: 8),
        Expanded(
            child: RadioListTile<typeCharger>(
          contentPadding: const EdgeInsets.all(0.0),
          value: typeCharger.Level3,
          groupValue: _type,
          tileColor: ColorManager.primary.withOpacity(0.17),
          onChanged: (val) {
            setState(() {
              print('Selected Charger: \t$val');
              _type = val;
            });
          },
          title: const Text(
            'Level3',
            style: TextStyle(color: Colors.black87),
          ),
        )),
      ],
    );
  }

  Future _takeChargerImages(ImageSource source) async {
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

  Future<void> _showPhotoOptions() {
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

  @override
  Widget build(BuildContext context) {
    final userDataProvider = Provider.of<UserDataProvider>(context);
    void StoreStationName(String stationName) {
      UserData userData = userDataProvider.userData;
      userData.stationName = stationName;

      userDataProvider.setUserData(userData);
    }

    void StoreAddress(String aadress) {
      UserData userData = userDataProvider.userData;
      userData.address = aadress;

      userDataProvider.setUserData(userData);
    }

    void StoreAadhar(String aadhar) {
      UserData userData = userDataProvider.userData;
      userData.aadharNumber = aadhar;

      userDataProvider.setUserData(userData);
    }

    void StoreHostname(String hostname) {
      UserData userData = userDataProvider.userData;
      userData.hostName = hostname;

      userDataProvider.setUserData(userData);
    }

    void StoreChargerType(String chargerType) {
      UserData userData = userDataProvider.userData;
      userData.chargerType = chargerType;

      userDataProvider.setUserData(userData);
    }

    void StorePrice(String price) {
      UserData userData = userDataProvider.userData;
      userData.price = price;

      userDataProvider.setUserData(userData);
    }

    void StoreAmenities(String amenities) {
      UserData userData = userDataProvider.userData;
      userData.amenities = amenities;

      userDataProvider.setUserData(userData);
    }

    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'Rent your Charger',
          ),
          backgroundColor: ColorManager.appBlack,
        ),
        backgroundColor: Colors.grey[200],
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Form(
                key: _saveForm,
                child: ListView(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: const HeaderUI(
                            220, true, ImageAssets.oldBlackMarker),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _makeTitle(title: 'Station Name'),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid station name.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Amog Public Battery Station',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              textInputAction: TextInputAction.next,
                              onFieldSubmitted: (_) => FocusScope.of(context)
                                  .requestFocus(_addressFocusNode),
                              onSaved: (newValue) {
                                setState(() {
                                  StationName = newValue!;
                                });
                              },
                              onChanged: (value) {
                                StoreStationName(value);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _makeTitle(title: 'Address'),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid address.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Thannesar Road, Kurukshetra',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              focusNode: _addressFocusNode,
                              onSaved: (newValue) {
                                setState(() {
                                  StationAddress = newValue!;
                                });
                              },
                              onChanged: (value) {
                                StoreAddress(value);
                              },
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
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter a valid aadhar number.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'XXXX-XXXX-XXXX-XXXX',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                            const SizedBox(
                              height: 15,
                            ),
                            _makeTitle(title: 'Host Names'),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter valid names.';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Persons available',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
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
                              onChanged: (value) {
                                StoreAadhar(value);
                              },
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            _makeTitle(title: 'Charger Type'),
                            _makeChargerOptions(),
                            const SizedBox(
                              height: 15,
                            ),
                            _makeTitle(title: 'Price'),
                            TextFormField(
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
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
                              onChanged: (value) {
                                StoreChargerType(value);
                              },
                            ),
                            const SizedBox(height: 15),
                            _makeTitle(title: 'Amenities'),
                            TextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please provide a list of available services';
                                }
                                return null;
                              },
                              style: TextStyle(color: ColorManager.darkGrey),
                              decoration: const InputDecoration(
                                  hintText: 'Cafeteria/Toilets/Rest Room',
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                  )),
                              focusNode: _amenitiesFocusNode,
                              maxLines: 3,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              onSaved: (newValue) {
                                setState(() {
                                  amenities = newValue!;
                                });
                              },
                              onChanged: (value) {
                                StoreAmenities(value);
                              },
                            ),
                            const SizedBox(width: 15),
                            Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: _imageList!.isNotEmpty
                                  ? Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Row(
                                            children: [
                                              _makeTitle(
                                                  title: 'Charger Images'),
                                              const Spacer(),
                                              IconButton(
                                                icon: Icon(
                                                    Icons.add_a_photo_outlined,
                                                    color: ColorManager
                                                        .darkPrimary),
                                                onPressed: _showPhotoOptions,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                border: Border.all()),
                                            padding: const EdgeInsets.all(4),
                                            height: 150,
                                            width: double.infinity,
                                            child: GridView.builder(
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 3,
                                                      mainAxisSpacing: 10,
                                                      crossAxisSpacing: 10,
                                                      childAspectRatio: 1),
                                              itemCount: _imageList!.length,
                                              itemBuilder: (context, index) =>
                                                  Image.file(
                                                File(_imageList![index].path),
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                      ],
                                    )
                                  : Align(
                                      alignment: Alignment.center,
                                      child: ElevatedButton(
                                          onPressed: _showPhotoOptions,
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.black87,
                                              shadowColor:
                                                  ColorManager.appBlack,
                                              elevation: 6,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          25))),
                                          child: const Text(
                                            'Charger Images',
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.white),
                                          )),
                                    ),
                            )
                          ]),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorManager.primary.withOpacity(0.7),
                                    shadowColor: ColorManager.appBlack,
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                child: const Text(
                                  'Add',
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                          const SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: ElevatedButton(
                                onPressed: () => Navigator.of(context).pop(),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        ColorManager.primary.withOpacity(0.7),
                                    shadowColor: ColorManager.appBlack,
                                    elevation: 6,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25))),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(fontSize: 15),
                                )),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                )));
  }
}
