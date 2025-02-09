// 加载
@CustomDialog
@Component
export struct HMLoading {
  controller: CustomDialogController
  loadingText: string = '' // 提示性文字
  @State show: boolean = true // 是否显示遮罩层
  @State num: number = 0
  maxNumber: number = 100
  timer: number = -1
  hWidth: number = 40

  aboutToAppear(): void {
    this.timer = setInterval(() => {
      if (this.num === this.maxNumber) {
        this.num = 0
      }
      this.num++
    }, 10)
  }

  aboutToDisappear(): void {
    clearInterval(this.timer)
  }

  build() {
    if (this.show) {
      Column({ space: 10 }) {
        Progress({
          value: this.num,
          total: this.maxNumber,
          type: ProgressType.ScaleRing
        }).color($r('app.color.text_secondary'))
          .width(this.hWidth)
          .style({ strokeWidth: 2 })
        if (this.loadingText) {
          Text(this.loadingText)
            .fontSize(18)
            .fontWeight(FontWeight.Bold)
            .fontColor($r('app.color.text_secondary'))
        }
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)
      .backgroundColor("rgba(0,0,0,0.1)")
    } else {
      Progress({
        value: 0,
        total: 100,
        type: ProgressType.ScaleRing
      }).color($r('app.color.text_secondary'))
        .width(this.hWidth)
        .style({ strokeWidth: 2 })
    }
  }
}