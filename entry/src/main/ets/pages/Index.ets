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
  @State currentIndex :number = 0   // 默认选中的导航

  @Builder
  getTabBar(item:TabClass,index:number){
    Column(){
      Image(item.icon).width(22).height(22)
        .fillColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.text_secondary'))
      Text(item.title)
        .fontSize(12)
        .fontWeight(400)
        .margin({top:5})
        .fontColor(index === this.currentIndex ? $r('app.color.primary') : $r('app.color.text_secondary'))
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
        }.tabBar(this.getTabBar(item,index))
      })
    }.onChange((index)=>{
      this.currentIndex = index
    })
    .animationDuration(300)
  }
}