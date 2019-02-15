//
//  EARHeader.h
//  EnhanceAppRobust
//
//  Created by wujungao on 2019/2/13.
//  Copyright © 2019 wujungao. All rights reserved.
//

#ifdef DEBUG

    #define DLog(fmt, ...) NSLog((@"[文件名:%s]\n" "[消息名:%s]\n" "[行号:%d] \n" fmt), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__)
#else

    #define NSLog(...)
    #define DLog(...)

#endif
