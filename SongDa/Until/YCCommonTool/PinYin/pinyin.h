//
//  pinyin.h .h
//  TableView
//
//  Created by ibokan on 14-5-28.
//  Copyright (c) 2014年 ibokan. All rights reserved.
//

#ifndef TableView_pinyin_h__h
#define TableView_pinyin_h__h

/*
 *  pinyin.h
 *  Chinese Pinyin First Letter
 *
 *  Created by George on 4/21/10.
 *  Copyright 2010 RED/SAFI. All rights reserved.
 *
 */
/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *hanyu = @"中国共产党万岁！";
 * for (int i = 0; i < [hanyu length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([hanyu characterAtIndex:i]));
 * }
 *
 */
char pinyinFirstLetter(unsigned short hanzi);

#endif
