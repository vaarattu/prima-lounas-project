import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class RestaurantMorePage extends StatefulWidget {
  @override
  _RestaurantMorePageState createState() => _RestaurantMorePageState();
}

List<String> licensesList = [
  "pull_to_refresh 2.0.0",
  "expansion_tile_card 2.0.0",
  "tuple 2.0.0",
  "cupertino_icons 1.0.3",
  "http 0.13.4",
  "store_redirect 2.0.0",
  "url_launcher 6.0.12",
  "flutter_launcher_icons 0.9.2",
  "device_info_plus 3.0.1"
];

openAppStorePage() {
  StoreRedirect.redirect();
}

openMenuInDrive() {
  launch("https://drive.google.com/file/d/0B8nQh-fa3RbLMFN0X1QxaDFhYzQ");
}

String? encodeQueryParameters(Map<String, String> params) {
  return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
}

sendEmailFeedback() {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: 'juha.ala-rantala@primapower.com',
    query: encodeQueryParameters(<String, String>{'subject': 'Palaute: Priima Lounas Ruokalista -sovellus'}),
  );

  launch(emailLaunchUri.toString());
}

getDeviceInfo() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  int x = 0;
}

Future showLicensesDialog(BuildContext context) async {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Lisenssit'),
        content: Container(
          width: 300,
          height: 300,
          child: ListView.builder(
            itemCount: licensesList.length * 2,
            itemBuilder: (context, i) {
              if (i.isOdd) {
                return const Divider();
              }
              int index = i ~/ 2;
              return ListTile(
                title: Text(
                  licensesList[index],
                ),
              );
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Sulje"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

voidFunction() {}

class _RestaurantMorePageState extends State<RestaurantMorePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 128, height: 128, child: Image(image: AssetImage("assets/icon.png"))),
                SizedBox(
                  height: 128,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TitleSubtitleColumn(title: "SOVELLUS", subtitle: "Priima Lounas Ruokalista"),
                      TitleSubtitleColumn(title: "KEHITTÄJÄ", subtitle: "Juha Ala-Rantala"),
                      TitleSubtitleColumn(title: "SOVELLUSVERSIO", subtitle: "1.0.9"),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            MorePageCard(
              title: "Virheilmoitukset",
              body: "Lähetä virheilmoitukset kehittäjälle",
              icon: Icons.report_problem,
              callback: getDeviceInfo,
            ),
            MorePageCard(
              title: "Asetukset",
              body: "Muokkaa sovelluksen asetuksia",
              icon: Icons.settings,
              callback: voidFunction,
            ),
            MorePageCard(
              title: "Ruokalista Drivessa",
              body: "Avaa ruokalista google drivessa",
              icon: Icons.outbond,
              callback: openMenuInDrive,
            ),
            MorePageCard(
              title: "Arvostele sovellus",
              body: "Avaa sovelluksen Play Store -sivu",
              icon: Icons.play_arrow,
              callback: openAppStorePage,
            ),
            MorePageCard(
              title: "Lähetä palautetta",
              body: "Anna palautetta sovelluksesta",
              icon: Icons.feedback,
              callback: sendEmailFeedback,
            ),
            MorePageCard(
              title: "Lisenssit",
              body: "Näytä avoimen lähdekoodin lisenssit",
              icon: Icons.info,
              callback: () => showLicensesDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleSubtitleColumn extends StatelessWidget {
  const TitleSubtitleColumn({Key? key, required this.title, required this.subtitle}) : super(key: key);

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey),
        ),
        Text(subtitle),
      ],
    );
  }
}

class MorePageCard extends StatelessWidget {
  const MorePageCard({Key? key, required this.title, required this.body, required this.icon, required this.callback})
      : super(key: key);

  final String title;
  final String body;
  final IconData icon;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: callback,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    body,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Icon(
                icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
