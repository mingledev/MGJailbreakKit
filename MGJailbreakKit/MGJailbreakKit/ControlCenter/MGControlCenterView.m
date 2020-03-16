//
//  MGControlCenterView.m
//  MGJailbreakKit
//
//  Created by Mingle on 2020/3/7.
//  Copyright © 2020 Mingle. All rights reserved.
//

#import "MGControlCenterView.h"
#import "Masonry.h"

@interface MGControlCenterSwitchCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) UILabel *titleLbl;
@property (strong, nonatomic) UISwitch *switchCtrl;
@property (strong, nonatomic) UITextField *inputTF;
@property (strong, nonatomic) MGControlCenterItem *item;

@end

@implementation MGControlCenterSwitchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _titleLbl = [UILabel new];
    _titleLbl.textColor = UIColor.whiteColor;
    [self.contentView addSubview:_titleLbl];
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.offset(15);
    }];
    
    _switchCtrl = [[UISwitch alloc] init];
    [_switchCtrl addTarget:self action:@selector(switchValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.contentView addSubview:_switchCtrl];
    [_switchCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.contentView);
       make.right.offset(-15);
    }];
    
    _inputTF = [UITextField new];
    _inputTF.delegate = self;
    _inputTF.placeholder = @"请输入";
    _inputTF.textColor = UIColor.blackColor;
    _inputTF.backgroundColor = UIColor.yellowColor;
    _inputTF.textAlignment = NSTextAlignmentCenter;
    _inputTF.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:_inputTF];
    [_inputTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView).multipliedBy(0.5);
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.switchCtrl.mas_left).offset(-10);
    }];
}

- (void)switchValueChanged {
    [_inputTF endEditing:YES];
    _item.enable = _switchCtrl.isOn;
    if (_item.didMotifyBlock) {
        _item.didMotifyBlock(_item);
    }
}

- (void)setItem:(MGControlCenterItem *)item {
    _item = item;
    _titleLbl.text = item.title;
    _switchCtrl.on = _item.enable;
    _inputTF.text = _item.value;
    _inputTF.hidden = item.type != MGControlCenterItemInput;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    _item.value = textField.text;
    [_switchCtrl sendActionsForControlEvents:UIControlEventValueChanged];
}

@end

@interface MGControlCenterView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UILabel *msgLbl;
@property (assign, nonatomic) BOOL isLaunch;

@end

@implementation MGControlCenterView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = UIColor.blackColor;
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
    [_tableView registerClass:MGControlCenterSwitchCell.class forCellReuseIdentifier:@"MGControlCenterCell"];
    [_tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
    _tableView.backgroundColor = UIColor.clearColor;
    _tableView.rowHeight = 45;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self addSubview:_tableView];
    
    _msgLbl = [UILabel new];
    _msgLbl.textColor = UIColor.whiteColor;
    _msgLbl.textAlignment = NSTextAlignmentCenter;
    _msgLbl.numberOfLines = 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _controlItems.count;
    } else if (section == 1 || section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 || indexPath.section == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        cell.backgroundColor = UIColor.clearColor;
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (indexPath.section == 1) {
            cell.textLabel.text = _isLaunch ? @"关闭" : @"启动";
            cell.textLabel.textColor = UIColor.redColor;
        } else {
            cell.textLabel.text = @"返回";
            cell.textLabel.textColor = UIColor.whiteColor;
        }
        return cell;
    } else {
        MGControlCenterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MGControlCenterCell"];
        cell.backgroundColor = UIColor.clearColor;
        cell.contentView.backgroundColor = UIColor.clearColor;
        cell.item = _controlItems[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [self removeFromSuperview];
        if (_closeCallback) {
            _closeCallback();
        }
    } else if (indexPath.section == 1) {
        if (_isLaunch == NO) {
            _isLaunch = YES;
            [tableView reloadData];
            [self removeFromSuperview];
            if (_closeCallback) {
                _closeCallback();
            }
            if (_launchCallback) {
                _launchCallback();
            }
        } else {
            _isLaunch = NO;
//            for (MGControlCenterItem *temp in self.controlItems) {
//                temp.enable = NO;
//            }
            [tableView reloadData];
            [self removeFromSuperview];
            if (_closeCallback) {
                _closeCallback();
            }
        }
    }
}

- (void)setControlItems:(NSArray<MGControlCenterItem *> *)controlItems {
    _controlItems = controlItems;
    [_tableView reloadData];
}

- (void)setMsg:(NSString *)msg {
    _msgLbl.text = msg;
    if (msg.length) {
        CGSize realSize = [_msgLbl sizeThatFits:[UIScreen mainScreen].bounds.size];
        _msgLbl.frame = CGRectMake(0, 0, realSize.width, realSize.height);
        _tableView.tableHeaderView = _msgLbl;
    } else {
        _tableView.tableHeaderView = nil;
    }
}

- (NSString *)msg {
    return _msgLbl.text;
}

@end
