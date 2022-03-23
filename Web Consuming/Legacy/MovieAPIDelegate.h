//
//  MovieAPIDelegate.h
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MovieAPIDelegate <NSObject>

-(void)receivedMovieList:(NSData*) json from:(FetchOption) option;
-(void)receivedMovieDetails:(NSData*) json for:(Movie*) movie;
-(void)fetchedFailedWithError:(NSError*) error;

@end

NS_ASSUME_NONNULL_END
