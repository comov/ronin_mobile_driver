import 'package:car_helper/entities/car.dart';
import 'package:car_helper/entities/user.dart';
import 'package:car_helper/resources/api_user_profile.dart';
import 'package:car_helper/resources/refresh.dart';
import 'package:car_helper/screens/authorization/sign_in_screen.dart';
import 'package:car_helper/screens/user/edit_car.dart';
import 'package:car_helper/screens/user/edit_profile.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/foundation.dart';
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
                          title: const Text("Данные пользователя:"),
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
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/user/edit_profile",
                                      arguments: UserEditArs(profile: profile, userCars: carList),
                                    );
                                  },
                                  child: const Text("Редактировать профиль"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flex(
                direction: Axis.horizontal,
                children: [
                  if (carList.isNotEmpty)
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: const Text("Авто пользователя:"),
                            subtitle: ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(3),
                              itemCount: carList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ExpansionTileCard(
                                  borderRadius: BorderRadius.circular(16),
                                  shadowColor:
                                      const Color.fromRGBO(0, 0, 0, 0.5),
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
                                            Text(
                                                "id: ${carList[index].id.toString()}"),
                                            Text(
                                                "Марка авто: ${carList[index].brand}"),
                                            Text(
                                                "Модель авто: ${carList[index].model}"),
                                            Text(
                                                "Гос. Номер: ${carList[index].plateNumber}"),
                                            Text(
                                                "VIN авто: ${carList[index].vin}"),
                                            Text(
                                                "Год авто: ${carList[index].year.toString()}"),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.pushNamed(
                                                      context, "/user/edit_car",
                                                      arguments: EditCarArgs(
                                                          editCar:
                                                              carList[index]));
                                                },
                                                child: const Text(
                                                    "Редактировать Авто")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) =>
                                      const Divider(),
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

void selectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      break;
    case 1:
      if (kDebugMode) {
        print("клик на пользоват. соглашения");
      }
      break;
    case 2:
      debugPrint("click on logout");
      delFromStorage();
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/signin",
        (route) => false,
      );
      break;
  }
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
