//
//  PBImageHelper.m
//
//  Created by AT on 6/17/12.
//

#import "PBImageHelper.h"

@implementation PBImageHelper

+ (BOOL)saveImageToDocuments: (UIImage *) image withName:(const NSString *) name {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
    NSData *data = [NSData dataWithData:UIImageJPEGRepresentation(image, 9)];
    [data writeToFile:filePath atomically:YES];
    
    return true;
}

+ (UIImage *)loadImageFromDocuments: (const NSString *) name {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:filePath];
    
    return image;
}

+ (BOOL)deleteFileFromDocuments: (const NSString *) name {
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@",docDir, name];
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr removeItemAtPath:filePath error:nil] != YES) {
        return FALSE;
    }
    
    return TRUE;
}

+ (NSArray *)listFileAtPath:(NSString *)path
{
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    return directoryContent;
}

+ (void)clearOldTempImageFilesInDocumentDirectory{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *imagePaths = [self listFileAtPath:docDir];
    for (NSString * path in imagePaths) {
        [fileMgr removeItemAtPath:path error:nil];
    }
}

@end
