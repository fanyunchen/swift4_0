import { photoAccessHelper } from "@kit.MediaLibraryKit"
import promptAction from "@ohos.promptAction"
import { ImageList } from "../models"
import { HMPreview } from "./HMPreview"

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