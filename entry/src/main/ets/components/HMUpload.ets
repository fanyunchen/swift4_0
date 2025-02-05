@Component
export struct HMUpload {
  title: string = ''

  build() {
    Column() {
      Text(this.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .margin({ top: 15, bottom: 15 })

      Row() {
        Image($r('app.media.ic_add_img'))
          .width(30)
          .aspectRatio(1)
      }
      .width(95)
      .aspectRatio(1)
      .backgroundColor($r('app.color.background_page'))
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }.width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}