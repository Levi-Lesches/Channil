import "package:channil/src/pages/home/browse.dart";
import "package:channil/src/pages/home/chats.dart";
import "package:channil/src/pages/home/matches.dart";
import "package:channil/src/pages/home/profile.dart";
import "package:flutter/material.dart";
import "package:go_router/go_router.dart";
import "package:channil/models.dart";

import "src/pages/chat.dart";
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
  static const profile = "/profile";
  static const settings = "settings";
  static const athletePreferences = "athlete-edit-preferences";
  static const businessPreferences = "business-edit-preferences";
  static const browse = "browse";
  static const matches = "matches";
  static const chats = "chats";
}

String? loginRedirect(BuildContext context, _) => 
  models.user.isAuthenticated && models.user.hasAccount
    ? null : "/login";

final router = GoRouter(
  routes: [
    GoRoute(
      path: "/",
      redirect: (_, __) => Routes.profile,
    ),
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
          path: "info",
          builder: (_, __) => const AthleteSignUpPage(startIndex: 1, endIndex: 1),
        ),
        GoRoute(
          path: "images",
          builder: (_, __) => const AthleteSignUpPage(startIndex: 2, endIndex: 2,),
        ),
        GoRoute(
          path: "prompts",
          builder: (_, __) => const AthleteSignUpPage(startIndex: 3, endIndex: 3),
        ),
        GoRoute(
          path: "preferences",
          name: Routes.athletePreferences,
          builder: (_, __) => const AthleteSignUpPage(startIndex: 4, endIndex: 4),
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
          builder: (_, __) => const BusinessSignUpPage(startIndex: 3, endIndex: 3),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: HomeShell(child: child),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/${Routes.browse}",
              name: Routes.browse,
              redirect: loginRedirect,
              builder: (_, __) => BrowsePage(HomeModel(1)),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/${Routes.matches}",
              name: Routes.matches,
              redirect: loginRedirect,
              builder: (_, __) => MatchesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/${Routes.chats}",
              name: Routes.chats,
              redirect: loginRedirect,
              builder: (_, __) => ChatsPage(),
              routes: [
                GoRoute(
                  path: ":id",
                  builder: (context, state) => ChatPage(state.pathParameters["id"]!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              name: Routes.profile,
              redirect: loginRedirect,
              builder: (_, __) => ProfilePage(showAppBar: true, HomeModel(0)),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: "/${Routes.settings}",
      name: Routes.settings,
      redirect: loginRedirect,
      builder: (_, __) => SettingsPage(),
    ),
  ],
);
