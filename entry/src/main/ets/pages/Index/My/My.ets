import { HMCard, HMCardItem } from "../../../components"
import promptAction from "@ohos.promptAction"

@Preview
@Component
export struct My {
  build() {
    Column(){
      // 1.基本信息
      Column(){
        // 头像
        Image($r('app.media.ic_avatar_driver'))
          .width(68)
          .aspectRatio(1)
          .borderRadius(34)
          .backgroundColor(Color.White)
        Text('司机')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .lineHeight(25)
          .fontColor($r('app.color.white'))
          .margin({top:9,bottom:9})
        Text('司机编号：111111')
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
        Text('手机号：111111')
          .fontSize(14)
          .fontWeight(400)
          .lineHeight(20)
          .fontColor($r('app.color.white'))
          .margin({top:9})
      }.backgroundImage($r('app.media.bg_page_my'))
      .backgroundImageSize(ImageSize.Cover)
      .width('100%')
      .height(292)
      .margin({top:-2})
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

      // 2.本月任务
      Column(){
        Text('-本月任务-')
          .fontSize(14)
          .fontColor($r('app.color.text_secondary'))
          .lineHeight(20)
        Row(){
          Column({space:17}){
            Text('1000')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('任务总量')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }
          Column({space:17}){
            Text('1000')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('完成任务量')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }
          Column({space:17}){
            Text('1000')
              .fontSize(18)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(25)
            Text('运输里程(km)')
              .fontSize(12)
              .fontColor($r('app.color.text_primary'))
              .lineHeight(17)
          }
        }.width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .margin({top:9})
      }.backgroundColor($r('app.color.white'))
      .height(134)
      .borderRadius(8)
      .margin({top:-55,left:13,right:13,bottom:13})
      .padding(13)

      // 3.综合信息
      HMCard(){
        HMCardItem({leftText:"车辆信息",rightText:"沪A xxxxx"})
        HMCardItem({leftText:'任务数据',rightText:"1000",showRightIcon:false})
        HMCardItem({leftText:'系统设置',click:()=>{
          promptAction.showToast({message:'点击系统设置'})
        },showBorder:false})
      }
    }.width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_page'))
  }
}