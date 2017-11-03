//
//  LO_DownLoadTask.h
//  LO_DownLoad
//
//  Created by sanjingrihua on 17/11/3.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LO_DownLoadTask : NSObject<NSURLSessionDownloadDelegate>
/**
 下载任务
 */
@property(nonatomic,strong)NSURLSessionDownloadTask *task;
/**
 创建下载任务的属性
 */
@property(nonatomic,strong)NSURLSession *session;
//保持完成的文件
@property(nonatomic,strong)NSData *resumeData;

-(void)downloadTaskWithURL:(NSURL*)url;
/**暂停*/
-(void)pasue;
//继续下载
-(void)resume;
@end
