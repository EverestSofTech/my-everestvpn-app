import 'dart:convert';

class SettingsModel {
  bool status;
  List<Setting> settings;

  SettingsModel({
    required this.status,
    required this.settings,
  });

  factory SettingsModel.fromRawJson(String str) =>
      SettingsModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SettingsModel.fromJson(Map<String, dynamic> json) => SettingsModel(
        status: json["status"],
        settings: List<Setting>.from(
            json["settings"].map((x) => Setting.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "settings": List<dynamic>.from(settings.map((x) => x.toJson())),
      };
}

class Setting {
  int success;
  String appName;
  String privacyPolicyUrl;
  String publisherId;
  String interstitialAd;
  String bannerAd;
  String interstitialAdClick;
  String rewardedVideoAds;
  String rewardedVideoAdsId;
  String rewardedVideoClick;
  String watermarkImage;
  String watermarkOnOff;
  String bannerAdType;
  String bannerAdId;
  String interstitialAdType;
  String interstitialAdId;
  String onesignalAppId;
  String onesignalRestKey;
  String appUpdateStatus;
  String appNewVersion;
  String appUpdateDesc;
  String appRedirectUrl;
  String cancelUpdateStatus;

  Setting({
    required this.success,
    required this.appName,
    required this.privacyPolicyUrl,
    required this.publisherId,
    required this.interstitialAd,
    required this.bannerAd,
    required this.interstitialAdClick,
    required this.rewardedVideoAds,
    required this.rewardedVideoAdsId,
    required this.rewardedVideoClick,
    required this.watermarkImage,
    required this.watermarkOnOff,
    required this.bannerAdType,
    required this.bannerAdId,
    required this.interstitialAdType,
    required this.interstitialAdId,
    required this.onesignalAppId,
    required this.onesignalRestKey,
    required this.appUpdateStatus,
    required this.appNewVersion,
    required this.appUpdateDesc,
    required this.appRedirectUrl,
    required this.cancelUpdateStatus,
  });

  factory Setting.fromRawJson(String str) => Setting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        success: json["success"],
        appName: json["app_name"],
        privacyPolicyUrl: json["privacy_policy_url"],
        publisherId: json["publisher_id"],
        interstitialAd: json["interstitial_ad"],
        bannerAd: json["banner_ad"],
        interstitialAdClick: json["interstitial_ad_click"],
        rewardedVideoAds: json["rewarded_video_ads"],
        rewardedVideoAdsId: json["rewarded_video_ads_id"],
        rewardedVideoClick: json["rewarded_video_click"],
        watermarkImage: json["watermark_image"],
        watermarkOnOff: json["watermark_on_off"],
        bannerAdType: json["banner_ad_type"],
        bannerAdId: json["banner_ad_id"],
        interstitialAdType: json["interstitial_ad_type"],
        interstitialAdId: json["interstitial_ad_id"],
        onesignalAppId: json["onesignal_app_id"],
        onesignalRestKey: json["onesignal_rest_key"],
        appUpdateStatus: json["app_update_status"],
        appNewVersion: json["app_new_version"],
        appUpdateDesc: json["app_update_desc"],
        appRedirectUrl: json["app_redirect_url"],
        cancelUpdateStatus: json["cancel_update_status"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "app_name": appName,
        "privacy_policy_url": privacyPolicyUrl,
        "publisher_id": publisherId,
        "interstitial_ad": interstitialAd,
        "banner_ad": bannerAd,
        "interstitial_ad_click": interstitialAdClick,
        "rewarded_video_ads": rewardedVideoAds,
        "rewarded_video_ads_id": rewardedVideoAdsId,
        "rewarded_video_click": rewardedVideoClick,
        "watermark_image": watermarkImage,
        "watermark_on_off": watermarkOnOff,
        "banner_ad_type": bannerAdType,
        "banner_ad_id": bannerAdId,
        "interstitial_ad_type": interstitialAdType,
        "interstitial_ad_id": interstitialAdId,
        "onesignal_app_id": onesignalAppId,
        "onesignal_rest_key": onesignalRestKey,
        "app_update_status": appUpdateStatus,
        "app_new_version": appNewVersion,
        "app_update_desc": appUpdateDesc,
        "app_redirect_url": appRedirectUrl,
        "cancel_update_status": cancelUpdateStatus,
      };
}
