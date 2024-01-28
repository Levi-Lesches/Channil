import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:channil/models.dart";

import "src/pages/landing.dart";
import "src/pages/home/shell.dart";
import "src/pages/signup_business.dart";
import "src/pages/signup_athlete.dart";
import "src/pages/settings.dart";

export "src/pages/home/confirm.dart";
export "package:go_router/go_router.dart";

class Routes {
  static const landing = "/";
  static const login = "login";
  static const signUpAthlete = "athlete-sign-up";
  static const signUpBusiness = "business-sign-up";
  static const profile = "profile";
  static const settings = "settings";
  static const athletePreferences = "athlete-edit-preferences";
  static const businessPreferences = "business-edit-preferences";
  static const browse = "browse";
  static const matches = "matches";
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
      builder: (_, state) => const AthleteSignUpPage(),
      routes: [
        GoRoute(
          path: "preferences",
          name: Routes.athletePreferences,
          builder: (_, __) => const AthleteSignUpPage(editPreferences: true),
        ),
      ],
    ),
    GoRoute(
      path: "/${Routes.signUpBusiness}",
      name: Routes.signUpBusiness,
      builder: (_, __) => const BusinessSignUpPage(),
      routes: [
        GoRoute(
          path: "preferences",
          name: Routes.businessPreferences,
          builder: (_, __) => const BusinessSignUpPage(editPreferences: true),
        ),
      ],
    ),
    GoRoute(
      path: "/${Routes.profile}",
      name: Routes.profile,
      redirect: loginRedirect,
      builder: (_, __) => const HomeShell(ChannilDestination.profile),
      routes: [
        GoRoute(
          path: ":id",
          builder: (_, state) => HomeShell(
            ChannilDestination.profile, 
            userID: state.pathParameters["id"],
          ),
        ),
      ],
    ),
    GoRoute(
      path: "/${Routes.browse}",
      name: Routes.browse,
      redirect: loginRedirect,
      builder: (_, __) => const HomeShell(ChannilDestination.swipes),
    ),
    GoRoute(
      path: "/${Routes.matches}",
      name: Routes.matches,
      redirect: loginRedirect,
      builder: (_, __) => const HomeShell(ChannilDestination.matches),
    ),
    GoRoute(
      path: "/${Routes.settings}",
      name: Routes.settings,
      redirect: loginRedirect,
      builder: (_, __) => SettingsPage(),
    ),
  ],
);
