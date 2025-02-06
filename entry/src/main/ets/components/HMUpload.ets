import { photoAccessHelper } from "@kit.MediaLibraryKit"
import promptAction from "@ohos.promptAction"
import { ImageList } from "../models"
import { HMPreview } from "./HMPreview"
import { fileIo } from "@kit.CoreFileKit"
import { util } from "@kit.ArkTS"
import { request } from "@kit.BasicServicesKit"
import { uploadImage } from "../api"

@Component
export struct HMUpload {
  title: string = ''
  maxNumber: number = 6 // 最多选择几张图片
  index: number = -1 // 记录当前点击的图片索引
  @Prop imgList: ImageList[] = []
  onListChange: (imgList: ImageList[]) => void = () => {
  }
  preview: CustomDialogController = new CustomDialogController({
    builder: HMPreview({
      urls: this.imgList.map(item => item.url),
      selectIndex: this.index
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
    autoCancel: true
  })

  // 点击打开相册选择框
  async selectImage() {
    let photoPicker = new photoAccessHelper.PhotoViewPicker
    const result = await photoPicker.select({
      MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE, // 选择类型，只能选择图片
      maxSelectNumber: this.maxNumber - this.imgList.length  // 选择图片最多几张
    })

    if (!result.photoUris.length) {
      promptAction.showToast({ message: '请选择至少一张图片！' })
    } else {
      this.imgList = this.imgList.concat(result.photoUris.map((url) => {
        return { url } as ImageList
      }))
      this.onListChange(this.imgList)
    }
  }

  /**
   * 删除图片
   * @param index 删除图片的索引
   */
  deleteImage(index: number) {
    animateTo({ duration: 300 }, () => {
      this.imgList.splice(index, 1)
      this.onListChange(this.imgList)
    })
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 15, bottom: 15 })

      Grid() {
        ForEach(this.imgList, (item: ImageList, index) => {
          GridItem() {
            Stack({ alignContent: Alignment.TopEnd }) {
              Image(item.url)
                .width('100%')
                .aspectRatio(1)
                .onClick(() => {
                  // 点击图片，展示预览图
                  this.index = index
                  this.preview.open()
                })
                .objectFit(ImageFit.Cover)
              Image($r('app.media.ic_btn_delete'))
                .width(25)
                .onClick(() => {
                  this.deleteImage(index)
                })
                .aspectRatio(1)
            }.width('100%')
            .height('100%')
          }
          .width(95)
          .aspectRatio(1)
          .borderRadius(8)
          .clip(true)
        })
        if (this.imgList.length != this.maxNumber) {
          GridItem() {
            Row() {
              Image($r('app.media.ic_add_img'))
                .width(30)
                .onClick(() => {
                  this.selectImage()
                })
                .aspectRatio(1)
            }
            .width(95)
            .aspectRatio(1)
            .borderRadius(8)
            .backgroundColor($r('app.color.background_page'))
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
          }
        }
      }
      .columnsGap(5)
      .rowsGap(5)
    }.width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}

export const UploadFile = async (list: ImageList[]) => {
  // 将图片上拷贝到cache沙箱目录
  const saveDir = getContext().cacheDir // 获取沙箱cache地址
  const fileParams: request.File[] = []

  list.forEach(image => {
    // 读取相册图片
    const file = fileIo.openSync(image.url, fileIo.OpenMode.READ_ONLY)

    // 将图片写入沙箱cache中
    const extName = image.url.split('.')[1]
    const uniqueName = util.generateRandomUUID() + "." + extName // 随机生成一个唯一的文件名
    fileIo.copyFileSync(file.fd, saveDir + "/" + uniqueName)

    // 构建图片的file类型
    fileParams.push({
      filename: uniqueName,
      type: extName,
      uri: "internal://cache/" + uniqueName,
      name: 'file'  // 和后端的上传接口参数是对应的
    })
    fileIo.closeSync(file)
  })

  // 调用后端接口实现图片上传
  return await uploadImage(getContext(), fileParams)
}