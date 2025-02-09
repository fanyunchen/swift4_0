import { getTaskDetail } from '../../api';
import { HMCard, HMCardItem, HMCheckBox, HMLoading, HMNavBar } from '../../components';
import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants';
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models';
import router from '@ohos.router';

@Entry
@Component
struct CarRecord {
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)
  @State show: boolean = false // 页面是否显示

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
            rightText: '请选择',
            showBorder: false,
            click: () => {
              DatePickerDialog.show({
                showTime: true,
                useMilitaryTime: true,
                alignment: DialogAlignment.Bottom,
                onDateAccept: (date) => {
                  AlertDialog.show({ message: JSON.stringify(date) })
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