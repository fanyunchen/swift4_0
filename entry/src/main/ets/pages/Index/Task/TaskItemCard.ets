import { TaskInfoItem, TaskInfoItemModel, TaskTypeEnum } from "../../../models"
import router from "@ohos.router"

@Preview
@Component
export struct TaskItemCard {
  taskItemData: TaskInfoItem = {} as TaskInfoItem

  // 获取当前任务的提货状态
  getBtnEnable() {
    if (this.taskItemData.enablePickUp) {
      return true
    }
    // 判断当前状态：在途or已交货状态
    const value = this.taskItemData.status.toString()
    switch (value) {
      case TaskTypeEnum.Line.toString():
      case TaskTypeEnum.Delivered.toString():
        return true
      default:
        return false
    }
  }

  // 获取按钮显示文本
  getBtnText() {
    const value = this.taskItemData.status.toString()
    console.log('value-->', value)
    switch (value) {
      case TaskTypeEnum.Line.toString():
        return "交货"
      case TaskTypeEnum.Waiting.toString():
        return "提货"
      case TaskTypeEnum.Delivered.toString():
        return "回车登记"
      default:
        return ''
    }
  }

  // 去提货
  toPickUp() {
    if (this.getBtnEnable()) {
      router.pushUrl({
        url: "pages/TaskDetail/TaskDetail",
        params: {
          id: this.taskItemData.id    // 当前任务编号
        }
      })
    }
  }

  build() {
    Column() {
      Row() {
        Text(`任务编号：${this.taskItemData?.transportTaskId}`)
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
        Text(this.taskItemData?.startAddress.toString())
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
        Text(this.taskItemData?.endAddress.toString())
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
          Text(this.taskItemData?.planDepartureTime.toString())
            .fontSize(14)
            .fontColor($r('app.color.text_secondary'))
            .margin({ top: 4 })
        }.alignItems(HorizontalAlign.Start)

        Button(this.getBtnText())
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .fontSize(14)
          .height(32)
          .enabled(this.getBtnEnable())
          .onClick(() => {
            this.toPickUp()
          })
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