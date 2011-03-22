//
//  CVertexBuffer_PropertyListRepresentation.h
//  ModelViewer
//
//  Created by Jonathan Wight on 03/21/11.
//  Copyright 2011 toxicsoftware.com. All rights reserved.
//

#import "CVertexBuffer.h"

#import "CPropertyListRepresentation.h"

@interface CVertexBuffer (CVertexBuffer_PropertyListRepresentation) <CPropertyListRepresentation>

- (id)initWithPropertyListRepresentation:(id)inRepresentation error:(NSError **)outError;

@end
