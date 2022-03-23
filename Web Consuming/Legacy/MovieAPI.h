//
//  NSObject+MovieAPI.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;
@protocol MovieAPIDelegate;
 
@interface MovieAPI: NSObject

typedef NS_ENUM(NSInteger, FetchOption) {
    FetchNowPlaying,
    FetchPopular,
    FetchSearch,
};

@property (weak, nonatomic) id delegate;

-(void)fetchMovieList:(FetchOption) option;
-(void)fetchMovieDetails:(Movie*) movie;
-(void)searchMoviesWith:(NSString*) keywords;

@end

NS_ASSUME_NONNULL_END
