import { HMNavBar, HMToggleCard } from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { getTaskDetail } from '../../api'
import { call } from '@kit.TelephonyKit'

// 任务详情页
@Entry
@Component
struct TaskDetail {
  scroller: Scroller = new Scroller()
  jobId: string = '4072311102831552386'
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State show: boolean = false

  /**
   * 根据任务id获取任务详情
   * @param id  任务id
   */
  async getTaskDetail(id: string) {
    const result = await getTaskDetail(id)
    if (result !== '' && result !== null) {
      this.taskDetailData = result
      this.show = true
    }
  }

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.jobId = params.id
    }
    this.getTaskDetail(this.jobId)
  }

  @Builder
  builderItem(item: basicFactsItemBuilderClass) {
    Row() {
      Text(item.title)
        .fontSize(14)
        .fontColor($r('app.color.text_secondary'))
        .lineHeight(20)

      Row() {
        Text(item.value)
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
        if (item.icon) {
          Image(item.icon)
            .width(24)
            .aspectRatio(1)
            .onClick(() => {
              item.action?.() // 等效于if（item.action）{item.action}
            })
        }
      }
    }.width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .margin({ top: 14 })
  }

  /**
   *  基本信息展示
   */
  @Builder
  basicFacts() {
    Column() {
      Row({ space: 30 }) {
        Column({ space: 15 }) {
          Row({ space: 15 }) {
            Text('起')
              .fontSize(12)
              .width(22)
              .height(22)
              .borderRadius(11)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.text_primary'))
              .textAlign(TextAlign.Center)

            Text(this.taskDetailData?.startAddress.toString())
              .fontSize(15)
              .fontColor($r('app.color.text_secondary'))
          }
          .alignItems(VerticalAlign.Center)

          Row({ space: 15 }) {
            Text('止')
              .fontSize(12)
              .width(22)
              .height(22)
              .borderRadius(11)
              .fontColor($r('app.color.white'))
              .backgroundColor($r('app.color.primary'))
              .textAlign(TextAlign.Center)
            Text(this.taskDetailData?.endAddress.toString())
              .fontSize(15)
              .fontColor($r('app.color.text_secondary'))
          }.alignItems(VerticalAlign.Center)
        }
        .width('60%')

        Column({ space: 5 }) {
          Image($r('app.media.ic_navigation'))
            .width(30)
            .aspectRatio(1)
          Text('开始导航')
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .padding({ top: 30 })

      Divider()
        .height(2)
        .color($r('app.color.background_divider'))
        .margin({ top: 20, left: 8, right: 8 })

      this.builderItem({ title: '任务编号', value: this.taskDetailData.transportTaskId })
      this.builderItem({ title: '联系人', value: this.taskDetailData.startHandoverName })
      this.builderItem({
        title: '联系电话',
        value: this.taskDetailData.startHandoverPhone,
        icon: $r('app.media.ic_phone'),
        action: () => {
          // AlertDialog.show({ message: '电话拨通中...' })
          // 拨打电话 点击切换到拨号界面，只能在真机中运行，模拟器中没反应
          call.makeCall(this.taskDetailData.startHandoverPhone)
        }
      })
      this.builderItem({ title: '提货时间', value: this.taskDetailData.planDepartureTime! })
      this.builderItem({ title: '预计送达时间', value: this.taskDetailData.planArrivalTime! })
    }.width('100%')
  }

  /**
   * 车辆司机信息展示
   */
  @Builder
  driverAndVehicle() {
    this.builderItem({ title: '车牌号', value: this.taskDetailData.licensePlate })
    this.builderItem({ title: '司机姓名', value: this.taskDetailData.driverName })
  }

  /**
   * 运输路线展示
   */
  @Builder
  transportRoute() {
    Row({ space: 30 }) {
      Column({ space: 5 }) {
        Text(this.taskDetailData.startProvince)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(this.taskDetailData.startCity)
          .fontSize(14)
      }

      Image($r('app.media.ic_right_arrow'))
        .width(40)
        .aspectRatio(1)

      Column({ space: 5 }) {
        Text(this.taskDetailData.endProvince)
          .fontSize(16)
          .fontWeight(FontWeight.Bold)
        Text(this.taskDetailData.endCity)
          .fontSize(14)
      }
    }.width('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  /**
   * 提货信息
   */
  @Builder
  getTransLineContent() {

  }

  build() {
    if (this.show) {
      Column() {
        HMNavBar({ title: "任务详情" })

        Scroll(this.scroller) {
          Column() {
            // 基本信息
            HMToggleCard({ title: "基本信息" }) {
              this.basicFacts()
            }

            HMToggleCard({ title: "车辆司机信息", toggleCard: false }) {
              this.driverAndVehicle()
            }

            HMToggleCard({ title: "运输路线", toggleCard: false }) {
              this.transportRoute()
            }

            HMToggleCard({ title: "提货信息", toggleCard: false }) {
              this.getTransLineContent()
            }
          }
          .padding({ bottom: 120 })
        }
      }
      .height('100%')
      .width('100%')
      .backgroundColor($r('app.color.background_page'))
    } else {
      Row({ space: 10 }) {
        Text("数据加载中...")
          .fontWeight(FontWeight.Bold)
        LoadingProgress()
          .width(35)
          .aspectRatio(1)
      }.width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)
    }
  }
}

class basicFactsItemBuilderClass {
  title: string = ''
  value: string = ''
  icon?: ResourceStr = ''
  action?: () => void = () => {
  }
}