import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

const description = "The Ultimate CHANNIL of connection for empowered athletes seeking endorsements and NIL opportunities with passionate businesses.";

extension on Widget {
  Widget widen() => SizedBox(width: double.infinity, child: this);
}

class LandingPage extends ReactiveWidget<LandingViewModel> {
  @override
  LandingViewModel createModel() => LandingViewModel();
  
  @override
  Widget build(BuildContext context, LandingViewModel model) => Scaffold(
    appBar: AppBar(),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48), 
        child: SizedBox(width: 500, child: Column(
        children: [
          const SizedBox(height: 48),
          const ChannilLogo(),
          Expanded(
            flex: 3,
            child: Center(
              child: Text(description, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
            ),
          ),
          if (model.state == 0) ...[
            GoogleAuthButton(signUp: false),
            if (models.user.uid != null && !models.user.hasAccount) 
              const Text("No account exists for that email. Please sign up below", style: TextStyle(color: Colors.red)),
            const SizedBox(height: 8),
            Text(
              "or",
              style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: model.next,
              child: Text(
                "Sign up", 
                style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ).widen(),
          ] else if (model.state == 1) ...[
            OutlinedButton(
              onPressed: () => context.pushNamed(Routes.signUpAthlete),
              child: Text(
                "Athlete", 
                style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ).widen(),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pushNamed(Routes.signUpBusiness),
              child: Text(
                "Business", 
                style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ).widen(),
            const SizedBox(height: 24),
            TextButton(
              onPressed: model.back,
              child: const Text("Back"),
            ),
          ],
          const Spacer(),
        ],
      ),),
    ),),
  );
}
