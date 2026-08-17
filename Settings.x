#import "YTLite.h"

@interface YouLitePlusSettingsController : UITableViewController
@end

@implementation YouLitePlusSettingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"YouLite+";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleInsetGrouped];
    self.tableView.accessibilityIdentifier = @"YouLitePlusSettings";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 3; }

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Author/Maintainer: hieucocc\nForked from: dayanch96";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const cellID = @"YouLitePlusSwitch";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

    NSArray<NSString *> *titles = @[ @"Remove Ads", @"Background Playback", @"Premium Logo" ];
    NSArray<NSString *> *keys = @[ @"noAds", @"backgroundPlayback", @"premiumYTLogo" ];
    cell.textLabel.text = titles[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UISwitch *toggle = [[UISwitch alloc] init];
    toggle.tag = indexPath.row;
    toggle.on = ytlBool(keys[indexPath.row]);
    [toggle addTarget:self action:@selector(changeSetting:) forControlEvents:UIControlEventValueChanged];
    cell.accessoryView = toggle;
    return cell;
}

- (void)changeSetting:(UISwitch *)toggle {
    NSArray<NSString *> *keys = @[ @"noAds", @"backgroundPlayback", @"premiumYTLogo" ];
    ytlSetBool(toggle.on, keys[toggle.tag]);
}

@end

%hook YTSettingsViewController

%new
- (void)youLitePlusOpenSettings {
    YouLitePlusSettingsController *controller = [[YouLitePlusSettingsController alloc] initWithStyle:UITableViewStyleInsetGrouped];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    %orig;
    UIBarButtonItem *item = self.navigationItem.rightBarButtonItem;
    if (![item.title isEqualToString:@"YouLite+"]) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"YouLite+" style:UIBarButtonItemStylePlain target:self action:@selector(youLitePlusOpenSettings)];
    }
}

%end
