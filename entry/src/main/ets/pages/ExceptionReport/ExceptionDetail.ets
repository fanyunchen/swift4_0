import { HMCard, HMCardItem, HMNavBar } from '../../components'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'
import { CommonRouterParams, ExceptionList, ExceptionListModel, ImageList } from '../../models'
import router from '@ohos.router'

@Entry
@Component
struct ExceptionDetail {
  @State exceptionForm: ExceptionList = {} as ExceptionList

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.exceptionDetail) {
      this.exceptionForm = params.exceptionDetail
    }
  }

  build() {
    Column() {
      Row()
        .width('100%')
        .height(AppStorage.get(APP_TOP_HEIGHT))
        .backgroundColor($r('app.color.white'))
      HMNavBar({ title: '异常详情' })
      Scroll() {
        Column() {
          HMCard() {
            HMCardItem({ leftText: '异常时间', rightText: this.exceptionForm.exceptionTime, showRightIcon: false })
            HMCardItem({ leftText: '上报位置', rightText: this.exceptionForm.exceptionPlace, showRightIcon: false })
            HMCardItem({ leftText: '异常类型', rightText: this.exceptionForm.exceptionType, showRightIcon: false })
            HMCardItem({ leftText: '异常描述', showRightIcon: false, showBorder: false })
            Row() {
              Text(this.exceptionForm?.exceptionDescribe || '用户未描述异常信息')
                .fontSize(14)
                .fontColor($r('app.color.text_primary'))
            }.width('100%')
            .padding(15)
            .justifyContent(FlexAlign.Start)
          }

          HMCard() {
            Text('异常图片')
              .width('100%')
              .padding(10)
            if (this.exceptionForm?.exceptionImagesList?.length > 0) {
              Flex({ wrap: FlexWrap.Wrap, direction: FlexDirection.Row }) {
                ForEach(this.exceptionForm.exceptionImagesList, (item: ImageList) => {
                  Image(item.url)
                    .width(100)
                    .aspectRatio(1)
                    .borderRadius(8)
                    .margin({ right: 15, top: 15 })
                })
              }
              .width('100%')
              .padding(15)
            } else {
              Row() {
                Text('用户未上传异常图片')
                  .fontColor($r('app.color.text_primary'))
                  .fontSize(14)
              }
              .width('100%')
              .padding(15)
              .justifyContent(FlexAlign.Start)
            }
          }

          Row()
            .width('100%')
            .height(100)
        }
        .layoutWeight(1)
      }
      .scrollBar(BarState.Off)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}