//
//  NSObject+Parser.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;

@interface Parser: NSObject

+(NSArray*)movieListFromJSON:(NSData*) json error:(NSError**) error;
+(void)detailsForMovie:(Movie*) movie from:(NSData*) json error:(NSError**) error;

@end

NS_ASSUME_NONNULL_END
