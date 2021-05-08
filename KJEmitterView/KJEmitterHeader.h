//
//  KJEmitterHeader.h
//  KJEmitterDemo
//
//  Created by 杨科军 on 2018/11/26.
//  Copyright © 2018 杨科军. All rights reserved.
//  https://github.com/yangKJ/KJEmitterView
//  机器猫工具库，就像机器猫的口袋一样有无穷无尽意想不到的的各种道具供我们使用

#ifndef KJEmitterHeader_h
#define KJEmitterHeader_h

//************************************* UIKit 相关扩展 *****************************************
// 需要引入，请使用 pod 'KJEmitterView/Kit'
#if __has_include(<KJEmitterView/_KitHeader.h>)
#import <KJEmitterView/_KitHeader.h>
#elif __has_include("_KitHeader.h")
#import "_KitHeader.h"
#else
#endif

//************************************* Foundation 相关扩展 *****************************************
// 需要引入，请使用 pod 'KJEmitterView/Foundation'
#if __has_include(<KJEmitterView/_FoundationHeader.h>)
#import <KJEmitterView/_FoundationHeader.h>
#elif __has_include("_FoundationHeader.h")
#import "_FoundationHeader.h"
#else
#endif

//************************************* Language 多语言 *****************************************
// 需要引入，请使用 pod 'KJEmitterView/Language'
#if __has_include(<KJEmitterView/NSBundle+KJLanguage.h>)
#import <KJEmitterView/NSBundle+KJLanguage.h>
#elif __has_include("NSBundle+KJLanguage.h")
#import "NSBundle+KJLanguage.h"
#else
#endif

//************************************* OpenCV *****************************************
// 需要引入，请使用 pod 'KJEmitterView/Opencv'
#if __has_include(<KJEmitterView/UIImage+KJOpencv.h>)
#import <KJEmitterView/UIImage+KJOpencv.h>
#elif __has_include("UIImage+KJOpencv.h")
#import "UIImage+KJOpencv.h"
#else
#endif

#endif /* KJEmitterHeader_h */
