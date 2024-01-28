import "package:channil/widgets.dart";
import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";
import "package:channil/pages.dart";

class SettingsPage extends StatelessWidget {  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Settings")),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          title: Text("Account", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
          subtitle: Text("${models.user.channilUser!.name}\n${models.user.channilUser!.email}"),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Edit Profile", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => switch(models.user.channilUser!.profile) {
            AthleteProfile() => context.pushNamed(Routes.signUpAthlete),
            BusinessProfile() => context.pushNamed(Routes.signUpBusiness),
          },
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Deal Preferences", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => switch(models.user.channilUser!.profile) {
            AthleteProfile() => context.pushNamed(Routes.athletePreferences),
            BusinessProfile() => context.pushNamed(Routes.businessPreferences),
          },
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Notifications", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("About", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Terms and conditions", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text(
            "Log out", 
            style: context.textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          onTap: () async { 
            await models.user.signOut();
            if (!context.mounted) return;
            context.goNamed(Routes.login);
          },
        ),
      ],
    ),
  );
}
