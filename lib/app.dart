import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 1920),
      minTextAdapt: true,
      builder:
          (_, __) => MaterialApp(
            title: 'Chick Game',
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: appRoutes,
          ),
    );
  }
}
