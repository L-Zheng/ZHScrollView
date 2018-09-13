

#pragma mark - separator分割线
"没有数据时 去掉分割线
self.tableView.tableFooterView = [UIView new];


#pragma mark - selection
"tableviewcell 被选中时，label的背景色被还原成透明
// If you're targeting iOS 6, set the label's background color to clear
// This must be done BEFORE changing the layer's backgroundColor
cell.textLabel.backgroundColor = [UIColor clearColor];
// Set layer background color
cell.textLabel.layer.backgroundColor = [UIColor blueColor].CGColor;

"cell更换选中背景颜色
// Default is nil for cells in UITableViewStylePlain, and non-nil for UITableViewStyleGrouped
UIView *view = [UIView new];
view.backgroundColor = [UIColor orangeColor];
cell.selectedBackgroundView = view;

#pragma mark - header footer
"设置背景颜色
UITableViewHeaderFooterView --> headerView.contentView.backgroundColor = [UIColor whiteColor];





















