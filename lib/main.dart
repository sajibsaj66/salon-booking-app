import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:salon_app/features/auth/controller/login_provider.dart';
import 'package:salon_app/features/booking/controllers/booking_date.dart';
import 'package:salon_app/features/booking/controllers/orderdata.dart';
import 'package:salon_app/features/favourites/favourites.dart';
import 'package:salon_app/features/profile/profilescreen.dart';
import 'package:salon_app/features/schedule/userschedule.dart';
import 'package:salon_app/features/search/controller/searchbar_controller.dart';
import 'package:salon_app/features/auth/view/pages/auth.dart';
import 'package:salon_app/features/home/view/home_page.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:salon_app/firebase_options.dart';
import 'controller/location_controller.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'db/userinfo.dart';
import 'features/home/controller/searchcontroller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      "pk_test_51NHSPaSHrFIYiYVqaAMi5u4WOn3kjnNTOcy0lEUBH6ZQZv1IFcImQOAwCo7zZu1kzUHQ0tT9djRcSXUuPqccu3Lb00hpDGu55r";

  //Load our .env file that contains our Stripe Secret key
  await dotenv.load(fileName: "assets/.env");
  await Firebase.initializeApp(
    name: 'salon-app',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoggedIn = false;
  @override
  void initState() {
    super.initState();
    UserDb.getUserInfo().then((value) {
      print('User Info 00: ${value!.username}');
      if (value != null) {
        setState(() {
          isLoggedIn = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<LatLonController>(
              create: ((context) => LatLonController())),
          ChangeNotifierProvider(create: ((context) => BookingDate())),
          ChangeNotifierProvider<SearchbarController>(
              create: ((context) => SearchbarController())),
          ChangeNotifierProvider<AuthMethod>(
              create: ((context) => AuthMethod())),
          ChangeNotifierProvider<OrderInfo>(create: ((context) => OrderInfo())),
          ChangeNotifierProvider<SearchQueryProvider>(
              create: ((context) => SearchQueryProvider())),
        ],
        child: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) {
              currentFocus.unfocus();
            }
          },
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Salon app',
              theme: ThemeData(
                fontFamily: "Inter",
              ),
              home: isLoggedIn ? Wrapper() : const AuthPage()),
        ),
      ),
    );
  }
}

class Wrapper extends StatefulWidget {
  Wrapper({super.key, this.currIndex = 0});

  int currIndex;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  // int _currentIndex = 0;
  final List<Widget> _children = [
    const HomePage(),
    const UserSchedule(),
    const FavouriteArtists(),
    const ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn,
          child: Material(child: _children[widget.currIndex])),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 5,
        unselectedFontSize: 0,
        selectedFontSize: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: const IconThemeData(size: 20),
        unselectedIconTheme: const IconThemeData(size: 18),
        currentIndex: widget.currIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            widget.currIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.calendar,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              CupertinoIcons.person,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
