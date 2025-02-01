import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TaskItemCard } from './TaskItemCard'
import { HMLoading } from '../../../components'

@Component
export struct TaskList {
  // 没有数据时list的滑动控制器
  nullScroller: Scroller = new Scroller()
  // 有数据时list的滑动控制器
  scroller: Scroller = new Scroller()
  // 总页数
  allPages: number = 1
  // 接收获取到的任务列表
  @State taskListData: TaskInfoItem[] = []
  // 请求参数
  @State queryParams: TaskListParamsModel = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5
  } as TaskListParams)
  // 查询下一页的请求参数
  @State nextQueryParams: TaskListParamsModel = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 2,
    pageSize: 5
  } as TaskListParams)
  @State endLoading: boolean = false // 是否在加载中
  @State startLoading: boolean = false // 是否在加载中

  // 获取待提货的任务数据列表
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    if (result !== '' && result !== null) {
      console.log('hmlog-->', "getTaskList result:" + JSON.stringify(result))
      this.taskListData = result.items
    }
  }

  // 查询下一页数据
  async getNextTaskList() {
    const result = await getTaskList(this.nextQueryParams)
    if (result !== '' && result !== null) {
      console.log('hmlog-->', "getTaskList result:" + JSON.stringify(result))
      this.taskListData = this.taskListData.concat(result.items)
    }

    this.nextQueryParams.page++
  }

  aboutToAppear(): void {
    this.getTaskList()
  }

  @Builder
  getBottomDisplay() {
    Row({ space: 20 }) {
      if (this.endLoading) {
        Text(this.allPages < this.nextQueryParams.page ? "我已经到底啦！" : "数据加载中...")
        if (this.allPages >= this.nextQueryParams.page) {
          HMLoading({ hWidth: 20 })
        }
      }
    }.width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
    .alignItems(VerticalAlign.Center)
  }

  build() {
    if (this.taskListData !== null) {
      List({ scroller: this.scroller, initialIndex: 1 }) {
        // 顶部刷新
        ListItem() {
          Column() {
            LoadingProgress()
              .width(40)
              .aspectRatio(1)
          }.height(30)
          .width('100%')
        }.height(30)

        ForEach(this.taskListData, (item: TaskInfoItem) => {
          ListItem() {
            TaskItemCard({ taskItemData: item })
          }
        })

        // 底部加载
        ListItem() {
          this.getBottomDisplay()
        }
      }
      // 当list到底部时触发，可实现上拉加载新数据（获取下一页数据）
      .onReachEnd(async () => {
        if (this.allPages >= this.nextQueryParams.page) {
          // 查询的页码没有超过总页数
          if (!this.endLoading) {
            // 当前加载中
            this.endLoading = true
            await this.getNextTaskList()
            // 当前加载完毕
            this.endLoading = this.allPages < this.nextQueryParams.page ? true : false
          }
        }
      })
      // 当list到顶部时触发，可实现上拉刷新数据
      .onReachStart(async () => {
        if (!this.startLoading) {
          this.startLoading = true
          // 刷新数据
          await this.getTaskList()
          this.nextQueryParams.page = 2
          const timer = setTimeout(() => {
            this.nullScroller.scrollToIndex(1)
            this.startLoading = false
            clearTimeout(timer)
          }, 2000)
        }
      })
    } else {
      List({ scroller: this.nullScroller, initialIndex: 1 }) {
        ListItem() {
          Column() {
            LoadingProgress()
              .width(40)
              .aspectRatio(1)
          }.height(30)
          .width('100%')
        }.height(30)

        ListItem() {
          Column() {
            Text('--暂无待提货数据--')
              .fontSize(25)
              .fontWeight(600)
          }.width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }.width('100%')
        .height('100%')
      }
      .onReachStart(async () => {
        if (!this.startLoading) {
          this.startLoading = true
          // 刷新数据
          await this.getTaskList()
          this.nextQueryParams.page = 2
          const timer = setTimeout(() => {
            this.nullScroller.scrollToIndex(1)
            this.startLoading = false
            clearTimeout(timer)
          }, 2000)
        }
      })
      .width('100%')
      .height('100%')
      .scrollBar(BarState.Off)
    }
  }
}