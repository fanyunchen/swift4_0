import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskInfoItemModel, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TaskItemCard } from './TaskItemCard'
import { promptAction, router } from '@kit.ArkUI'
import { HMLoading } from '../../../components'

@Component
export struct TaskList {
  @State taskListData: TaskInfoItem[] = [] //返回的数据类型
  @State queryParams: TaskListParams = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5
  } as TaskListParams) //查询的参数
  allPage: number = 1 //总页数，
  @State loading: boolean = false //是否正在加载中
  @State refreshing: boolean = false //控制刷新组件的状态
  @State str: string = "未激活状态"
  @State refreshStatus: RefreshStatus = RefreshStatus.Inactive //记录下拉刷新的状态
  @State show: boolean = false

  //获取任务列表数据
  async getTaskList(append: boolean) {
    const result = await getTaskList(this.queryParams)
    if (result !== '' && result !== null) {
      this.allPage = result.pages //总页数
      if (append) {
        this.taskListData = this.taskListData.concat(result.items)
      } else {
        this.taskListData = result.items
      }
      if (result.items !== null) {
        this.show = true
      }
      this.queryParams.page++
    }
  }

  //为什么List加了onReachEnd之后，需要屏蔽该方法呢？
  //因为，List列表刚开始加载时是空的，也会触发onReachEnd事件，那么第一页的数据就会被查询2次，多余了
  aboutToAppear(): void {
    this.getTaskList(false)
  }

  @Builder
  getBottomDisplay() {
    Row({ space: 20 }) {
      if (this.loading) {
        Text(this.allPage < this.queryParams.page ? "已经没有数据啦" : "数据加载中")
          .fontSize(14)
          .fontColor($r("app.color.text_secondary"))
        if (this.allPage >= this.queryParams.page) {
          HMLoading({ hWidth: 20 })
        }
      }
    }
    .width('100%')
    .height(50)
    .justifyContent(FlexAlign.Center)
  }

  //刷新数据，重新获取第一页的数据
  async onRefresh() {
    this.queryParams.page = 1
    this.allPage = 1
    await this.getTaskList(false) //获取第一页的数据
    this.loading = false //这里需要注意：因为要考虑已经滑到底部的情况，此时loading=true，如果不开发这个状态，就不能再进行上拉加载了

    this.refreshing = false //关闭下拉的状态
    promptAction.showToast({ message: "刷新成功！" })
  }

  getStatusText() {
    switch (this.refreshStatus) {
      case RefreshStatus.Drag:
        return "继续下拉"
      case RefreshStatus.OverDrag:
        return "松手加载"
      case RefreshStatus.Refresh:
        return "加载中"
      default:
        return ""
    }
  }

  @Builder
  getRefreshDisplay() {
    //显示刷新的样式
    Row({ space: 10 }) {
      LoadingProgress()
        .width(40)
        .aspectRatio(1)
        .color($r("app.color.text_primary"))
      Text(this.getStatusText())
        .fontSize(14)
        .fontColor($r("app.color.text_secondary"))
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height(50)
  }

  build() {
    Refresh({ refreshing: $$this.refreshing, builder: this.getRefreshDisplay }) {
      if (this.show) {
        List() {
          ForEach(this.taskListData, (item: TaskInfoItemModel) => {
            ListItem() {
              TaskItemCard({ taskItemData: item })
            }
          })

          ListItem() {
            //列表底部显示加载的状态
            this.getBottomDisplay()
          }
        }
        //当List到底部的时候执行该数据，可以实现列表的上拉加载，其实就是获取下一页的数据
        .onReachEnd(async () => {
          //promptAction.showToast({ message: "我已经到底了，可以加载新数据了！" })
          if (this.allPage >= this.queryParams.page) { //查询的页码还没有超过总页
            if (!this.loading) {
              this.loading = true //当前加载
              await this.getTaskList(true)
              this.loading = this.allPage < this.queryParams.page ? true : false //当前完成了加载
            }
          }
        })
      } else {
        Column() {
          Text("...暂无提货数据...")
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }.width('100%')
        .height('100%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }

    }
    .onStateChange((status: RefreshStatus) => {
      this.refreshStatus = status //记录刷新状态
      if (status === RefreshStatus.Drag) {
        this.str = "往下拉"
      } else if (status === RefreshStatus.OverDrag) {
        this.str = "超过了刷新的距离"
      } else if (status === RefreshStatus.Refresh) {
        this.str = "松手刷新中"
        // setTimeout(() => {
        //   this.refreshing = false
        // }, 2000)

        //重新获取第一页的数据
        this.onRefresh()

      } else if (status === RefreshStatus.Done) {
        this.str = "刷新结束了！"
      }
    })
  }
}