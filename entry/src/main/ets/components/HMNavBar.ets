import router from "@ohos.router"

@Component
export struct HMNavBar {
  title: string = "测试" // 标题
  showBackIcon: boolean = true // 返回

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.showBackIcon) {
        Row() {
          Image($r('app.media.ic_btn_nav_back'))
            .width(44)
            .aspectRatio(1)
            .onClick(() => {
              router.back()
            })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Center)
        .zIndex(999)
        .width('100%')
        .height('100%')
      }
      Row() {
        Text(this.title)
          .fontSize(18)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(FontWeight.Bold)
      }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }.width('100%')
    .padding({ left: 10, right: 10 })
    .height(50)
    .backgroundColor($r('app.color.white'))
  }
}