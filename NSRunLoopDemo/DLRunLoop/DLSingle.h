//
//  DLSingle.h
//  NSRunLoopDemo
//
//  Created by DeLongYang on 2017/10/10.
//  Copyright © 2017年 DeLongYang. All rights reserved.
//

#ifndef DLSingle_h
#define DLSingle_h

#define DLSINGLE_H(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define DLSINGLE_M(name) static id _singleManager = nil;\
+ (instancetype)share##name{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_singleManager = [[self alloc] init];\
});\
return _singleManager;\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_singleManager = [super allocWithZone:zone];\
});\
return _singleManager;\
}\
\
- (id)mutableCopy{\
return _singleManager;\
}\
\
- (id)copy{\
return _singleManager;\
}

#else

#define DLSINGLE_M(name) static id _singleManager = nil;\
+ (instancetype)share##name{\
return [[self alloc]init];\
}\
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_singleManager = [super allocWithZone:zone];\
});\
return _singleManager;\
}\
\
- (id)mutableCopy{\
return _singleManager;\
}\
\
- (id)copy{\
return _singleManager;\
}\
- (oneway void)release{\
}\
\
- (instancetype)retain{\
return _singleManager;\
}\
\
- (NSUInteger)retainCount{\
return 9999;\
}\

#endif

#endif /* DLSingle_h */
