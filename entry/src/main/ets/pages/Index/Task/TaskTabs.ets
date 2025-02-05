import { TabClass } from "../../../models"
import { TaskList } from "./TaskList"
import router from "@ohos.router"
import { APP_TOP_HEIGHT } from "../../../constants"

@Component
export struct TaskTabs {
  @State tabsData: TabClass[] = [
    {
      title: '待提货',
      name: 'waiting'
    },
    {
      title: '在途',
      name: 'line'
    },
    {
      title: '已完成',
      name: 'finish'
    }
  ]
  @State currentIndex: number = 0

  @Builder
  getTabBar(item: TabClass, index: number) {
    Column() {
      Text(item.title)
        .fontWeight(this.currentIndex === index ? FontWeight.Bold : 400)
        .fontSize(this.currentIndex === index ? 18 : 16)
        .fontColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.text_secondary'))
        .lineHeight(50)
        .height(50)
        .animation({
          duration: 300
        })
      Divider()
        .strokeWidth(4)
        .color($r('app.color.primary'))
        .lineCap(LineCapStyle.Round)
        .width(this.currentIndex === index ? 25 : 0)
        .animation({
          duration: 300
        })
    }
    // 避免上下对称，自己设置tabBar与tabs绑定，产生错开效果
    .onClick(() => {
      this.currentIndex = index
    })
  }

  build() {
    Stack({ alignContent: Alignment.Top }) {
      // index: $$this.currentIndex：tabs与this.currentIndex双向绑定，达到一个切换另一个随之切换
      Tabs({ barPosition: BarPosition.Start, index: $$this.currentIndex }) {
        ForEach(this.tabsData, (item: TabClass, index) => {
          TabContent() {
            if (item.name === "waiting") {
              // 待提货区域
              Column() {
                Button('详情')
                  .onClick(() => {
                    router.pushUrl({ url: "pages/TaskDetail/TaskDetail" })
                  })
                TaskList()
              }
            } else if (item.name === "line") {
              // 在途区域
            } else {
              // 已完成区域
            }
          }.tabBar(this.getTabBar(item, index))

        })
      }.onChange((index) => {
        this.currentIndex = index
      })
      .padding({ top: AppStorage.get<number>(APP_TOP_HEIGHT) })
      .backgroundColor($r('app.color.background_page'))
      .animationDuration(300)

      // 避免上下对称，自己设置tabBar与tabs绑定，产生错开效果
      Row({ space: 30 }) {
        ForEach(this.tabsData, (item: TabClass, index) => {
          this.getTabBar(item, index)
        })
      }
      .width('100%')
      .height(55)
      .zIndex(999)
      .backgroundColor($r('app.color.background_page'))
      .padding({ left: 20 })
      .margin({ top: AppStorage.get<number>(APP_TOP_HEIGHT) })
    }
  }
}