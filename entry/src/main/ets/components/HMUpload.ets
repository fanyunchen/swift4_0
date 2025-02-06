import { photoAccessHelper } from "@kit.MediaLibraryKit"
import promptAction from "@ohos.promptAction"
import { ImageList } from "../models"

@Component
export struct HMUpload {
  title: string = ''
  maxNumber: number = 6 // 最多选择几张图片
  @State imgList: ImageList[] = []

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
    }
  }

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 15, bottom: 15 })

      Grid() {
        ForEach(this.imgList, (item: ImageList) => {
          GridItem() {
            Row() {
              Image(item.url)
                .width('100%')
                .aspectRatio(1)
                .objectFit(ImageFit.Contain)
            }
            .width(95)
            .aspectRatio(1)
            .backgroundColor($r('app.color.background_page'))
            .borderRadius(8)
            .justifyContent(FlexAlign.Center)
            .alignItems(VerticalAlign.Center)
            .clip(true)
          }
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