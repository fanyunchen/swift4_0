@Preview
@CustomDialog
@Component
export struct HMDateDialog {
  controller: CustomDialogController
  // 标题
  title: string = '选择时间'
  confirmText: string = "完成"
  cancelText: string = '取消'
  oldTime: Date = new Date
  hours: string[] = []
  mins: string[] = []
  @State selectedHour: string = ''
  @State selectedMin: string = ''
  action: (selected: Date) => void = () => {
  }

  aboutToAppear(): void {
    this.getMin()
    if (this.oldTime.getMinutes() === 0) {
      for (let i = 0; i < 2; i++) {
        let time = this.oldTime.getHours() + i
        if (time >= 24) {
          time = time - 24
        }
        this.hours.push(time.toString().padStart(2, '0'))
      }
    } else {
      for (let i = 0; i <= 2; i++) {
        let time = this.oldTime.getHours() + i
        if (time >= 24) {
          time = time - 24
        }
        this.hours.push(time.toString().padStart(2, '0'))
      }
    }
    this.selectedHour = this.oldTime.getHours().toString()
    this.selectedMin = this.oldTime.getMinutes().toString()
  }

  getMin() {
    for (let i = 0; i < 60; i++) {
      this.mins.push(i.toString().padStart(2, '0'))
    }
  }

  build() {
    Column() {
      Row() {
        Text(this.cancelText)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .onClick(() => {
            this.controller.close()
          })
        Text(this.title)
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
        Text(this.confirmText)
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
          .onClick(() => {
            this.controller.close()
            const time =
              new Date(this.oldTime.getFullYear() + '-' + (this.oldTime.getMonth() + 1) + '-' +
                (Number(this.selectedHour) <
                this.oldTime.getHours() ? this.oldTime.getDate() + 1 : this.oldTime.getDate()) +
                " " + this.selectedHour + ":" + this.selectedMin)
            let timeDiff = Number(time.getTime()) - Number(this.oldTime.getTime())
            if (timeDiff > 7200000) {
              AlertDialog.show({ message: '选择时间超过两小时!,请重新选择' })
              return
            }
            this.action(time)
          })
      }.width('100%')
      .padding({
        left: 15,
        right: 15,
        top: 20,
        bottom: 20
      })
      .justifyContent(FlexAlign.SpaceBetween)

      Divider()
        .color($r('app.color.background_divider'))
        .strokeWidth(1.5)
      Row() {
        Text('时')
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
        Text('分')
          .fontSize(15)
          .fontColor($r('app.color.text_primary'))
      }.width('100%')
      .margin({ top: 15 })
      .justifyContent(FlexAlign.SpaceAround)

      Row() {
        TextPicker({ range: this.hours, value: this.oldTime.getHours().toString() })
          .layoutWeight(1)
          .onChange((value) => {
            this.selectedHour = value as string
          })
        TextPicker({ range: this.mins, value: this.oldTime.getMinutes().toString() })
          .layoutWeight(1)
          .onChange((value) => {
            this.selectedMin = value as string
          })
      }.width('100%')
      .margin({ top: 15 })
    }.width('100%')
    .backgroundColor($r('app.color.white'))
    .borderRadius(8)
  }
}