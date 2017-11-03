//
//  ViewController.m
//  LO_DownLoad
//
//  Created by sanjingrihua on 17/11/3.
//  Copyright © 2017年 sanjingrihua. All rights reserved.
//

#import "ViewController.h"
#define LanouBoundary @"lanou3g"
#define LanouLine @"\r\n"
#define LanouEncode(str) [str dataUsingEncoding:NSUTF8StringEncoding]
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //文件上传
    [self upload];
    
}
-(void)upload{
    //请求服务器地址
    NSURL *url = [NSURL URLWithString:@"服务器地址"];
    //创建一个post请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    //设置请求体
    NSMutableData *body = [NSMutableData data];
    //设置非文件的其他详细参数
    NSDictionary *patams = @{@"":@""};
    
    //文件参数
    //分界线
    [body appendData:LanouEncode(@"--")];
    [body appendData:LanouEncode(LanouBoundary)];
    //换行
    [body appendData:LanouEncode(LanouLine)];
    
    //获取本地文件的路径，同时转化成URL编码
    NSURL *urlPath = [[NSBundle mainBundle]URLForResource:@"filename" withExtension:@"txt"];
    //创建请求
    NSURLRequest *requestPath = [NSURLRequest requestWithURL:urlPath];
    //发送请求
    NSURLResponse *respose = nil;
    
    //通过发送本地文件路径来获取MIMEType
    [NSURLConnection sendSynchronousRequest:requestPath returningResponse:&respose error:nil];
    
    NSString *mimeType = respose.MIMEType;
    //声明上传文件的格式
    NSString *type = [NSString stringWithFormat:@"Content-Type:%@",mimeType];
    [body appendData:LanouEncode(type)];
    
    //换行
    [body appendData:LanouEncode(LanouLine)];
    
    //将本地文件路径转换为data数据类型
    NSData *fileData = [NSData dataWithContentsOfURL:urlPath];
    [body appendData:LanouEncode(LanouLine)];
    [body appendData:fileData];
    [body appendData:LanouEncode(LanouLine)];
    
    //要上传的文件名
    NSString *filename = @"filename.txt";
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition:form-data;name=\"file\";filename=\"%@\"",filename];
    [body appendData:LanouEncode(disposition)];
    [body appendData:LanouEncode(LanouLine)];
    
    //非文件参数的格式
    [patams enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [body appendData:LanouEncode(@"--")];
        [body appendData:LanouEncode(LanouBoundary)];
        [body appendData:LanouEncode(LanouLine)];
        
        NSString *dispositon = [NSString stringWithFormat:@"Content-Dispositon:form-data;name=\"%@\"",key];
        [body appendData:LanouEncode(dispositon)];
        [body appendData:LanouEncode(LanouLine)];
        
        [body appendData:LanouEncode(LanouLine)];
        [body appendData:LanouEncode([obj description])];
        [body appendData:LanouEncode(LanouLine)];
    }];
    
    //结束标记
    [body appendData:LanouEncode(@"--")];
    [body appendData:LanouEncode(LanouBoundary)];
    [body appendData:LanouEncode(@"--")];
    [body appendData:LanouEncode(LanouLine)];
    
    //设置http body
    request.HTTPBody = body;
    
    //设置请求头(告诉服务器，这次传的是一个文件数据，同时是一个上传的请求)
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",LanouBoundary];
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    //发送请求
    [NSURLConnection sendSynchronousRequest:request returningResponse:&respose error:nil];
}

- (IBAction)startButtonDidPress:(id)sender {
    //当不存在下载的时候创建下载任务，存在时候继续
    if (self.download) {
        [self.download resume];
    }else{
        self.download = [[LO_DownLoadTask alloc]init];
        [self.download downloadTaskWithURL:[NSURL URLWithString:@"http://61.155.212.122/hc.yinyuetai.con/uploads/videos/common/5B86014C1334AB9EB08B30D386FAA9C1.flv?sc=1c7a66a8a8bf0612&br=783&rd=iOS"]];
    }
    
}
- (IBAction)pasueButtonDidPress:(id)sender {
    if (self.download) {
        //调用暂停任务
        [self.download pasue];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
