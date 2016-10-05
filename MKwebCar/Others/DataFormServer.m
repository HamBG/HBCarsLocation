//
//  DataFormServer.m
//  HZVolunteer
//
//  Created by wisdom on 14-11-20.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "DataFormServer.h"

@interface DataFormServer ()
@end
#define PXLX_STR (@"0")
#define SXTJ_STR (@"2")
#define COUNTS_STR (@"10")

@implementation DataFormServer
@synthesize delegate;
@synthesize element;
@synthesize resultJSON;

#pragma 数据加载和解析
-(void) getsDataFromServer:(NSDictionary *)parameters methodName:(NSString *)methodName isReturnArry:(BOOL)isReturnArry{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];//设置相应内容类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSLog(@"%@",parameters);
    NSString *url = [NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,methodName];
    NSLog(@"%@",url);
    
    [manager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = operation.responseData;
         NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        
        resultJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",result);
//        NSLog(@"ddddd:%@",[[resultJSON objectAtIndex:0]objectForKey:@"carno"]);
        if (isReturnArry) {
            [self.delegate getResultJson:resultJSON];
            
        }else{
        
        NSDictionary *dicJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self.delegate getDictionaryJson:dicJson];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
#pragma xmlparaser
//第一个代理方法：
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"ns:skxxQcResponse"]) {
        //判断属性节点
        //        if ([attributeDict objectForKey:@"addr"]) {
        //            //获取属性节点中的值
        //            NSString *addr=[attributeDict objectForKey:@"addr"];
        //        }
        //        NSLog(@"response");
    }
    //判断member
    if ([elementName isEqualToString:@"ns:return"]) {
        //        NSLog(@"member");
    }
}

//第二个代理方法：
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //获取文本节点中的数据，因为下面的方法要保存这里获取的数据，所以要定义一个全局变量(可修改的字符串)
    //NSMutableString *element = [[NSMutableString alloc]init];
    //这里要赋值为空，目的是为了清空上一次的赋值
    //    [element setString:@""];
    //    NSLog(@"element is:%@",string);
    [element appendString:string];//string是获取到的文本节点的值，只要是文本节点都会获取(包括换行)，然后到下个方法中进行判断区分
}

//第三个代理方法：
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSString *str=[[NSString alloc] initWithString:element];
    
    if ([elementName isEqualToString:@"ns:return"]) {
        
                NSLog(@"ns:return=%@",str);
    }
    
}
//xml解析结束后的一些操作可在此
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSString *str=[[NSString alloc] initWithString:element];
    NSData *rData = [str dataUsingEncoding:NSUTF8StringEncoding];
    resultJSON = [NSJSONSerialization JSONObjectWithData:rData options:NSJSONReadingMutableContainers error:nil];
    //    NSLog(@"%@",[[resultJSON objectAtIndex:0]objectForKey:@"NAME"]);
    NSLog(@"resultJson count：%d",[resultJSON count]);
//    if([resultJSON count]){
        //当xml解析完之后，把解析完的数据通过代理传给代理方，代理方获得解析好的数据;代理本质上是实现被代理对象的方法，并且能获取被代理对象传递过来的的数据；
//        }
    
}


@end
