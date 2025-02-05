import { HMNavBar } from '../../components'
import router from '@ohos.router'
import { CommonRouterParams } from '../../models'

// 任务详情页
@Entry
@Component
struct TaskDetail {
  jobId: string = '4072311102831552386'

  aboutToAppear(): void {
    const params = router.getParams() as CommonRouterParams
    if (params && params.id) {
      this.jobId = params.id
    }
  }

  build() {
    Column() {
      HMNavBar({ title: "任务详情" })
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}