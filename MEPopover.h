//
//  MEPopover.h
//  Completion
//
//  Created by Andrey M on 15.10.14.
//  Copyright (c) 2014 Andrey M. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <KFOpenWeatherMapAPI/KFOpenWeatherMapAPIClient.h>

@interface MEPopover : NSViewController <NSTextFieldDelegate>

@property (weak) IBOutlet NSArrayController *arrayController;

@property KFOpenWeatherMapAPIClient *apiClient;

@property (weak) IBOutlet NSSearchField *searchField;
@property (weak) IBOutlet NSPopover *popover;

- (IBAction)searchItem:(id)sender;
@property (weak) IBOutlet NSTableView *itemsView;
@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end
