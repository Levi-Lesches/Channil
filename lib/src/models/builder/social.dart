import "package:flutter/material.dart";

import "package:channil/data.dart";
import "package:channil/models.dart";

const platformHasFollowers = {SocialMediaPlatform.instagram, SocialMediaPlatform.tikTok};

class SocialMediaBuilder extends BuilderModel<SocialMediaProfile> {
  final SocialMediaPlatform platform;
  SocialMediaBuilder(this.platform) {
    usernameController.addListener(notifyListeners);
    urlController.addListener(notifyListeners);
  }

  final usernameController = TextEditingController();
  final urlController = TextEditingController();

  FollowerRange? followerRange;

  bool get needsFollowers => platformHasFollowers.contains(platform);
  bool get showUsername => platform != SocialMediaPlatform.linkedin;

  @override
  bool get isReady => usernameController.text.isNotEmpty
    && followerRange != null
    && (platform.urlPrefix != null || urlController.text.isNotEmpty);

  @override
  SocialMediaProfile get value => SocialMediaProfile(
    platform: platform, 
    username: usernameController.text, 
    followerCount: followerRange!,
    url: urlController.text.isEmpty ? null : urlController.text,
  );

  @override
  void dispose() {
    usernameController.dispose();
    urlController.dispose(); 
    super.dispose();
  }

  void updateRange(FollowerRange? range) {
    if (range == null) return;
    followerRange = range;
    notifyListeners();
  }

  void prefill(SocialMediaProfile profile) {
    usernameController.text = profile.username;
    urlController.text = profile.url ?? "";
    followerRange = profile.followerCount;
    notifyListeners();
  }
}
