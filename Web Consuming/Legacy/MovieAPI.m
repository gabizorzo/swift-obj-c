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
#define SEARCH_URL @"https://api.themoviedb.org/3/search/movie?api_key=%@&query=%@"

@implementation MovieAPI

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

-(void)searchMoviesWith:(NSString *)keywords {
    [[NSURLSession sharedSession] invalidateAndCancel];
    
    keywords = [keywords stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet];
    NSString *urlString = [NSString stringWithFormat:SEARCH_URL, API_KEY, keywords];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSLog(@"%@", urlString);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session =[NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"--X-- SEARCH ERROR");
            [self.delegate fetchedFailedWithError:error];
        } else {
            NSLog(@"--V-- SEARCH SUCCESS");
            [self.delegate receivedMovieList:data from:FetchSearch];
        }
    }];
    [task resume];
}

@end
