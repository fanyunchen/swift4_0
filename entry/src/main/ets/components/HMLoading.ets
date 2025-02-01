// 加载
@Component
export struct HMLoading {
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
    Progress({
      value: 0,
      total: 100,
      type: ProgressType.ScaleRing
    }).color($r('app.color.text_secondary'))
      .width(this.hWidth)
      .style({ strokeWidth: 2 })
  }
}