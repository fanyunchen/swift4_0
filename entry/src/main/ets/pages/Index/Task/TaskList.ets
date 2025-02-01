import { getTaskList } from '../../../api'
import { TaskInfoItem, TaskListParams, TaskListParamsModel, TaskTypeEnum } from '../../../models'
import { TaskItemCard } from './TaskItemCard'

@Component
export struct TaskList {
  // 接收获取到的任务列表
  @State taskListData: TaskInfoItem[] = []
  // 请求参数
  @State queryParams: TaskListParamsModel = new TaskListParamsModel({
    status: TaskTypeEnum.Waiting,
    page: 1,
    pageSize: 5
  } as TaskListParams)

  // 获取待提货的任务数据列表
  async getTaskList() {
    const result = await getTaskList(this.queryParams)
    if (result !== '' && result !== null) {
      console.log('hmlog-->', "getTaskList result:" + JSON.stringify(result))
      this.taskListData = result.items
    }
  }

  aboutToAppear(): void {
    this.getTaskList()
  }

  build() {
    List() {
      ForEach(this.taskListData, (item: TaskInfoItem) => {
        ListItem() {
          TaskItemCard()
        }
      })
    }
  }
}