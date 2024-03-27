import "package:channil/data.dart";
import "package:channil/services.dart";
import "package:channil/widgets.dart";
import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";

class SettingsPage extends StatelessWidget {  
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Settings"),
      leading: IconButton(
        icon: const Icon(Icons.home),
        onPressed: () => router.go("/profile"),
      ),
    ),
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
              onTap: () => context.push("${Routes.signUpAthlete}/info"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Images"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("${Routes.signUpAthlete}/images"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Prompts"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("${Routes.signUpAthlete}/prompts"),
              visualDensity: VisualDensity.compact,
            ),
          ],
          handleBusiness: (_) => [
            ListTile(
              title: const Text("Basic information"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("${Routes.signUpBusiness}/info"),
              visualDensity: VisualDensity.compact,
            ),
            ListTile(
              title: const Text("Images"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push("${Routes.signUpBusiness}/images"),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        const SizedBox(height: 4),
        ListTile(
          title: Text("Deal Preferences", style: context.textTheme.headlineSmall),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => models.user.channilUser?.matchProfileType(
            handleAthlete: (_) => context.push("${Routes.signUpAthlete}/preferences"),
            handleBusiness: (_) => context.push("${Routes.signUpBusiness}/preferences"),
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
        const Divider(),
        const SizedBox(height: 4),
        ListTile(
          title: Text(
            "Log out", 
            style: context.textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          onTap: () => logOut(context),
        ),
        ListTile(
          title: Text(
            "Delete Account", 
            style: context.textTheme.headlineSmall?.copyWith(color: Colors.red),
          ),
          subtitle: const Text("This is permanent and can not be undone"),
          onTap: () => deleteAccount(context),
        ),
      ],
    ),
  );

  Future<void> logOut(BuildContext context) async { 
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
    context.go(Routes.login);
  }

  Future<void> deleteAccount(BuildContext context) => showDialog(
    context: context,
    builder: (context) => DeleteAccountDialog(),
  );
}

class DeleteAccountViewModel extends ViewModel {
  late final ChannilUser user = models.user.channilUser!;
  String get email => user.email;
  final controller = TextEditingController();
  bool authenticated = false;
  bool get isReady => showAuth 
    ? authenticated
    : controller.text == email;

  @override
  Future<void> init() async => controller.addListener(notifyListeners);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  bool showAuth = false;
  Future<void> delete() async {
    await services.database.deleteAccount(user.id);
    final result = await services.auth.deleteAccount();
    switch (result) {
      case DeleteAccountResult.ok: router.go("/login");
      case DeleteAccountResult.reauthenticate: 
        await services.auth.signOut();
        showAuth = true;
      case DeleteAccountResult.unknownError: errorText = "An unknown error occurred.\nTry restarting the app.";
    }
    notifyListeners();
  }

  void updateAuth() {
    authenticated = false;
    errorText = null;
    final newEmail = services.auth.user?.email;
    if (newEmail == null) return;
    if (newEmail == email) {
      authenticated = true;
    } else {
      errorText = "Please sign into your $email account";
    }
    notifyListeners();
  }
}

class DeleteAccountDialog extends ReactiveWidget<DeleteAccountViewModel> {
  @override
  DeleteAccountViewModel createModel() => DeleteAccountViewModel();

  @override
  Widget build(BuildContext context, DeleteAccountViewModel model) => AlertDialog(
    title: const Text("Delete account"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (model.showAuth) ...[
          Text(
            "Please re-authenticate",
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          SignInWidget(onSignIn: model.updateAuth),
          if (model.errorText != null) 
            Text(model.errorText!, style: const TextStyle(color: Colors.red)),
        ] else ...[
          Text(
            "This is a permanent action and cannot be undone. Please be sure before confirming", 
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          const Text("To confirm, please enter your email as shown in the Account Info section of the settings page."),
          const SizedBox(height: 12),
          ChannilTextField(
            controller: model.controller,
            hint: "Email",
            action: TextInputAction.done,
            capitalization: TextCapitalization.none,
            type: TextInputType.emailAddress,
            isRequired: true,
          ),
        ],
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text("Cancel"),
      ),
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: model.isReady ? model.delete : null,
        child: const Text("Confirm", style: TextStyle(color: Colors.white)),
      ),
    ],
  );
}
