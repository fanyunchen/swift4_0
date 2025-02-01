@Preview
@Component
export struct TaskItemCard {
  build() {
    Column() {
      Row() {
        Text("任务编号：111111111")
          .fontWeight(500)
          .lineHeight(22)
          .fontColor($r('app.color.text_primary'))
      }.width('100%')

      Row() {
        Text('起')
          .fontSize(12)
          .width(22)
          .height(22)
          .borderRadius(11)
          .fontColor($r('app.color.white'))
          .backgroundColor($r('app.color.text_primary'))
          .textAlign(TextAlign.Center)
        Text("111111111")
          .margin({ left: 12 })
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }.width('100%')
      .margin({ top: 20 })

      Row() {
        Text('止')
          .fontSize(12)
          .width(22)
          .height(22)
          .borderRadius(11)
          .fontColor($r('app.color.white'))
          .backgroundColor($r('app.color.primary'))
          .textAlign(TextAlign.Center)
        Text("111111111")
          .margin({ left: 12 })
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
      }.width('100%')
      .margin({ top: 14 })

      Divider()
        .height(2)
        .color($r('app.color.background_divider'))
        .margin({
          top: 20,
          bottom: 4,
          right: 8,
          left: 8
        })

      Row() {
        Column() {
          Text("提货时间")
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
          Text("2022.05.04 13:00")
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button("提货")
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .fontSize(14)
          .height(32)
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)

    }
    .width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
    .margin({ left: 15, right: 15, top: 15 })
    .padding({
      left: 19,
      right: 19,
      top: 18,
      bottom: 18
    })
  }
}