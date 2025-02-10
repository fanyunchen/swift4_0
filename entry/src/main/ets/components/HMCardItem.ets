@Component
struct HMCardItem {
  leftText: string = '' // 左边显示的内容
  @Prop
  rightText: string = '' // 右边显示的内容
  showRightIcon: boolean = true // 是否显示右边的图片
  showBorder: boolean = true // 是否显示底部分割线
  click: () => void = () => {
  } // 点击事件

  build() {
    Row() {
      Text(this.leftText)
        .fontWeight(400)
        .fontColor($r("app.color.text_primary"))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1)
        .layoutWeight(1)

      Row() {
        if (this.rightText) {
          Text(this.rightText)
            .fontSize(14)
            .fontWeight(400)
            .fontColor($r("app.color.text_primary"))
        }
        if (this.showRightIcon) {
          Image($r("app.media.ic_btn_more"))
            .width(24)
            .aspectRatio(1)
        } else {
          Text()
            .width(24)
            .aspectRatio(1)
        }
      }.onClick(() => {
        this.click()
      })

    }.width('100%')
    .border({
      width: {
        bottom: this.showBorder ? 1 : 0
      },
      color: $r('app.color.background_divider')
    })
    .height(60)
    .justifyContent(FlexAlign.SpaceBetween)

  }
}

export { HMCardItem }