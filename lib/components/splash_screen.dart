import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:smartphone_news_app/components/category_screen.dart';

class SplashScreen extends StatefulWidget {
    const SplashScreen({super.key});

    @override
    State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
        
        Timer(const Duration(seconds: 2), () { 
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CategoriesScreen()));
        });
    }
  
  
    @override
    Widget build(BuildContext context) {
        final height = MediaQuery.sizeOf(context).height * 1 ;
        //final width = MediaQuery.sizeOf(context).width * 1 ;

        return  Scaffold(
            body: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Image.asset('../assets/phones.png',
                        fit: BoxFit.cover,
                        height:  height * .5,
                        ),
                        SizedBox(height: height * 0.04,),
                        SizedBox(height: height * 0.04,),
                        const SpinKitChasingDots( color: Colors.blue , size: 40, )
                    ],
                ),
            ),
        );
    }
}