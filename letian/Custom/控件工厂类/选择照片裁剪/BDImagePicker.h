//
//  ImagePicker.h
//  Imagee
//
//  Created by guoqian on 16/1/20.
//  Copyright © 2016年 Imagee. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^BDImagePickerFinishAction)(UIImage *image);

@interface BDImagePicker : NSObject

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(BDImagePickerFinishAction)finishAction;

@end
