@CustomDialog
@Component
export struct HMSelectCard {
  controller: CustomDialogController
  title: string = '选择类型'
  @BuilderParam
  cardContent: () => void
  confirm: () => void = () => {
  }

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.text_primary'))
        Image($r('app.media.ic_btn_close'))
          .width(13)
          .aspectRatio(1)
          .onClick(() => {
            this.controller.close()
          })
      }.width('100%')
      .height(60)
      .justifyContent(FlexAlign.SpaceBetween)
      .border({
        width: {
          bottom: 1
        },
        color: $r('app.color.background_divider')
      })

      if (this.cardContent) {
        this.cardContent()
      }

      Row() {
        Button('确定')
          .width(200)
          .backgroundColor($r('app.color.primary'))
          .height(45)
          .onClick(() => {
            this.controller.close()
            this.confirm()
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 20, bottom: 20 })

    }.backgroundColor($r('app.color.white'))
    .width('100%')
    .padding({ left: 21, right: 21 })
    .borderRadius({ topLeft: 16, topRight: 16 })
  }
}