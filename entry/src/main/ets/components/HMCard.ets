@Component
struct HMCard {
  @BuilderParam
  HMCardFn: () => void

  build() {
    Column() {
      Column() {
        if (this.HMCardFn) {
          this.HMCardFn()
        }
      }.width('100%')
      .backgroundColor($r('app.color.white'))
      .borderRadius(8)
      .padding({
        left: 14,
        right: 14
      })
    }.width('100%')
    .padding(15)
  }
}

export { HMCard }