import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:channil/models.dart";

import "src/pages/landing.dart";
import "src/pages/home/shell.dart";
import "src/pages/signup_business.dart";
import "src/pages/signup_athlete.dart";
import "src/pages/settings.dart";

export "package:go_router/go_router.dart";

class Routes {
  static const landing = "/";
  static const login = "login";
  static const signUpAthlete = "athlete-sign-up";
  static const signUpBusiness = "business-sign-up";
  static const profile = "profile";
  static const settings = "settings";
}

String? loginRedirect(BuildContext context, _) => 
  models.user.isAuthenticated && models.user.hasAccount
    ? null : "/login";

final router = GoRouter(
  initialLocation: "/profile",
  routes: [
    GoRoute(
      path: "/${Routes.login}",
      name: Routes.login,
      builder: (_, __) => LandingPage(),
    ),
    GoRoute(
      path: "/${Routes.signUpAthlete}",
      name: Routes.signUpAthlete,
      builder: (_, __) => AthleteSignUpPage(),
    ),
    GoRoute(
      path: "/${Routes.signUpBusiness}",
      name: Routes.signUpBusiness,
      builder: (_, __) => BusinessSignUpPage(),
    ),
    GoRoute(
      path: "/${Routes.profile}",
      name: Routes.profile,
      redirect: loginRedirect,
      builder: (_, __) => const HomeShell(ChannilDestination.profile),
    ),
    GoRoute(
      path: "/${Routes.settings}",
      name: Routes.settings,
      redirect: loginRedirect,
      builder: (_, __) => SettingsPage(),
    ),
  ],
);
