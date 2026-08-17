#import "YouLiteOptionsController.h"
#import "YTKACERootOptionsController.h"
#import "../Runtime/Preferences.h"

static NSString * const YouLitePremiumLogoKey = @"YTKACE.Preference.Navigation.PremiumLogo";

@interface YouLiteOptionsController ()
@property(nonatomic, copy) NSArray<NSDictionary<NSString *, NSString *> *> *options;
@end

@implementation YouLiteOptionsController

- (instancetype)init {
    return [super initWithStyle:UITableViewStyleInsetGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YouLite+";
    self.options = @[
        @{@"title": @"Block ads", @"detail": @"Hide YouTube ads", @"key": YTKACENoAdsKey},
        @{@"title": @"SponsorBlock", @"detail": @"Automatically skip sponsored segments", @"key": YTKACESponsorBlockKey},
        @{@"title": @"Background playback", @"detail": @"Keep audio playing outside the app", @"key": YTKACEBackgroundPlaybackKey},
        @{@"title": @"Picture in Picture", @"detail": @"Show a PiP button in the player", @"key": YTKACEPiPKey},
        @{@"title": @"Premium logo", @"detail": @"Use the YouTube Premium logo", @"key": YouLitePremiumLogoKey}
    ];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemClose
                             target:self action:@selector(closeSettings)];
    self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    YTKACEApplyAppearance(self);
    self.tableView.backgroundColor = self.view.backgroundColor;
    [self.tableView reloadData];
}

- (void)closeSettings {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    (void)tableView;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    (void)tableView;
    return section == 0 ? self.options.count : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    (void)tableView;
    return section == 0 ? @"YOU LITE+" : @"CREDITS";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    (void)tableView;
    return section == 0
        ? @"Changes apply immediately. Restart YouTube if the logo does not refresh."
        : @"Tweak: YouLite+\nAuthor/Maintainer: hieucocc\nBased on: YTKACE by itzzace";
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"about"];
        if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                       reuseIdentifier:@"about"];
        cell.textLabel.text = @"YouLite+";
        cell.detailTextLabel.text = @"Lightweight YouTube essentials";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toggle"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                                   reuseIdentifier:@"toggle"];
    NSDictionary<NSString *, NSString *> *option = self.options[(NSUInteger)indexPath.row];
    cell.textLabel.text = option[@"title"];
    cell.detailTextLabel.text = option[@"detail"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *toggle = [UISwitch new];
    toggle.on = YTKACEFeatureEnabled(option[@"key"]);
    toggle.accessibilityIdentifier = option[@"key"];
    [toggle addTarget:self action:@selector(toggleChanged:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = toggle;
    return cell;
}

- (void)toggleChanged:(UISwitch *)toggle {
    YTKACESetPreference(toggle.accessibilityIdentifier, toggle.on);
}

@end

UINavigationController *YouLiteMakeSettingsNavigationController(void) {
    YouLiteOptionsController *root = [YouLiteOptionsController new];
    UINavigationController *navigation = [[UINavigationController alloc]
        initWithRootViewController:root];
    navigation.modalPresentationStyle = UIModalPresentationPageSheet;
    return navigation;
}
