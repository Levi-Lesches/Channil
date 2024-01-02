import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

class LandingPage extends ReactiveWidget<LandingViewModel> {
  @override
  LandingViewModel createModel() => LandingViewModel();
  
  @override
  Widget build(BuildContext context, LandingViewModel model) => Scaffold(
    body: Center(
      child: Column(
        children: [
          const SizedBox(height: 48),
          const ChannilLogo(),
          if (model.isLoading) ...[
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
          const Spacer(flex: 3),
          if (model.state == 0) ...[
            OutlinedButton(
              onPressed: model.signIn,
              child: const Text("Sign in with Google"),
            ),
            const SizedBox(height: 8),
            const Text("or"),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: model.next,
              child: const Text("Sign up"),
            ),
          ] else if (model.state == 1) ...[
            OutlinedButton(
              onPressed: () => context.pushNamed(Routes.signUpAthlete),
              child: const Text("Athlete"),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.pushNamed(Routes.signUpBusiness),
              child: const Text("Business"),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: model.back,
              child: const Text("Back"),
            ),
          ],
          const Spacer(),
        ],
      ),
    ),
  );
}
