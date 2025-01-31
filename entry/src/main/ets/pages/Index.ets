import { TabClass } from '../models'

@Entry
@Component
struct Index {
  @State tabsData:TabClass[] = [
    {
      title:'任务',
      name:'task',
      icon:$r('app.media.ic_tab_btn_task')
    },
    {
      title:'消息',
      name:'message',
      icon:$r('app.media.ic_tab_btn_mess_nor')
    },
    {
      title:'我的',
      name:'my',
      icon:$r('app.media.ic_tab_btn_mine_nor')
    }
  ]

  @Builder
  getTabBar(item:TabClass){
    Column(){
      Image(item.icon).width(22).height(22)
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({top:5})
    }
  }

  build() {
    Tabs({barPosition:BarPosition.End}){

      ForEach(this.tabsData,(item:TabClass,index)=>{
        TabContent(){
          if (item.name === 'task') {
            Text('任务内容')
          }else if (item.name === 'message'){
            Text('消息内容')
          }else {
            Text("我的内容")
          }
        }.tabBar(this.getTabBar(item))
      })

    }
  }
}