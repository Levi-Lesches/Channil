import "package:flutter/material.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/widgets.dart";

const description = "The Ultimate CHANNIL of connection for empowered athletes seeking endorsements and NIL opportunities with passionate businesses.";

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
          Text(description, style: context.textTheme.titleLarge, textAlign: TextAlign.center),
          Expanded(child: Center(child: ListView(shrinkWrap: true, children: [
          if (model.state == 0) ...[
            SignInWidget(onSignIn: model.onAuth),
            const SizedBox(height: 8),
            Text(
              "or",
              style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
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
              onPressed: () => context.push(Routes.signUpAthlete),
              child: Text(
                "Athlete", 
                style: context.textTheme.titleLarge?.copyWith(fontSize: 20),
              ),
            ).widen(),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => context.push(Routes.signUpBusiness),
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
          ],],),),),
        ],
      ),),
    ),),
  );
}
