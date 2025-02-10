import { HMLoading, HMNavBar, HMToggleCard, HMUpload, UploadFile } from '../../components'
import router from '@ohos.router'
import {
  CommonRouterParams,
  DeliverParams,
  DeliverParamsModel,
  ImageList,
  PickUpParamsModel,
  TaskDetailInfo,
  TaskDetailInfoModel,
  TaskTypeEnum
} from '../../models'
import { deliver, getTaskDetail, pickUp } from '../../api'
import { call } from '@kit.TelephonyKit'
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'
import promptAction from '@ohos.promptAction'

// 任务详情页
@Entry
@Component
struct TaskDetail {
  scroller: Scroller = new Scroller()
  jobId: string = '' //'4072311102831552386'
  layer: CustomDialogController = new CustomDialogController({
    builder: HMLoading({ loadingText: "数据处理中，请耐心等待！" }),
    customStyle: true,
    alignment: DialogAlignment.Center
  })
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State show: boolean = false

  /**
   * 根据任务id获取任务详情
   * @param id  任务id
   */
  async getTaskDetail(id: string) {
    this.show = false
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
    HMUpload({
      title: '请拍照上传回单凭证',
      imgList: this.taskDetailData.cargoPickUpPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPickUpPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
    HMUpload({
      title: '请拍照上传货品凭证',
      imgList: this.taskDetailData.cargoPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.cargoPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Waiting
    })
  }

  /**
   * 交货信息
   */
  @Builder
  getDeliverContent() {
    HMUpload({
      title: '请拍照上传交货凭证',
      imgList: this.taskDetailData.certificatePictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.certificatePictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
    HMUpload({
      title: '请拍照上传交货货品凭证',
      imgList: this.taskDetailData.deliverPictureList || [],
      onListChange: (list: ImageList[]) => {
        this.taskDetailData.deliverPictureList = list
      },
      canUpload: this.taskDetailData.status === TaskTypeEnum.Line
    })
  }

  /**
   * 底部按钮
   */
  @Builder
  getButtonBtn() {
    Row() {
      if (this.taskDetailData.status === TaskTypeEnum.Waiting) {
        Button('延迟提货')
          .backgroundColor($r('app.color.btn_gray'))
          .height(50)
          .fontColor($r('app.color.text_primary'))
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/Delay/Delay',
              params: {
                id: this.taskDetailData.id,
                oldTime: this.taskDetailData.planDepartureTime
              }
            })
          })
        Button('提货')
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .enabled(this.getPickUpState())
          .layoutWeight(1)
          .onClick(() => {
            this.btnPickUp()
          })
          .margin({ left: 20 })
      } else if (this.taskDetailData.status === TaskTypeEnum.Line) {
        Button('上报异常')
          .backgroundColor($r('app.color.btn_gray'))
          .height(50)
          .fontColor($r('app.color.text_primary'))
          .width(125)
          .onClick(() => {
            router.pushUrl({
              url: 'pages/ExceptionReport/ExceptionReport',
              params: {
                id: this.taskDetailData.id
              }
            })
          })
        Button('交货')
          .backgroundColor($r('app.color.primary'))
          .fontColor($r('app.color.white'))
          .height(50)
          .enabled(this.getDeliverState())
          .layoutWeight(1)
          .onClick(() => {
            this.btnDeliver()
          })
          .margin({ left: 20 })
      } else if (this.taskDetailData.status === TaskTypeEnum.Delivered) {
        Row() {
          Button('回车登记')
            .backgroundColor($r('app.color.primary'))
            .fontColor($r('app.color.white'))
            .height(50)
            .width('80%')
            .onClick(() => {
              router.pushUrl({
                url: 'pages/CarRecord/CarRecord',
                params: {
                  id: this.taskDetailData.id
                }
              })
            })
        }.width('100%')
        .justifyContent(FlexAlign.Center)
      }
    }
    .padding({ left: 15, right: 15 })
    .width('100%')
    .height(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT)))
    .position({ y: '100%' })
    .translate({ y: -(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT))) })
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor($r('app.color.white'))
  }

  // 获取提货按钮可用状态
  getPickUpState() {
    if (this.taskDetailData.cargoPickUpPictureList?.length > 0
      && this.taskDetailData.cargoPictureList?.length > 0
      && this.taskDetailData.cargoPickUpPictureList.every(item =>!!item.url)
      && this.taskDetailData.cargoPictureList.every(item =>!!item.url)) {
      return true
    }
    return false
  }

  // 获取交货按钮可用状态
  getDeliverState() {
    if (this.taskDetailData.deliverPictureList?.length > 0
      && this.taskDetailData.certificatePictureList?.length > 0
      && this.taskDetailData.deliverPictureList.every(item =>!!item.url)
      && this.taskDetailData.certificatePictureList.every(item =>!!item.url)) {
      return true
    }
    return false
  }

  // 实现提货功能
  async btnPickUp() {
    try {
      this.layer.open()
      // 1.图片上传：将本地相册中的图片地址，上传到服务器获取到永久的图片地址
      const cargoPickUpPictureList =
        await UploadFile(this.taskDetailData.cargoPickUpPictureList) // 提货凭证照片，获取永久地址
      const cargoPictureList = await UploadFile(this.taskDetailData.cargoPictureList) // 提货照片获取永久地址

      console.log('hmlog-->', JSON.stringify(cargoPickUpPictureList))
      console.log('hmlog-->', JSON.stringify(cargoPictureList))

      // 2.实现提货功能
      await pickUp(new PickUpParamsModel({
        id: this.taskDetailData.id,
        cargoPickUpPictureList: cargoPickUpPictureList,
        cargoPictureList: cargoPictureList
      }))

      // 重新加载数据
      this.getTaskDetail(this.taskDetailData.id)

      this.scroller.scrollEdge(Edge.Top)

      promptAction.showToast({ message: '提货成功！', duration: 2000 })
    } catch (err) {
      AlertDialog.show({ message: '提货失败！' + JSON.stringify(err.message) })
    } finally {
      this.layer.close()
    }

  }

  // 实现交货功能
  async btnDeliver() {
    try {
      this.layer.open()
      // 1.图片上传：将本地相册中的图片地址，上传到服务器获取到永久的图片地址
      const certificatePictureList =
        await UploadFile(this.taskDetailData.certificatePictureList) // 提货凭证照片，获取永久地址
      const deliverPictureList = await UploadFile(this.taskDetailData.deliverPictureList) // 提货照片获取永久地址

      // 2.实现交货功能
      await deliver(new DeliverParamsModel({
        id: this.taskDetailData.id,
        certificatePictureList: certificatePictureList,
        deliverPictureList: deliverPictureList
      } as DeliverParams))

      // 重新加载数据
      this.getTaskDetail(this.taskDetailData.id)

      this.scroller.scrollEdge(Edge.Top)

      promptAction.showToast({ message: '交货成功！', duration: 2000 })
    } catch (err) {
      AlertDialog.show({ message: '交货失败！' + JSON.stringify(err.message) })
    } finally {
      this.layer.close()
    }

  }

  build() {
    if (this.show) {
      Column() {
        Row().width('100%')
          .height(AppStorage.get<number>(APP_TOP_HEIGHT))
          .backgroundColor($r('app.color.white'))

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

            if (this.taskDetailData.status === TaskTypeEnum.Waiting ||
              this.taskDetailData.status === TaskTypeEnum.Delivered) {
              HMToggleCard({ title: "提货信息", toggleCard: false }) {
                this.getTransLineContent()
              }
            }
            if (this.taskDetailData.status === TaskTypeEnum.Line ||
              this.taskDetailData.status === TaskTypeEnum.Delivered) {
              HMToggleCard({ title: "交货信息", toggleCard: false }) {
                this.getDeliverContent()
              }
            }
          }
          .padding({ bottom: 200 })
        }
        .scrollBar(BarState.Off)

        this.getButtonBtn()
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