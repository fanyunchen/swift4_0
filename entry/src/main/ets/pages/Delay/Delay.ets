import { HMCard, HMCardItem, HMDateDialog, HMNavBar } from '../../components'
import { APP_TOP_HEIGHT } from '../../constants'
import router from '@ohos.router'
import { CommonRouterParams, DelayParams, DelayParamsModel } from '../../models'
import dayjs from '@hview/dayjs'
import { delay } from '../../api'
import promptAction from '@ohos.promptAction'

@Entry
@Component
struct Delay {
  @State maxSizeNumber: number = 50
  @State oldTime: string = ''
  @State delayForm: DelayParamsModel = new DelayParamsModel({} as DelayParams)
  dateDialog: CustomDialogController = new CustomDialogController({
    builder: HMDateDialog({
      oldTime: new Date(this.oldTime),
      action: (time) => {
        this.delayForm.delayTime = dayjs(time).format("YYYY-MM-DD HH:mm:ss")
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Bottom,
    autoCancel: false
  })

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id && params.oldTime) {
      this.oldTime = params.oldTime
      this.delayForm.id = params.id
    }
  }

  /**
   * 提交延迟提货
   */
  async btnDelay() {
    try {
      await delay(this.delayForm)
      promptAction.showToast({ message: '延迟提货成功' })
      router.back()
    } catch (err) {
      AlertDialog.show({ message: '延迟提货失败:' + JSON.stringify(err.message) })
    }
  }

  build() {
    Column() {
      Row().width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))

      HMNavBar({ title: '延迟提货' })

      HMCard() {
        HMCardItem({ leftText: '原定时间', rightText: this.oldTime, showRightIcon: false })
        HMCardItem({
          leftText: '延迟时间', rightText: this.delayForm.delayTime || "不可超过2个小时", click: () => {
            this.dateDialog.open()
          }
        })

        TextArea({ placeholder: '请输入延迟提货原因', text: this.delayForm.delayReason })
          .backgroundColor($r('app.color.background_page'))
          .height(130)
          .fontSize(14)
          .margin({ top: 20 })
          .placeholderColor($r('app.color.text_secondary'))
          .maxLength(this.maxSizeNumber)
          .borderRadius(8)
          .onChange((value) => {
            this.delayForm.delayReason = value
          })
        Text(`${this.delayForm.delayReason?.length || 0}/${this.maxSizeNumber}`)
          .textAlign(TextAlign.End)
          .width('100%')
          .margin({ top: -30 })
          .padding({ right: 15 })

        Row() {
          Button('提交')
            .height(50)
            .width(200)
            .backgroundColor($r('app.color.primary'))
            .enabled(!!(this.delayForm.delayReason && this.delayForm.delayTime))
            .onClick(() => {
              this.btnDelay()
            })
        }.padding({ top: 20, bottom: 20 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}