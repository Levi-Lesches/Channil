import "package:channil/widgets.dart";
import "package:flutter/material.dart";

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
          title: Text("Account Info", style: context.textTheme.headlineSmall),
          subtitle: Text("${models.user.channilUser!.name}\n${models.user.channilUser!.email}"),
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Edit Profile", style: context.textTheme.headlineSmall),
        ),
        ...models.user.channilUser!.matchProfileType<List<Widget>>(
          handleAthlete: (_) => [
            ListTile(
              title: const Text("Basic information"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("/${Routes.signUpAthlete}/info"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Images"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("/${Routes.signUpAthlete}/images"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Prompts"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("/${Routes.signUpAthlete}/prompts"),
              visualDensity: VisualDensity.compact,
            ),
          ],
          handleBusiness: (_) => [
            ListTile(
              title: const Text("Basic information"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("/${Routes.signUpBusiness}/info"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Images"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("/${Routes.signUpBusiness}/images"),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Deal Preferences", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => models.user.channilUser?.matchProfileType(
            handleAthlete: (_) => context.pushNamed(Routes.athletePreferences),
            handleBusiness: (_) => context.pushNamed(Routes.businessPreferences),
          ),
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
            final result = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Are you sure you want to log out?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("Confirm"),
                  ),
                ],
              ),
            );
            if (result != true) return;
            await models.user.signOut();
            if (!context.mounted) return;
            context.goNamed(Routes.login);
          },
        ),
      ],
    ),
  );
}
