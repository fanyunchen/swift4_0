import { carRecord, getTaskDetail } from '../../api';
import { HMCard, HMCardItem, HMCheckBox, HMLoading, HMNavBar } from '../../components';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import {
  CarRecordParams,
  CarRecordParamsModel,
  CommonRouterParams,
  TaskDetailInfo,
  TaskDetailInfoModel
} from '../../models';
import router from '@ohos.router';
import dayjs from '@hview/dayjs'
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct CarRecord {
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State carRecord: CarRecordParamsModel = new CarRecordParamsModel({} as CarRecordParams)
  @State show: boolean = false // 页面是否显示
  layer: CustomDialogController = new CustomDialogController({
    builder: HMLoading({ loadingText: "回车登记处理中..." }),
    customStyle: true,
    autoCancel: false,
    alignment: DialogAlignment.Center
  })

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.getTaskDetail(params.id)
    }
  }

  /**
   * 获取任务详情
   * @param id  任务id
   */
  async getTaskDetail(id: string) {
    const result = await getTaskDetail(id)
    if (result !== '' && result !== null) {
      this.taskDetailData = result
      this.show = true
    }
  }

  /**
   * 实现交车
   */
  async btnRecord() {
    // 数据准备
    this.carRecord.id = this.taskDetailData.transportTaskId
    this.carRecord.startTime = this.taskDetailData.actualDepartureTime

    // 检验是否数据齐全
    if (!this.carRecord.endTime) {
      promptAction.showToast({ message: '请选择回车时间' })
      return
    }

    // 打开遮罩层,告诉用户正在回车登记中
    this.layer.open()

    try {
      await carRecord(this.carRecord)
      promptAction.showToast({ message: '回车登记成功!' })
      router.clear()
      router.replaceUrl({ url: "pages/Index/Index" })
    } catch (err) {
      AlertDialog.show({ message: '回车登记失败' + JSON.stringify(err.message) })
    } finally {
      this.layer.close()
    }
  }

  build() {
    Column() {
      if (this.show) {
        Row().width('100%')
          .height(AppStorage.get<number>(APP_TOP_HEIGHT))
          .backgroundColor($r('app.color.white'))
        HMNavBar({ title: "回车登记" })
        HMCard() {
          HMCardItem({
            leftText: "出车时间",
            rightText: this.taskDetailData.actualDepartureTime || '',
            showRightIcon: false
          })

          HMCardItem({
            leftText: "回车时间",
            rightText: this.carRecord.endTime || '请选择',
            showBorder: false,
            click: () => {
              DatePickerDialog.show({
                showTime: true,
                useMilitaryTime: true,
                alignment: DialogAlignment.Bottom,
                onDateAccept: (date: Date) => {
                  // AlertDialog.show({ message: JSON.stringify(date.getHours()) })
                  // const year = JSON.stringify(date).split("T")[0]
                  // const time = JSON.stringify(date).split("T")[1]
                  // const timer = time.split('.')[0]
                  // // AlertDialog.show({ message: JSON.stringify(date) })
                  // AlertDialog.show({ message: year + ' ' + timer })
                  // 第三方库dayjs,进行时间日期的转换
                  // 1.导入依赖: ohpm install @hview/dayjs
                  // 2.使用: import dayjs from '@hview/dayjs'
                  //        dayjs(value).format("格式化")
                  this.carRecord.endTime = dayjs(date).format("YYYY-MM-DD HH:mm:ss")
                }
              })
            }
          })

          HMCheckBox({ title: '车辆违章', value: false })
          HMCheckBox({ title: '车辆故障', value: false })
          HMCheckBox({ title: '车辆事故', value: false })
        }

        Row() {
          Button('交车')
            .backgroundColor($r('app.color.primary'))
            .width(200)
            .height(50)
            .enabled(!!this.carRecord.endTime)
            .onClick(() => {
              this.btnRecord()
            })
        }
        .position({ y: '100%' })
        .translate({ y: -(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT))) })
        .height(70 + Number(AppStorage.get<number>(APP_BOTTOM_HEIGHT)))
        .width('100%')
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .backgroundColor($r('app.color.white'))
      } else {
        HMLoading({ loadingText: "数据加载中..." })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}