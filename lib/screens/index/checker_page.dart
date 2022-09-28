import 'package:car_helper_driver/entities/user.dart';
import 'package:car_helper_driver/resources/api_user_profile.dart';
import 'package:car_helper_driver/resources/refresh.dart';
import 'package:car_helper_driver/screens/authorization/auth_screen.dart';
import 'package:car_helper_driver/screens/index/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckerPage extends StatefulWidget {
  const CheckerPage({Key? key}) : super(key: key);

  @override
  State<CheckerPage> createState() => _CheckerPage();
}

class _CheckerPage extends State<CheckerPage> {
  String authToken = "";
  String phoneNumber = "";
  String refreshKey = "";
  Profile? profile;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadInitialData(),
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
              // const Text("Сессия устарела");
              debugPrint("authToken is expired: $authToken");
              return const Auth();
            }
        }
        return Index(0);
      },
    );
  }

  Future<String> loadInitialData() async {
    var pf = await SharedPreferences.getInstance();

    authToken = pf.getString("auth_token") ?? "";
    phoneNumber = pf.getString("phone_number") ?? "";
    refreshKey = pf.getString("refresh_key") ?? "";
    //TODO endpoint with FireToken
    final fireToken = "eyJhbGciOiAiUlMyNTYiLCAidHlwIjogIkpXVCIsICJraWQiOiAiYzNhZTcyMDYyODZmYmEwYTZiODIxNzllYTQ0NmFiZjE4Y2FjOGM2ZSJ9.eyJpc3MiOiAiZmlyZWJhc2UtYWRtaW5zZGsteXd6eGVAcm9uaW4tbW9iaWxlLmlhbS5nc2VydmljZWFjY291bnQuY29tIiwgInN1YiI6ICJmaXJlYmFzZS1hZG1pbnNkay15d3p4ZUByb25pbi1tb2JpbGUuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iLCAiYXVkIjogImh0dHBzOi8vaWRlbnRpdHl0b29sa2l0Lmdvb2dsZWFwaXMuY29tL2dvb2dsZS5pZGVudGl0eS5pZGVudGl0eXRvb2xraXQudjEuSWRlbnRpdHlUb29sa2l0IiwgInVpZCI6ICJjdXN0b21lcjo2IiwgImlhdCI6IDE2NjQzNjYxOTUsICJleHAiOiAxNjY0MzY5Nzk1fQ.ml-3pwSPyzQWVBewtk10ejrII1K9w-URvprXWLqQ2Yvio3loQFjbxl7sdvHsHHaU8xct5oI1EKVWC-0Wkt_lsignksy6juhgBykXhcxAhMoiCnPQACBorEh6lxT-PSzJBYcyYkDTvH5dlsX0bsvJTwdp1OogZ5jz-dEBr2IV67xDmzFZY5R7SZSn--Cmc_v03-6o2YM0hfryx1_JABI9X2eD9ekwwBGKUJFkQLdOrCYGa41Yz2-3ya_lC89-YPiMaqopNwr_A_C_JyrMbFXzGkcCks9499SDv-Ty-MqAYInM0QqTwU1pd6v6Y3voXFFKkPnYifrGactR-JsSJrfkaQ";
    pf.setString("fire_token", fireToken);


    if (authToken == "") {
      return Future.value("tokenNotFound");
    }

    final profileResponse = await getProfile(authToken);
    switch (profileResponse.statusCode) {
      case 200:
        {
          profile = profileResponse.profile;
        }
        break;
      case 401:
        {
          debugPrint(refreshKey);

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

    return Future.value("Ok");
  }
}
