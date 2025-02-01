@Preview
@CustomDialog
export struct HMConfirm {
  controller: CustomDialogController
  message: string = '弹框的提示性内容'
  buttonList: HMConfirmButton[] = [
    {
      text: '确定',
      fontSize: 14,
      fontColor: $r('app.color.text_primary')
    }
  ]

  build() {
    Column() {
      Text(this.message)
        .padding({ top: 30, bottom: 30 })
      Row() {
        ForEach(this.buttonList, (item: HMConfirmButton, index) => {
          Row() {
            Text(item.text)
              .fontSize(item.fontSize || 16)
              .fontColor(item.fontColor || $r('app.color.text_secondary'))
          }
          .padding({ top: 15, bottom: 5 })
          .justifyContent(FlexAlign.Center)
          .alignItems(VerticalAlign.Center)
          .border({
            width: {
              right: (this.buttonList.length > 1 && index !== this.buttonList.length - 1) ? 0.5 : 0
            },
            color: $r('app.color.background_divider')
          })
          .layoutWeight(1)
          .onClick(() => {
            if (item.action) {
              item.action
            }
            this.controller.close()
          })

        })

      }.width('100%')
      .border({ width: { top: 0.5 }, color: $r('app.color.background_divider') })
    }.width('280')
    .borderRadius(12)
    .padding(12)
    .backgroundColor($r('app.color.white'))
  }
}

export class HMConfirmButton {
  text: string = "" // 按钮显示内容
  fontSize?: number = 16 // 按钮的文字大小
  fontColor?: ResourceStr = '' // 按钮的背景颜色
  action?: () => void = () => {
  } // 按钮的点击事件
}