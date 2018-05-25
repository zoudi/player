
#import <Foundation/Foundation.h>
@class PictureStoryModel;
@class StoryModel;
@class AuthorModel;


@interface DataBase : NSObject

@property(nonatomic,strong) PictureStoryModel *person;


+ (instancetype)sharedDataBase;


#pragma mark - Person
/**
 *  添加person
 *
 */
- (void)addPicture:(PictureStoryModel *)Picture;
/**
 *  删除person
 *
 */
- (void)deletePicture:(PictureStoryModel *)Picture;
/**
 *  更新person
 *
 */
- (void)updatePicture:(PictureStoryModel *)Picture;
/**
 *  查询person
 *
 */
- (PictureStoryModel *)pictureWithId:(NSString *)mId;
/**
 *  获取所有数据
 *
 */
- (NSMutableArray *)getAllPicture;

#pragma mark - Car


/**
 *  给person添加车辆
 *
 */
- (void)addAuthor:(AuthorModel *)author;
/**
 *  给person删除车辆
 *
 */
- (void)deleteAuthor:(AuthorModel *)author;
/**
 *  查询person
 *
 */
- (AuthorModel *)authorWithId:(NSString *)mId;
/**
 *  获取person的所有车辆
 *
 */
- (NSMutableArray *)getAllAuthor;



@end
