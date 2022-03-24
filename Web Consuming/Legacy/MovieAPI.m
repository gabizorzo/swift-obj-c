//
//  NSObject+MovieAPI.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import "MovieAPI.h"
#import "MovieAPIDelegate.h"
#import "Movie.h"

#define API_KEY @"5bcebe37f3050767b767d16266b4398d"
#define NOW_PLAYING_URL @"https://api.themoviedb.org/3/movie/now_playing?api_key=%@"
#define POPULAR_URL @"https://api.themoviedb.org/3/movie/popular?api_key=%@"
#define GENRE_URL @"https://api.themoviedb.org/3/genre/movie/list?api_key=%@"
#define DETAILS_URL @"https://api.themoviedb.org/3/movie/%@?api_key=%@"

@implementation MovieAPI
// MARK: - Fetch Movie Details
/* Responsible for getting the movie details from the API.
    Enter: Movie
    Returns: Void (delegate)
 */
-(void)fetchMovieDetails:(Movie *)movie {
    NSString *urlString = [NSString stringWithFormat:DETAILS_URL, movie.id, API_KEY];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSLog(@"%@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"--X-- FETCH MOVIE ERROR");
            NSLog(@"%@", error.localizedDescription);
        } else {
            NSLog(@"--V-- FETCH MOVIE SUCCESS");
            [self.delegate receivedMovieDetails:data for:movie];
        }
    }];
    [task resume];
}

// MARK: - Fetch Movie List
/* Responsible for getting the movie list from the API.
    Enter: FetchOption (FetchPopular, FetchNowPlaying)
    Returns: Void (delegate)
 */
-(void)fetchMovieList:(FetchOption)option {
    NSString *urlString;
    
    switch (option) {
        case FetchPopular:
            urlString = [NSString stringWithFormat:POPULAR_URL, API_KEY];
            break;
            
        default:
            urlString = [NSString stringWithFormat:NOW_PLAYING_URL, API_KEY];
            break;
    }
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSLog(@"%@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"--X-- FETCH ERROR");
            [self.delegate fetchedFailedWithError:error];
        } else {
            NSLog(@"--V-- FETCH SUCESS");
            [self.delegate receivedMovieList:data from:option];
        }
    }];
    [task resume];
}

@end
