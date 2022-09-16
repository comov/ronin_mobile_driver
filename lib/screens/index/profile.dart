import 'package:car_helper_driver/entities/car.dart';
import 'package:car_helper_driver/entities/user.dart';
import 'package:car_helper_driver/resources/api_user_profile.dart';
import 'package:car_helper_driver/resources/refresh.dart';
import 'package:car_helper_driver/screens/authorization/auth_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';

  String authToken = "";
  String refreshKey = "";
  Profile? profile;
  List<Car> carList = [];

Widget bottomProfile(BuildContext context) {

    return FutureBuilder<String>(
      future: loadInitialDataProfile(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        // AsyncSnapshot<Your object type>
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

        return Scaffold(
          appBar: AppBar(
            title: const Text("Профиль"),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 34,
            ),
            actions: [
              PopupMenuButton<int>(
                icon: const Icon(Icons.settings),
                itemBuilder: (context) => [
                  const PopupMenuItem<int>(
                      value: 0, child: Text("Пригласить друзей")),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text("Пользовательские соглашения"),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Выход")
                      ],
                    ),
                  )
                ],
                onSelected: (item) => selectedItem(context, item),
              )
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: const Text("Данные водителя:"),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Фамилия: ${profile?.lastName}",
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    "Имя: ${profile?.firstName}",
                                    textAlign: TextAlign.justify,
                                  ),
                                  Text(
                                    "Номер телефона: ${profile?.phone}",
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     Navigator.pushNamed(
                                  //         context, "/user/edit_profile",
                                  //         arguments:
                                  //             UserEditArs(profile: profile));
                                  //   },
                                  //   child: const Text("Редактировать профиль"),
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void delFromStorage() async {
    final pf = await SharedPreferences.getInstance();
    pf.remove("auth_token");
    pf.remove("refresh_key");
  }
void sharePressed() {
    String message = "Я пользуюсь приложением RoninMobile. Присоединяйся instagram.link";
    Share.share(message);
}

  void selectedItem(BuildContext context, item) {
    switch (item) {
      case 0:
        sharePressed();
        break;
      case 1:
        if (kDebugMode) {
          print("клик на пользоват. соглашения");
        }
        break;
      case 2:
        delFromStorage();
        Navigator.of(context).pushNamedAndRemoveUntil(
          "/auth",
          (route) => false,
        );
        break;
    }
  }

  Future<String> loadInitialDataProfile() async {
    var pf = await SharedPreferences.getInstance();
    debugPrint("profileFuture");

    authToken = pf.getString("auth_token") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";


    if (authToken == "") {
      return Future.value("tokenNotFound");
    }

    final profileResponse = await getProfile(authToken);
    {
      switch (profileResponse.statusCode) {
        case 200:
          {
            profile = profileResponse.profile;
          }
          break;
        case 401:
          {
            final refreshResponse = await refreshToken(refreshKey);
            if (refreshResponse.statusCode == 200) {
              authToken = refreshResponse.auth!.token;
              refreshKey = refreshResponse.auth!.refreshKey;
              pf.setString("auth_token", authToken);
              pf.setString("refresh_key", refreshKey);
              break;
            } else {
              debugPrint(
                  "refreshResponse.statusCode: ${refreshResponse.statusCode}");
              debugPrint("refreshResponse.error: ${refreshResponse.error}");
              return Future.value("tokenExpired");
            }
          }
      }
    }

    return Future.value("Ok");
  }
