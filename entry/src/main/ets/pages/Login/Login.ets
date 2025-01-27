@Entry
@Component
struct Login {
  @State message: string = '登录页';

  build() {
    RelativeContainer() {
      Text(this.message)
        .id('LoginHelloWorld')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: '__container__', align: VerticalAlign.Center },
          middle: { anchor: '__container__', align: HorizontalAlign.Center }
        })
    }
    .height('100%')
    .width('100%')
  }
}