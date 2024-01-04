import "package:go_router/go_router.dart";

import "src/pages/landing.dart";
import "src/pages/signup_business.dart";
import "src/pages/signup_athlete.dart";

export "package:go_router/go_router.dart";

class Routes {
  static const landing = "/";
  static const login = "login";
  static const signUpAthlete = "athlete-sign-up";
  static const signUpBusiness = "business-sign-up";
}

final router = GoRouter(
  initialLocation: Routes.landing,
  routes: [
    // TODO: Make login, signUpAthlete, and signUpBusiness top-level routes
    GoRoute(
      path: "/",
      builder: (_, __) => LandingPage(),
      routes: [
        GoRoute(
          path: Routes.signUpAthlete,
          name: Routes.signUpAthlete,
          builder: (_, __) => AthleteSignUpPage(),
        ),
        GoRoute(
          path: Routes.signUpBusiness,
          name: Routes.signUpBusiness,
          builder: (_, __) => BusinessSignUpPage(),
        ),
      ],
    ),
  ],
);
