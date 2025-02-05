@Preview
@Component
export struct HMToggleCard {
  title: string = "标题"
  @State toggleCard: boolean = true // 控制内容显示和隐藏的，true表示显示，false表示隐藏
  @BuilderParam cardContent: () => void

  build() {
    Column() {
      Row() {
        Text(this.title)
          .fontColor($r('app.color.text_primary'))
          .fontWeight(500)
        Image(!this.toggleCard ? $r('app.media.ic_btn_add') : $r('app.media.ic_btn_cut'))
          .width(24)
          .aspectRatio(1)
          .onClick(() => {
            // 设置动画
            animateTo({ duration: 300 }, () => {
              this.toggleCard = !this.toggleCard
            })
          })
      }
      .width('100%')
      .height(50)
      .justifyContent(FlexAlign.SpaceBetween)

      if (this.toggleCard) {
        if (this.cardContent) {
          this.cardContent()
        }
      }
    }
    .margin({
      left: 15, right: 15, top: 15
    })
    .padding({
      left: 20, right: 20, bottom: 18
    })
    .borderRadius(8)
    .backgroundColor($r('app.color.white'))
  }
}