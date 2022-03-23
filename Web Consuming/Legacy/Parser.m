//
//  NSObject+Parser.m
//  Obj-C
//
//  Created by Gabriela Zorzo on 22/03/22.
//

#import "Parser.h"
#import "Movie.h"

#define BASE_IMG_URL @"https://image.tmdb.org/t/p/w500"

@implementation Parser

+(NSArray*)movieListFromJSON:(NSData*) json error:(NSError**) error {
    NSError *errorBuffer = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&errorBuffer];
    
    if (errorBuffer != nil) {
        *error = errorBuffer;
        return nil;
    }
    
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"results"];
    NSLog(@"Count %d", (int)results.count);
    
    for (NSDictionary *movieDict in results) {
        Movie *movie = [[Movie alloc] init];
        
        for (NSString *key in movieDict) {
            if ([movie respondsToSelector:NSSelectorFromString(key)]) {
                if ([key isEqualToString:@"poster_path"]) {
                    if ([[movieDict valueForKey:key] isKindOfClass:[NSString class]]) {
                        NSString* pictureURL = [BASE_IMG_URL stringByAppendingString:[movieDict valueForKey:key]];
                        NSLog(@"--!-- PICTURE URL: %@", pictureURL);
                        [movie setValue:[NSURL URLWithString:pictureURL] forKey:key];
                    } else {
                        NSLog(@"--!-- PICTURE URL EMPTY");
                        [movie setValue:[NSURL URLWithString:@""] forKey:key];
                    }
                } else {
                    [movie setValue:[movieDict valueForKey:key] forKey:key];
                }
            }
        }
        [movies addObject:movie];
    }
    
    return movies;
}

+(void)detailsForMovie:(Movie*) movie from:(NSData*) json error:(NSError**) error {
    NSError *errorBuffer = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&errorBuffer];
    
    if (errorBuffer != nil) {
        *error = errorBuffer;
        return;
    }
    
    NSArray* results = [parsedObject valueForKey:@"genres"];
    NSString* genresString = [NSString string];
    
    for (NSDictionary *genreDict in results) {
        genresString = [genresString stringByAppendingFormat:@"%@, ", [genreDict valueForKey:@"name"]];
    }
    
    // Remove trailing ", " separator from string
    genresString = [genresString substringToIndex:[genresString length] - 2];
    NSLog(@"%@", genresString);
    
    movie.genres = genresString;
}

@end
