import { APP_BOTTOM_HEIGHT, APP_TOP_HEIGHT } from '../../constants'
import { TabClass } from '../../models'
import { My } from './My/My'
import { TaskTabs } from './Task/TaskTabs'

@Entry
@Component
struct Index {
  @State tabsData: TabClass[] = [
    {
      title: '任务',
      name: 'task',
      icon: $r('app.media.ic_tab_btn_task')
    },
    {
      title: '消息',
      name: 'message',
      icon: $r('app.media.ic_tab_btn_mess_nor')
    },
    {
      title: '我的',
      name: 'my',
      icon: $r('app.media.ic_tab_btn_mine_nor')
    }
  ]
  @State currentIndex: number = 0 // 默认选中的导航

  @Builder
  getTabBar(item: TabClass, index: number) {
    Column() {
      Image(item.icon).width(22).height(22)
        .fillColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({ top: 5 })
        .fontColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.text_secondary'))
    }
  }

  build() {
    Stack() {
      Tabs({ barPosition: BarPosition.End }) {
        ForEach(this.tabsData, (item: TabClass, index) => {
          TabContent() {
            if (item.name === 'task') {
              TaskTabs()
            } else if (item.name === 'message') {
              Text('消息内容')
            } else {
              My()
            }
          }.tabBar(this.getTabBar(item, index))
        })
      }.onChange((index) => {
        this.currentIndex = index
      })
      .padding({ bottom: AppStorage.get<number>(APP_BOTTOM_HEIGHT) })
      .scrollable(false)
      .animationDuration(300)
    }
  }
}