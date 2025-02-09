import { HMCard, HMCardItem, HMNavBar, HMUpload } from '../../components';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';

@Entry
@Component
struct ExceptionReport {
  @State maxSizeNumber: number = 50;

  build() {
    Column() {
      Row().width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))

      HMNavBar({ title: '上报异常' })

      Scroll() {
        Column() {
          HMCard() {
            HMCardItem({
              leftText: '异常时间', rightText: "请选择", click: () => {
              }
            })
            HMCardItem({
              leftText: '上报位置', rightText: "请选择", click: () => {
              }
            })
            HMCardItem({
              leftText: '异常类型', rightText: '请选择', click: () => {
              }
            })
            HMCardItem({
              leftText: '异常描述',
              rightText: '',
              showRightIcon: false,
              showBorder: false
            })

            TextArea({ placeholder: '请输入异常描述' })
              .backgroundColor($r('app.color.background_page'))
              .height(130)
              .fontSize(14)
              .placeholderColor($r('app.color.text_secondary'))
              .maxLength(this.maxSizeNumber)
              .borderRadius(8)
              .onChange((value) => {
              })
            Text(`0/${this.maxSizeNumber}`)
              .textAlign(TextAlign.End)
              .width('100%')
              .margin({ top: -30 })
              .padding({ right: 15 })
            Row()
              .height(30)
          }

          HMCard() {
            HMUpload({
              title: '上传图片(最多六张)',
              maxNumber: 6
            })
            Row()
              .height(30)
          }
        }
        .padding({ bottom: 200 })
      }
      .scrollBar(BarState.Off)

      Row() {
        Button('提交')
          .height(50)
          .width(200)
          .backgroundColor($r('app.color.primary'))
          .enabled(false)
          .onClick(() => {
          })
      }
      .padding({ left: 15, right: 15 })
      .width('100%')
      .height(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT)))
      .position({ y: '100%' })
      .translate({ y: -(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT))) })
      .justifyContent(FlexAlign.Center)
      .backgroundColor($r('app.color.white'))
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}