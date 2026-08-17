#import "YTLite.h"

static const NSInteger YouLitePlusSection = 789;
static NSString *const YouLitePlusItemIdentifier = @"YouLitePlusSectionItem";

@interface YTSettingsSectionItemManager (YouLitePlus)
- (void)updateYouLitePlusSectionWithEntry:(id)entry;
@end

static YTSettingsSectionItem *YouLitePlusSwitch(NSString *title, NSString *key) {
    return [%c(YTSettingsSectionItem) switchItemWithTitle:title
        titleDescription:nil
        accessibilityIdentifier:YouLitePlusItemIdentifier
        switchOn:ytlBool(key)
        switchBlock:^BOOL(YTSettingsCell *cell, BOOL enabled) {
            ytlSetBool(enabled, key);
            return YES;
        }
        settingItemId:0];
}

// The old code only added the section when category 1 existed. That is no
// longer true in newer YouTube versions, so the menu was silently omitted.
%hook YTAppSettingsPresentationData
+ (NSArray *)settingsCategoryOrder {
    NSArray *order = %orig;
    NSMutableArray *mutableOrder = [order mutableCopy] ?: [NSMutableArray array];
    NSNumber *section = @(YouLitePlusSection);
    [mutableOrder removeObject:section];
    [mutableOrder insertObject:section atIndex:0];
    return mutableOrder;
}
%end

%hook YTSettingsSectionItemManager
%new(v@:@)
- (void)updateYouLitePlusSectionWithEntry:(id)entry {
    YTSettingsViewController *settingsViewController = [self valueForKey:@"_settingsViewControllerDelegate"];
    if (!settingsViewController) return;

    NSMutableArray<YTSettingsSectionItem *> *items = [NSMutableArray arrayWithArray:@[
        YouLitePlusSwitch(@"Remove Ads", @"noAds"),
        YouLitePlusSwitch(@"Background Playback", @"backgroundPlayback"),
        YouLitePlusSwitch(@"Premium Logo", @"premiumYTLogo"),
    ]];

    BOOL supportsIcon = [settingsViewController respondsToSelector:@selector(setSectionItems:forCategory:title:icon:titleDescription:headerHidden:)];
    if (supportsIcon) {
        [settingsViewController setSectionItems:items forCategory:YouLitePlusSection title:@"YouLite+" icon:nil titleDescription:@"hieucocc · forked from dayanch96" headerHidden:NO];
    } else {
        [settingsViewController setSectionItems:items forCategory:YouLitePlusSection title:@"YouLite+" titleDescription:@"hieucocc · forked from dayanch96" headerHidden:NO];
    }
}

- (void)updateSectionForCategory:(NSUInteger)category withEntry:(id)entry {
    if (category == YouLitePlusSection) {
        [self updateYouLitePlusSectionWithEntry:entry];
        return;
    }
    %orig;
}
%end
