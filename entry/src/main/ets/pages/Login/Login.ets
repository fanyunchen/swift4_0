@Entry
@Component
struct Login {
  @State showLoading: boolean = false;

  build() {
    Column() {
      // 标题
      Text('顺风速达')
        .fontColor($r('app.color.text_primary'))
        .fontSize(18)
        .height(25)

      Row() {
        Text('账号登录')
          .fontColor($r('app.color.text_primary'))
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
        Row() {
          Text('账号登录')
            .fontColor($r('app.color.primary'))
            .fontWeight(FontWeight.Bold)
          Image($r('app.media.ic_angle'))
            .width(10)
            .aspectRatio(1)
            .margin({ left: 5 })
        }
      }.width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 50, bottom: 50 })

      TextInput({ placeholder: '请输入账号' })
        .inputStyles()

      TextInput({ placeholder: '请输入密码' })
        .inputStyles()
        .type(InputType.Password)

      Button() {
        Row() {
          if (this.showLoading) {
            LoadingProgress()
              .width(30)
              .height(30)
              .color($r('app.color.white'))
              .margin({ right: 12 })
          }
          Text('登录')
            .fontColor($r('app.color.white'))
        }
      }
      .width("100%")
      .height(45)
      .margin({ top: 50 })
      .backgroundColor($r('app.color.primary'))
      .onClick(()=>{
        this.showLoading = true
      })
    }
    .height('100%')
    .width('100%')
    .padding({ left: 32, right: 32 })
    .margin({ top: 40 })
  }

  @Styles
  inputStyles(){
    .backgroundColor(Color.White)
    .border({
      width: {
        bottom: 1
      },
      color: $r('app.color.background_divider')
    })
    .width('100%')
    .height(58)
    .borderRadius(0)
  }
}