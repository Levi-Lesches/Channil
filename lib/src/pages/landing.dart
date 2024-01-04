import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

extension on Widget {
  Widget widen() => SizedBox(width: double.infinity, child: this);
}

class LandingPage extends ReactiveWidget<LandingViewModel> {
  @override
  LandingViewModel createModel() => LandingViewModel();
  
  @override
  Widget build(BuildContext context, LandingViewModel model) => Scaffold(
    body: Center(
      child: Padding(padding: const EdgeInsets.symmetric(horizontal: 48),  child: Column(
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
              child: Text(
                "Sign in with Google", 
                style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ).widen(),
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
      ),
    ),),
  );
}
