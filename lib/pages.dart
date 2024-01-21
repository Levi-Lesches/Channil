import "package:go_router/go_router.dart";
import "package:channil/models.dart";

import "src/pages/landing.dart";
import "src/pages/signup_business.dart";
import "src/pages/signup_athlete.dart";

export "package:go_router/go_router.dart";

class Routes {
  static const landing = "/";
  static const signUpAthlete = "athlete-sign-up";
  static const signUpBusiness = "business-sign-up";
  static const profile = "profile";
}

String? loginRedirect(_, __) => models.user.isAuthenticated && models.user.hasAccount ? null : Routes.landing;

final router = GoRouter(
  initialLocation: "/profile",
  routes: [
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
        GoRoute(
          name: Routes.profile,
          redirect: loginRedirect,
          path: "profile/:id",
          builder: (_, __) => BusinessSignUpPage(),
        ),
      ],
    ),
  ],
);
