import { HMNavBar, HMToggleCard } from '../../components'
import router from '@ohos.router'
import { CommonRouterParams, TaskDetailInfo, TaskDetailInfoModel } from '../../models'
import { getTaskDetail } from '../../api'

// 任务详情页
@Entry
@Component
struct TaskDetail {
  scroller: Scroller = new Scroller()
  jobId: string = '4072311102831552386'
  @State taskDetailData: TaskDetailInfoModel = new TaskDetailInfoModel({} as TaskDetailInfo)

  /**
   * 根据任务id获取任务详情
   * @param id  任务id
   */
  async getTaskDetail(id: string) {
    const result = await getTaskDetail(id)
    if (result !== '' && result !== null) {
      this.taskDetailData = result
    }
  }

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.jobId = params.id
    }
    this.getTaskDetail(this.jobId)
  }

  build() {
    Column() {
      HMNavBar({ title: "任务详情" })

      Scroll(this.scroller) {
        Column() {
          // 基本信息
          HMToggleCard({ title: "基本信息" }) {
            Text(JSON.stringify(this.taskDetailData, null, 2))
          }

          HMToggleCard({ title: "车辆司机信息", toggleCard: false }) {
            Text(JSON.stringify(this.taskDetailData, null, 2))
          }

          HMToggleCard({ title: "运输路线", toggleCard: false }) {
            Text(JSON.stringify(this.taskDetailData, null, 2))
          }
        }
        .padding({ bottom: 120 })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}