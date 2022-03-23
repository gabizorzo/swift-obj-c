//
//  Movie.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property NSNumber *id;
@property NSString *title;
@property NSString *overview;
@property NSString *genres;
@property NSNumber *popularity;
@property NSNumber *vote_average;
@property NSURL *poster_path;
@property NSData *poster;

@end

NS_ASSUME_NONNULL_END
