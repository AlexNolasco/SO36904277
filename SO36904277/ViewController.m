//
//  ViewController.m
//  SO36904277
//
//  Created by alexander nolasco on 5/5/16.
//  Copyright © 2016 coladapp.com. All rights reserved.
//

#import "ViewController.h"
#import "IGXMLReader.h"
@interface ViewController ()
@property(weak, nonatomic) IBOutlet UILabel *labelResult;

@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSDictionary *result = [self retrieveDataFromXml:[self xmlString]];
  [[self labelResult]
      setText:[NSString stringWithFormat:@"%d", [result count]]];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSDictionary *)retrieveDataFromXml:(NSString *)xml {
  NSMutableDictionary *dictionary =
      [[NSMutableDictionary alloc] initWithCapacity:200];
  NSString *key;
  for (IGXMLReader *node in [[IGXMLReader alloc] initWithXMLString:xml]) {
    if ([node type] == IGXMLReaderNodeTypeElement &&
        [[node name] hasPrefix:@"Key"]) {
      key = [node text];
    } else if ([node type] == IGXMLReaderNodeTypeElement &&
               [[node name] hasPrefix:@"Value"] && [key length]) {
      [dictionary setObject:[node text] forKey:key];
      key = nil;
    }
  }
  return [dictionary copy];
}

/** just for demo purposes, this is **NOT** how you generate XML with
 * Objective-C */
- (NSString *)xmlString {
  NSString *begin = @"<ArrayOfKeyValueOfstringPunchListCellModel84zsBx89 "
                    @"xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" "
                    @"xmlns=\"http://schemas.microsoft.com/2003/10/"
                    @"Serialization/Arrays\">";

  NSString *end = @"</ArrayOfKeyValueOfstringPunchListCellModel84zsBx89>";

  NSMutableString *xml = [[NSMutableString alloc] initWithCapacity:5000];
  [xml appendString:begin];
  for (NSInteger i = 0; i < 100; i += 1) {
    [xml appendFormat:
             @"<KeyValueOfstringPunchListCellModel84zsBx89><Key>%d</Key>", i];
    [xml appendFormat:@"<Value "
                      @"xmlns:d3p1=\"http://schemas.datacontract.org/2004/07/"
                      @"LHS.Models\">some-value-%d</Value>",
                      i * 2];
    [xml appendString:@"</KeyValueOfstringPunchListCellModel84zsBx89>"];
  }
  [xml appendString:end];
  return [xml copy];
}
@end
