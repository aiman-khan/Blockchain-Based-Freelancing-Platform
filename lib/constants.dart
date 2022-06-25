import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color kBaseColor1 =  Color(0xff3B7446);
// Color kBaseColor2 =  Color(0xff93a85c);
Color kBaseColor2 =  Color(0xff3B7446);
Color kBaseColor3 =Color(0xff575a1a);
//
// Color kBaseColor1 = Color(0xff5a1897);
// Color kBaseColor2 = Color(0xff009DDC);
// Color kBaseColor3 = Color(0xffD496A7);

Color color1 = Color(0xff3B7446);
Color color2 = Color(0xff3B7446);
// Color color2 = Color(0xff93a85c);
Color color3 = Color(0xff575a1a);

double kSmallButtonWidth = 0.35;
double kSmallButtonHeight = 0.04;


final ethLogo = CircleAvatar(
radius: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width * 0.016,
backgroundImage:
AssetImage('assets/images/eth.png'),
backgroundColor: Colors.white,
);

final ethLogoLarge = CircleAvatar(
  radius: MediaQueryData.fromWindow(WidgetsBinding.instance!.window).size.width * 0.06,
  backgroundImage:
  AssetImage('assets/images/eth.png'),
  backgroundColor: Colors.white,
);

final kGradient1 = LinearGradient(
  colors: [color1, color1],
);

final kGradient2 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.centerRight,
  tileMode: TileMode.clamp,
  colors: [color1, color1],
);

class kSizedBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.0,
    );
  }
}

class kHeadingFontSize extends StatelessWidget {
  final String heading;
  kHeadingFontSize({required this.heading});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Text(
      "$heading",
      style: GoogleFonts.aBeeZee(
        fontSize: width * 0.04,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

const kHeading2FontSize = TextStyle(
  fontSize: 20.0,
);

const boxShadow = BoxShadow(
  spreadRadius: 0.0,
  blurRadius: 0.0,
  color: Colors.black12,
  offset: Offset.zero,
);

const inputText = TextStyle(
  color: Colors.lightBlue,
  fontSize: 20,
  fontWeight: FontWeight.w500,
  letterSpacing: 1,
);

const blackText = TextStyle(
  color: Colors.black,
);

const placeholder = TextStyle(
  color: Color(0xFF666666),
  fontSize: 18,
  fontWeight: FontWeight.w500,
);

const outlineBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(
    Radius.circular(
      50.0,
    ),
  ),
  borderSide: BorderSide.none,
);

const roundedBorder = OutlineInputBorder(
  borderRadius: round,
  borderSide: BorderSide.none,
);

const sent = LinearGradient(
  colors: [Color(0xff681fb0), Color(0xff34189c)],
);

const received = LinearGradient(
  colors: [Colors.lightBlue, Colors.lightBlueAccent],
);

const chatConstraints = BoxConstraints(
  maxWidth: 300.0,
);

const round = BorderRadius.all(
  Radius.circular(20),
);


const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kErrorColor = Color(0xFFF03738);

const kDefaultPadding = 20.0;