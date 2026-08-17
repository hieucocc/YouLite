#import "YTLite.h"

// Core ad and background hooks are aligned with the current YouTube-X source
// (PoomSmart). Unlike the legacy YTLite hooks, these do not mutate Home-feed
// renderer arrays.

%hook YTIPlayerResponse
%new(@@:)
- (NSMutableArray *)playerAdsArray {
    return ytlBool(@"noAds") ? [NSMutableArray array] : nil;
}
%new(@@:)
- (NSMutableArray *)adSlotsArray {
    return ytlBool(@"noAds") ? [NSMutableArray array] : nil;
}
%end

%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return ytlBool(@"backgroundPlayback") ? YES : %orig; }
%end

%hook MLVideo
- (BOOL)playableInBackground { return ytlBool(@"backgroundPlayback") ? YES : %orig; }
%end

%hook YTIBackgroundOfflineSettingCategoryEntryRenderer
%new(B@:)
- (BOOL)isBackgroundEnabled { return ytlBool(@"backgroundPlayback"); }
%end

%hook YTAdShieldUtils
+ (id)spamSignalsDictionary { return ytlBool(@"noAds") ? @{} : %orig; }
+ (id)spamSignalsDictionaryWithoutIDFA { return ytlBool(@"noAds") ? @{} : %orig; }
%end

%hook YTDataUtils
+ (id)spamSignalsDictionary { return ytlBool(@"noAds") ? @{ @"ms": @"" } : %orig; }
+ (id)spamSignalsDictionaryWithoutIDFA { return ytlBool(@"noAds") ? @{} : %orig; }
%end

%hook YTLocalPlaybackController
- (id)createAdsPlaybackCoordinator { return ytlBool(@"noAds") ? nil : %orig; }
%end

%hook MDXSession
- (void)adPlaying:(id)ad { if (!ytlBool(@"noAds")) %orig; }
%end

%hook MDXSessionImpl
- (void)adPlaying:(id)ad { if (!ytlBool(@"noAds")) %orig; }
%end

// Premium prompts
%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return ytlBool(@"noAds") ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return ytlBool(@"noAds") ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return ytlBool(@"noAds") ? NO : %orig; }
%end

// Premium logo
%hook UIImageView
- (void)setImage:(UIImage *)image {
    if (ytlBool(@"premiumYTLogo")) {
        NSString *resourcesPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Frameworks/Module_Framework.framework/Innertube_Resources.bundle"];
        NSBundle *frameworkBundle = [NSBundle bundleWithPath:resourcesPath];
        if ([[image description] containsString:@"Resources: youtube_logo)"]) {
            image = [UIImage imageNamed:@"youtube_premium_logo" inBundle:frameworkBundle compatibleWithTraitCollection:nil];
        } else if ([[image description] containsString:@"Resources: youtube_logo_dark)"]) {
            image = [UIImage imageNamed:@"youtube_premium_logo_white" inBundle:frameworkBundle compatibleWithTraitCollection:nil];
        }
    }
    %orig(image);
}
%end
