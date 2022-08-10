import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/user.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/resources/refresh.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/user/edit_profile.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String authToken = "";
String phoneNumber = "";
String refreshKey = "";

Profile? profile;
List<Car> carList = [];

Widget bottomProfile(
  BuildContext context,
  // List<Category> categories,
  // List<Order> orders,
) {
  return FutureBuilder<String>(
    future: loadInitialData(),
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
            return const SignIn();
          }
        case "":
          {
            debugPrint("authToken is expired: $authToken");
            return const SignIn();
          }
      }

      return Padding(
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
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                "/user/edit_profile",
                                arguments: UserEditArs(profile: profile),
                              );
                            },
                            child: const Text("Редактировать профиль"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(3),
                    itemCount: carList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ExpansionTileCard(
                        borderRadius: BorderRadius.circular(16),
                        shadowColor: const Color.fromRGBO(0, 0, 0, 0.5),
                          title: Text(
                              '${carList[index].brand} ${carList[index].model}'),
                          subtitle: Text(carList[index].plateNumber),
                          children: <Widget>[
                            const Divider(
                              thickness: 1.0,
                              height: 1.0,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    Text("id: ${carList[index].id.toString()}"),
                                    Text("Марка авто: ${carList[index].brand}"),
                                    Text("Модель авто: ${carList[index].model}"),
                                    Text(
                                        "Гос. Номер: ${carList[index].plateNumber}"),
                                    Text("VIN авто: ${carList[index].vin}"),
                                    Text(
                                        "Год авто: ${carList[index].year.toString()}"),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );

                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        // todo: Need to delete phoneNumber, authToken, refreshKey from this page
                        const Text("##### Хранилище приложения #####"),
                        const Divider(),
                        Text("phoneNumber: $phoneNumber"),
                        const Divider(),
                        Text("authToken: $authToken"),
                        const Divider(),
                        Text("refreshKey: $refreshKey"),
                        const Divider(),

                        ElevatedButton(
                          onPressed: () {
                            delFromStorage();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              "/signin",
                              (route) => false,
                            );
                          },
                          child: const Text("Выйти"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
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

Future<String> loadInitialData() async {
  final pf = await SharedPreferences.getInstance();

  authToken = pf.getString("auth_token") ?? "";
  phoneNumber = pf.getString("phone_number") ?? "";
  refreshKey = pf.getString("refresh_key") ?? "";

    final profileResponse = await getProfile(authToken);
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
            saveAuthData(authToken, refreshKey);
            break;
          } else {
            debugPrint(
                "refreshResponse.statusCode: ${refreshResponse.statusCode}");
            debugPrint("refreshResponse.error: ${refreshResponse.error}");
            return Future.value("tokenExpired");
          }
        }
    }


  final getCarListResponse = await getCustomerCars(authToken);
  carList = getCarListResponse.cars;

  return Future.value("Ok");
}

Future<String> saveAuthData(String token, String refreshKey) async {
  final pf = await SharedPreferences.getInstance();
  pf.setString("auth_token", token);
  pf.setString("refresh_key", refreshKey);
  return Future.value("Ok");
}
