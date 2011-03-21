//
//  CDictionaryRepresentation.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/21/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol CPropertyListRepresentation <NSObject>

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;

@end
