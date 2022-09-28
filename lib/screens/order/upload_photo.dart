import 'dart:convert';
import 'dart:io';

import 'package:car_helper_driver/screens/authorization/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';


class UploadPhotoArgs {
  final int stateId;
  final String authToken;

  UploadPhotoArgs({required this.stateId, required this.authToken});
}

class UploadPhoto extends StatefulWidget {
  const UploadPhoto({Key? key}) : super(key: key);

  @override
  State<UploadPhoto> createState() => _UploadPhotoState();
}

class _UploadPhotoState extends State<UploadPhoto> {
  String refreshKey = "";
  String comment = "";
  TextEditingController commentController = TextEditingController();

  File? image;
  final _picker = ImagePicker();
  bool showSpinner = false;

  Future getImage() async {
    final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      setState(() {});
    } else {
      debugPrint("no image selected");
    }
  }

  Future<void> uploadImage(String authToken) async {

    setState(() {
      showSpinner = true;
    });
    var stream = http.ByteStream(image!.openRead());
    stream.cast();

    var length = await image!.length();
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": "Bearer " + authToken
    };

    var uri = Uri.parse(
        "https://stage.i-10.win/api/v1/driver/order/122/upload_photo?kind=0");

    var request = http.MultipartRequest('PUT', uri);


    var multiport = http.MultipartFile('photo[0]', stream, length, filename: basename(image!.path));
    request.files.add(multiport);
    request.headers.addAll(headers);
    request.fields['photo_comment[0]'] = comment;

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

    final result = jsonDecode(response.body) as Map<String, dynamic>;
    debugPrint(result['message']);

    if (response.statusCode == 200) {
      debugPrint('image uploaded');
      setState(() {
        showSpinner = false;
      });

    } else {
      debugPrint("${response.statusCode}");

      debugPrint("failed");
      setState(() {
        showSpinner = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UploadPhotoArgs;
    final stateId = args.stateId;
    String authToken = args.authToken;


    return FutureBuilder<String>(
        future: loadInitialDataOrderDetail(stateId),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: Text("Загрузка...")),
            );
          }

          if (snapshot.hasError) {
            return Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Ошибка при загрузке приложения :("),
                      Text("${snapshot.error}"),
                    ],
                  ),
                ),
              );

          }

          switch (snapshot.data!) {
            case "tokenNotFound":
              {
                debugPrint("authToken is empty: $authToken");
                return const Auth();
              }
            case "tokenExpired":
              {
                debugPrint("authToken is expired: $authToken");
                return const Auth();
              }
          }
          return ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text("Загрузка фото"),
                  ],
                ),
                titleTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        getImage();
                      },
                      child: Container(
                        child: image == null
                            ? Center(
                                child: Text("Pick Image"),
                              )
                            : Container(
                                child: Center(
                                  child: Image.file(File(image!.path).absolute,
                                      height: 100, width: 100, fit: BoxFit.cover),
                                ),
                              )),
                    ),
                    Divider(),
                    SizedBox(
                      height: 150,
                    ),
                    TextFormField(
                      controller: commentController,
                      onChanged: (text) => {comment = text},
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        labelText: "Комментарий к фотографии",
                        focusedBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.length >= 21) {
                          return "Поле не может быть больше 20 символов";
                        }
                        return null;
                      },
                    ),
                    Divider(),
                    GestureDetector(
                      onTap: () {
                        uploadImage(authToken);
                      },
                      child: Container(
                        width: 200,
                        height: 50,
                        color: Colors.green,
                        child: Text("Загрузить"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<String> loadInitialDataOrderDetail(int orderId) async {
    final pf = await SharedPreferences.getInstance();
    // authToken = pf.getString("auth_token") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";

    // if (authToken == "") {
    //   return Future.value("tokenNotFound");
    // }

    return Future.value("Ok");
  }
}
