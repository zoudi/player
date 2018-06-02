//
//  DataBase.m
//  FMDBDemo
//
//  Created by Zeno on 16/5/18.
//  Copyright © 2016年 zenoV. All rights reserved.
//

#import "DataBase.h"

#import <FMDB.h>

#import "PictureStoryModel.h"
#import "StoryModel.h"
#import "AuthorModel.h"
static DataBase *_DBCtl = nil;

@interface DataBase()<NSCopying,NSMutableCopying>{
    FMDatabase  *_db;
    
}




@end

@implementation DataBase

+(instancetype)sharedDataBase{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [[DataBase alloc] init];
        
        [_DBCtl initDataBase];
        
    }
    
    return _DBCtl;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    if (_DBCtl == nil) {
        
        _DBCtl = [super allocWithZone:zone];
        
    }
    
    return _DBCtl;
    
}

-(id)copy{
    
    return self;
    
}

-(id)mutableCopy{
    
    return self;
    
}

-(id)copyWithZone:(NSZone *)zone{
    
    return self;
    
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    
    return self;
    
}


-(void)initDataBase{
    // 获得Documents目录路径
    
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    // 文件路径
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"PictureStoryModel.sqlite"];
    
    // 实例化FMDataBase对象
    
    _db = [FMDatabase databaseWithPath:filePath];
    
    [_db open];

    // 初始化数据表 //PictureStoryModel
    NSString *personSql = @"CREATE TABLE 'picture' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'mID' VARCHAR(255),'user_id' VARCHAR(255),'user_email' VARCHAR(255),'collection_id'VARCHAR(255),'full_res' VARCHAR(255),'thumb' VARCHAR(255),'avatar' VARCHAR(255),'img_color' VARCHAR(255),'created' VARCHAR(255),'tags' VARCHAR(255),'user_name' VARCHAR(255),'story' VARCHAR(255),'author' VARCHAR(255),'location' VARCHAR(255)) ";

    NSString *userSql = @"CREATE TABLE 'author' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,'mID' VARCHAR(255),'user_name' VARCHAR(255),'picture_url' VARCHAR(255)) ";
    
    [_db executeUpdate:personSql];
    [_db executeUpdate:userSql];
    
    
    [_db close];

}
#pragma mark - 接口

- (void)addPicture:(PictureStoryModel *)Picture{
    [_db open];
    
    [_db executeUpdate:@"INSERT INTO picture(mID,user_id,user_email,collection_id,full_res,thumb,avatar,img_color,created,tags,user_name,location,author,story)VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",Picture.mID,Picture.user_id,Picture.user_email,Picture.collection_id,Picture.full_res,Picture.thumb,Picture.avatar,Picture.img_color,Picture.created,Picture.tags,Picture.user_name,Picture.story_detail.location,Picture.story_detail.author,Picture.story_detail.story];
    
    
    
    [_db close];
    
}

- (void)deletePicture:(PictureStoryModel *)Picture{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM picture WHERE mID = ?",Picture.mID];

    [_db close];
}

- (void)updatePicture:(PictureStoryModel *)Picture{
   /* [_db open];
    
    [_db executeUpdate:@"UPDATE 'person' SET person_name = ?  WHERE person_id = ? ",person.name,person.ID];
    [_db executeUpdate:@"UPDATE 'person' SET person_age = ?  WHERE person_id = ? ",@(person.age),person.ID];
    [_db executeUpdate:@"UPDATE 'person' SET person_number = ?  WHERE person_id = ? ",@(person.number + 1),person.ID];
    
    [_db close];*/
}
/**
 *  查询person  
 *
 */
- (PictureStoryModel *)pictureWithId:(NSString *)mId{
    [_db open];

    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM picture where mID = %@ ",mId]];
    
    while ([res next]) {
        if ([[res stringForColumn:@"mID"] isEqualToString:mId]) {
            PictureStoryModel *picture = [[PictureStoryModel alloc] init];
            picture.mID = [res stringForColumn:@"mID"] ;
            picture.user_id = [res stringForColumn:@"user_id"];
            picture.collection_id = [res stringForColumn:@"collection_id"] ;
            picture.full_res = [res stringForColumn:@"full_res"] ;
            picture.thumb = [res stringForColumn:@"thumb"] ;
            picture.avatar = [res stringForColumn:@"avatar"] ;
            picture.img_color = [res stringForColumn:@"img_color"] ;
            picture.created = [res stringForColumn:@"created"] ;
            picture.tags = [res stringForColumn:@"tags"] ;
            picture.user_name = [res stringForColumn:@"user_name"] ;
            picture.user_email = [res stringForColumn:@"user_email"] ;
            StoryModel *story = [[StoryModel alloc]init];
            story.location = [res stringForColumn:@"location"] ;
            story.story = [res stringForColumn:@"story"] ;
            story.author = [res stringForColumn:@"author"] ;;
            picture.story_detail = story;
            return picture;
        }
    }
    [_db close];
    return nil;
}

- (NSMutableArray *)getAllPicture{
    [_db open];
    
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM picture"];
    
    while ([res next]) {
        PictureStoryModel *picture = [[PictureStoryModel alloc] init];
        picture.mID = [res stringForColumn:@"mID"] ;
        picture.user_id = [res stringForColumn:@"user_id"];
        picture.collection_id = [res stringForColumn:@"collection_id"] ;
        picture.full_res = [res stringForColumn:@"full_res"] ;
        picture.thumb = [res stringForColumn:@"thumb"] ;
        picture.avatar = [res stringForColumn:@"avatar"] ;
        picture.img_color = [res stringForColumn:@"img_color"] ;
        picture.created = [res stringForColumn:@"created"] ;
        picture.tags = [res stringForColumn:@"tags"] ;
        picture.user_name = [res stringForColumn:@"user_name"] ;
        picture.user_email = [res stringForColumn:@"user_email"] ;
        StoryModel *story = [[StoryModel alloc]init];
        story.location = [res stringForColumn:@"location"] ;
        story.story = [res stringForColumn:@"story"] ;
        story.author = [res stringForColumn:@"author"] ;;
        picture.story_detail = story;
        [dataArray addObject:picture];
        
    }
    
    [_db close];
    
    
    
    return dataArray;
    
    
}

- (void)addAuthor:(AuthorModel *)author{
    [_db open];
    
    [_db executeUpdate:@"INSERT INTO author(mID,user_name,picture_url)VALUES(?,?,?)",author.mID,author.user_name,author.picture_url];
    
    
    
    [_db close];
    
}
/**
 *  给person删除车辆
 *
 */
- (void)deleteAuthor:(AuthorModel *)author{
    [_db open];
    
    [_db executeUpdate:@"DELETE FROM author WHERE mID = ?",author.mID];

    [_db close];
    
    
    
}
/**
 *  查询person
 *
 */
- (AuthorModel *)authorWithId:(NSString *)mId{
    [_db open];
    
    FMResultSet *res = [_db executeQuery:[NSString stringWithFormat:@"SELECT * FROM author where mID = %@ ",mId]];
    
    while ([res next]) {
        if ([[res stringForColumn:@"mID"] isEqualToString:mId]) {
            AuthorModel *car = [[AuthorModel alloc] init];
            car.mID = [res stringForColumn:@"mID"];
            car.user_name = [res stringForColumn:@"user_name"];
            car.picture_url = [res stringForColumn:@"picture_url"] ;
            return car;
        }
    }
    [_db close];
    return nil;

    
}
/**
 *  获取person的所有车辆
 *
 */
- (NSMutableArray *)getAllAuthor{
    [_db open];
    NSMutableArray  *carArray = [[NSMutableArray alloc] init];
    FMResultSet *res = [_db executeQuery:@"SELECT * FROM author"];

    while ([res next]) {
        AuthorModel *car = [[AuthorModel alloc] init];
        car.mID = [res stringForColumn:@"mID"];
        car.user_name = [res stringForColumn:@"user_name"];
        car.picture_url = [res stringForColumn:@"picture_url"] ;
        
        [carArray addObject:car];
        
    }
    [_db close];
    
    return carArray;
    
}


@end
