//
//  UploadAvatarViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/5.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UploadAvatarViewController.h"
#import "GVUserDefaults+Properties.h"

@interface UploadAvatarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *healthyBeans;
@property (weak, nonatomic) IBOutlet UILabel *diamond;
@property (weak, nonatomic) IBOutlet UIButton *updateAvatar;
@property (weak, nonatomic) IBOutlet UIImageView *Avatar;

@end

@implementation UploadAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    self.username.text = [GVUserDefaults standardUserDefaults].userName;
    self.userPhoneNumber.text = [GVUserDefaults standardUserDefaults].phoneNumber;
    self.diamond.text = [GVUserDefaults standardUserDefaults].diamond;
    self.healthyBeans.text = [GVUserDefaults standardUserDefaults].healthyBeans;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateImage:(id)sender {
    UIAlertController *userIconActionSheet = [UIAlertController alertControllerWithTitle:@"请选择上传类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //相册选择
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"相册选择");
        //这里加一个判断，是否是来自图片库
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
            imagePicker.delegate = self;            //协议
            imagePicker.allowsEditing = YES;
            imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }];
    //系统相机拍照
//    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSLog(@"相机选择");
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
//            UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
//            imagePicker.delegate = self;
//            imagePicker.allowsEditing = YES;
//            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            [self presentViewController:imagePicker animated:YES completion:nil];
//        }
//    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        NSLog(@"取消");
    }];
    [userIconActionSheet addAction:albumAction];
    //[userIconActionSheet addAction:photoAction];
    [userIconActionSheet addAction:cancelAction];
    [self presentViewController:userIconActionSheet animated:YES completion:nil];

}

#pragma mark 调用系统相册及拍照功能实现方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];//获取到所选择的照片
    self.Avatar.image = img;
    UIImage *compressImg = [self imageWithImageSimple:img scaledToSize:CGSizeMake(60, 60)];//对选取的图片进行大小上的压缩
    [self transportImgToServerWithImg:compressImg]; //将裁剪后的图片上传至服务器
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

//用户取消选取时调用,可以用来做一些事情
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//压缩图片方法
- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


//上传图片至服务器后台
- (void)transportImgToServerWithImg:(UIImage *)img{
    NSData *imageData;
    NSString *mimetype;
    //判断下图片是什么格式
    if (UIImagePNGRepresentation(img) != nil) {
        mimetype = @"image/png";
        imageData = UIImagePNGRepresentation(img);
    }else{
        mimetype = @"image/jpeg";
        imageData = UIImageJPEGRepresentation(img, 1.0);
    }
//    NSString *urlString = @"http:///XXXXXX";
//    NSDictionary *params = @{@"login_token":@"220"};
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:urlString parameters:paramsconstructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        NSString *str = @"avatar";
//        NSString *fileName = [[NSString alloc] init];
//        if (UIImagePNGRepresentation(img) != nil) {
//            fileName = [NSString stringWithFormat:@"%@.png", str];
//        }else{
//            fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        }
//        // 上传图片，以文件流的格式
//        /**
//         *filedata : 图片的data
//         *name     : 后台的提供的字段
//         *mimeType : 类型
//         */
//        [formData appendPartWithFileData:imageData name:str fileName:fileName mimeType:mimetype];
//    } progress:NULL success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        //打印看下返回的是什么东西
//        WKLog(@"上传凭证成功:%@",responseObject);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        WKLog(@"上传图片失败，失败原因是:%@", error);
//    }];
}

@end
