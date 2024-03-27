import "package:channil/main.dart";
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

import "package:channil/data.dart";

class Routes {
  static const landing = "/";
  static const login = "/login";
  static const signUpAthlete = "/athlete-sign-up";
  static const signUpBusiness = "/business-sign-up";
  static const profile = "/profile";
  static const settings = "/settings";
  static const browse = "/browse";
  static const matches = "/matches";
  static const chats = "/chats";
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
      path: Routes.login,
      builder: (_, __) => Title(
        title: "Channil -- Login",
        color: channilColor,
        child: LandingPage(),
      ),
    ),
    GoRoute(
      path: Routes.signUpAthlete,
      builder: (_, state) => Title(
        title: "Sign up -- Athlete",
        color: channilColor,
        child: const AthleteSignUpPage(),
      ),
      routes: [
        GoRoute(
          path: "info",
          builder: (_, __) => Title(
            title: "Athlete -- Info",
            color: channilColor,
            child: const AthleteSignUpPage(startIndex: 1, endIndex: 1),
          ),
        ),
        GoRoute(
          path: "images",
          builder: (_, __) => Title(
            title: "Athlete -- Images",
            color: channilColor,
            child: const AthleteSignUpPage(startIndex: 2, endIndex: 2,),
          ),
        ),
        GoRoute(
          path: "prompts",
          builder: (_, __) => Title(
            title: "Athlete -- Prompts",
            color: channilColor,
            child: const AthleteSignUpPage(startIndex: 3, endIndex: 3),
          ),
        ),
        GoRoute(
          path: "preferences",
          builder: (_, __) => Title(
            title: "Athlete -- Preferences",
            color: channilColor,
            child: const AthleteSignUpPage(startIndex: 4, endIndex: 4),
          ),
        ),
      ],
    ),
    GoRoute(
      path: Routes.signUpBusiness,
      builder: (_, __) => Title(
        title: "Sign up -- Business",
        color: channilColor,
        child: const BusinessSignUpPage(),
      ),
      routes: [
        GoRoute(
          path: "info",
          builder: (_, __) => Title(
            title: "Business -- Info",
            color: channilColor,
            child: const BusinessSignUpPage(startIndex: 1, endIndex: 1),
          ),
        ),
        GoRoute(
          path: "images",
          builder: (_, __) => Title(
            title: "Business -- Images",
            color: channilColor,
            child: const BusinessSignUpPage(startIndex: 2, endIndex: 2,),
          ),
        ),
        GoRoute(
          path: "preferences",
          builder: (_, __) => Title(
            title: "Business -- Preferences",
            color: channilColor,
            child: const BusinessSignUpPage(startIndex: 3, endIndex: 3),
          ),
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: Title(
          title: state.topRoute?.name ?? "Channil",
          color: channilColor,
          child: HomeShell(child: child),
        ),
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.browse,
              name: "Browse",
              redirect: loginRedirect,
              builder: (_, __) => BrowsePage(HomeModel(1)),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.matches,
              name: "My Matches",
              redirect: loginRedirect,
              builder: (_, __) => MatchesPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.chats,
              name: "All Chats",
              redirect: loginRedirect,
              builder: (_, __) => ChatsPage(),
              routes: [
                GoRoute(
                  path: ":id",
                  name: "Chat",
                  builder: (context, state) => ChatPage(state.pathParameters["id"] as ConnectionID),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: Routes.profile,
              name: "My Profile",
              redirect: loginRedirect,
              builder: (_, __) => ProfilePage(showAppBar: true, HomeModel(0)),
              routes: [
                GoRoute(
                  path: ":id",
                  name: "View Profile",
                  builder: (context, state) => ProfilePage(HomeModel(0), showAppBar: true, user: state.pathParameters["id"] as UserID),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: Routes.settings,
      redirect: loginRedirect,
      builder: (_, __) => Title(
        title: "Settings",
        color: channilColor,
        child: SettingsPage(),
      ),
    ),
  ],
);
