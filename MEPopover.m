//
//  MEPopover.m
//  Completion
//
//  Created by Andrey M on 15.10.14.
//  Copyright (c) 2014 Andrey M. All rights reserved.
//

#import "MEPopover.h"
#import <KFOWMSearchResponseModel.h>
#import <KFOWMWeatherResponseModel.h>

@interface MEPopover ()

@end

@implementation MEPopover

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.apiClient = [[KFOpenWeatherMapAPIClient alloc] initWithAPIKey:@"c805b4b3cca3c0a2b6e93811355d184e" andAPIVersion:@"2.5"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector
{
    BOOL returnValue = NO;
    
    if ([self.popover isShown]) {
        NSInteger currentSelection;
        NSMutableArray *items = self.arrayController.content;
        
        currentSelection = self.arrayController.selectionIndex;
        
        if (commandSelector == @selector(moveUp:)) {
            if ((currentSelection) > 0)
            {
                [self.arrayController setSelectionIndex:(currentSelection - 1)];
                [self.itemsView scrollRowToVisible:(currentSelection - 1)];
            }
            returnValue = YES;
        }
        else if (commandSelector == @selector(moveDown:)) {
            if ((currentSelection + 1) < items.count) {
                [self.arrayController setSelectionIndex:(currentSelection + 1)];
                [self.itemsView scrollRowToVisible:(currentSelection + 1)];
            }
            returnValue = YES;
        }
        else if (commandSelector == @selector(insertTab:)) {
//        else if (commandSelector == @selector(insertTab:) || commandSelector == @selector(insertNewline:)) {
        
            self.searchField.stringValue = [[[self.arrayController content] objectAtIndex:currentSelection] valueForKey:@"title"];
            returnValue = YES;
        }
        else if (commandSelector == @selector(cancelOperation:)) {
            [self.popover close];
            returnValue = YES;
        }
    }

    return returnValue;
}

- (IBAction)searchItem:(id)sender {
    
    if (self.searchField.stringValue.length == 0)
    {
        [self.popover close];
        return;
    }
    
    [self.progressIndicator startAnimation:sender];
    [self.apiClient searchForPhrase:self.searchField.stringValue numberOfResults:10 withResultBlock:^(BOOL success, id responseData, NSError *error)
    {
        if (success)
        {
            NSRange range = NSMakeRange(0, [self.arrayController.arrangedObjects count]);
            [self.arrayController removeObjectsAtArrangedObjectIndexes:[NSIndexSet indexSetWithIndexesInRange:range]];
            
            KFOWMSearchResponseModel *responseModel = (KFOWMSearchResponseModel *)responseData;
            NSMutableArray *foundCities = [NSMutableArray new];
            for (KFOWMWeatherResponseModel *listModel in responseModel.list)
            {
                NSString *city = [NSString stringWithFormat:@"%@, %@", listModel.cityName, listModel.systemInfo];
                [foundCities addObject:city];
                NSObject *systemInfo = (NSObject *)listModel.systemInfo;
                NSLog(@"%@", [systemInfo valueForKey:@"country"]);
                
                [self.arrayController addObject:@{@"title": [NSString stringWithFormat:@"%@, %@", listModel.cityName, [systemInfo valueForKey:@"country"]]}];
            }
            
            [self.arrayController setSelectionIndex:0];
            
            [self.popover showRelativeToRect:self.searchField.bounds ofView:self.searchField preferredEdge:NSMaxYEdge];
            
            [self.searchField becomeFirstResponder];
            [self.progressIndicator stopAnimation:self];
        }
        else
        {
            [self.searchField becomeFirstResponder];
            [self.progressIndicator stopAnimation:self];
            NSLog(@"could not get weather: %@", error);
        }
    }];
}

@end
