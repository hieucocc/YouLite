#import "YTLite.h"

// YouLite+ intentionally keeps a very small hook surface. The original
// YTLite feed/collection hooks mutate YouTube's internal renderers and are
// not safe on newer YouTube builds (including 21.x).

// Background playback (YouTube-X / PoomSmart)
%hook YTIPlayabilityStatus
- (BOOL)isPlayableInBackground { return ytlBool(@"backgroundPlayback") ? YES : %orig; }
%end

%hook MLVideo
- (BOOL)playableInBackground { return ytlBool(@"backgroundPlayback") ? YES : %orig; }
%end

// Advertising and Premium prompts. These hooks avoid altering Home feed
// renderer arrays, which was the source of blank feeds with newer YouTube.
%hook YTIPlayerResponse
- (BOOL)isMonetized { return ytlBool(@"noAds") ? NO : %orig; }
%end

%hook YTAdsInnerTubeContextDecorator
- (void)decorateContext:(id)context { if (!ytlBool(@"noAds")) %orig; }
%end

%hook YTAccountScopedAdsInnerTubeContextDecorator
- (void)decorateContext:(id)context { if (!ytlBool(@"noAds")) %orig; }
%end

%hook YTCommerceEventGroupHandler
- (void)addEventHandlers { if (!ytlBool(@"noAds")) %orig; }
%end

%hook YTInterstitialPromoEventGroupHandler
- (void)addEventHandlers { if (!ytlBool(@"noAds")) %orig; }
%end

%hook YTPromosheetEventGroupHandler
- (void)addEventHandlers { if (!ytlBool(@"noAds")) %orig; }
%end

%hook YTPromoThrottleController
- (BOOL)canShowThrottledPromo { return ytlBool(@"noAds") ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCap:(id)arg1 { return ytlBool(@"noAds") ? NO : %orig; }
- (BOOL)canShowThrottledPromoWithFrequencyCaps:(id)arg1 { return ytlBool(@"noAds") ? NO : %orig; }
%end

%hook YTIShowFullscreenInterstitialCommand
- (BOOL)shouldThrottleInterstitial { return ytlBool(@"noAds") ? YES : %orig; }
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
